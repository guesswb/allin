//
//  StoreViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/27.
//

import Foundation
import CoreLocation

final class StoreViewModel: NSObject, ObservableObject {
    
    @Published var currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.554763, longitude: 126.97092)
    @Published var needPermission: Bool = true
    @Published var areaName: String = ""
    @Published var storeItems: [StoreItem] = []
    
    private let locationManager: CLLocationManager = CLLocationManager()
    private let word: String = "복권"
    
    enum AppStore {
        static func url(isInstalled: Bool, keyword: String = "") -> URL? {
            return isInstalled
            ? URL(string: "nmap://search?query=\(keyword)&appname=com.kim.allin".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            : URL(string: "http://itunes.apple.com/app/id311867728?mt=8")
        }
    }
    
    enum Location {
        static let koreaLongitude: ClosedRange = (124.0)...(132.0)
        static let koreaLatitude: ClosedRange = (33.0)...(43.0)
    }
    
    override init() {
        super.init()
        configure()
    }
}

extension StoreViewModel {
    private func configure() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}

extension StoreViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else { return }
        currentCoordinate = coordinate
        setStoreLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            needPermission = true
        case .authorizedAlways, .authorizedWhenInUse:
            needPermission = false
        case .restricted, .notDetermined:
            needPermission = true
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            return
        }
    }
}

extension StoreViewModel {
    func isKoreanLocation() -> Bool {
        return Location.koreaLongitude ~= currentCoordinate.longitude && Location.koreaLatitude ~= currentCoordinate.latitude
    }
    
    private func setStoreLocation() {
        Task {
            do {
                let currentAddress = try await Address.currentAddress(longitude: self.currentCoordinate.longitude, latitude: self.currentCoordinate.latitude)
                
                DispatchQueue.main.async {
                    self.areaName = currentAddress.results[0].region.area3.name
                }
                self.storeItems = try await Store.storeInformations(keyword: areaName + " \(word)").items
            } catch {
                //TODO: 에러처리
            }
        }
    }

    func urlForNaverMap(isOpenApp: Bool) -> URL? {
        return AppStore.url(isInstalled: isOpenApp, keyword: "\(areaName) \(word)")
    }
}
