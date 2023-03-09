//
//  StoreViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/27.
//

import Foundation
import CoreLocation
import Combine

final class StoreViewModel: ObservableObject {
    private let locationManager: LocationManager = LocationManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.0, longitude: 126.0)
    @Published var storeLocation: Store?
    @Published var areaName: String = ""
    @Published var needPermission: Bool = true
    
    init() {
        locationManager.needPermission
            .sink(receiveValue: { value in
                if !value {
                    self.needPermission = false
                    self.configure()
                } else {
                    self.needPermission = true
                }
            })
            .store(in: &cancellables)
    }
}

extension StoreViewModel {
    private func configure() {
        locationManager.currentCoordinate
            .sink(receiveValue: { value in
                self.currentCoordinate = value
                self.setStore()
            })
            .store(in: &cancellables)
    }
    
    private func setStore() {
        if currentCoordinate.longitude < 124.0 || currentCoordinate.longitude > 132.0 ||
            currentCoordinate.latitude < 33.0 || currentCoordinate.latitude > 43.0 {
            storeLocation = nil
            return
        }
        if storeLocation == nil {
            Task {
                do {
                    let addressData = try await locationManager.getCurrentAddress()
                    let address = try JSONDecoder().decode(Address.self, from: addressData)

                    if address.results.isEmpty { return }
                    let area = address.results[0].region.area3.name
                    
                    DispatchQueue.main.async {
                        self.areaName = area
                    }
                    
                    let storeData = try await locationManager.getStoreAAA(area)
                    let store = try JSONDecoder().decode(Store.self, from: storeData)
                    DispatchQueue.main.async {
                        self.storeLocation = store
                    }
                } catch (let error) {
                    print(error)
                }
            }
        }
    }
    
    func urlForNaverMap(_ isOpenApp: Bool) -> URL? {
        if isOpenApp {
            let urlString = "nmap://search?query=\(areaName)복권&appname=com.kim.allin"
            
            guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: encoded) else { return nil }
            return url
        } else {
            guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") else { return nil }
            return appStoreURL
        }
    }
}
