//
//  StoreViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/27.
//

import Foundation
import CoreLocation

final class StoreViewModel: ObservableObject {
    private let locationManager: LocationManager = LocationManager()
    
    @Published var currentCoordinate: CLLocationCoordinate2D
    @Published var storeLocation: Store?
    @Published var areaName: String = ""
    
    init() {
        currentCoordinate = locationManager.currentCoordinate
        Task {
            do {
                let addressData = try await locationManager.getCurrentAddress()
                let address = try JSONDecoder().decode(Address.self, from: addressData)
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

extension StoreViewModel {
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
