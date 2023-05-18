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
    @Published var appState: AppState = .needLocationPermission
    @Published var areaName: String = ""
    @Published var storeItems: [StoreItem] = []
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    private enum TextType {
        static let lottery: String = "복권"
        
        enum AppStore {
            static let installed: String = "nmap://search?query=\( TextType.lottery)&appname=com.kim.allin".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            static let notInstalled: String = "http://itunes.apple.com/app/id311867728?mt=8"
        }
    }
    
    enum Location {
        static let koreaLongitude: ClosedRange = (124.0)...(132.0)
        static let koreaLatitude: ClosedRange = (33.0)...(43.0)
    }
    
    enum AppState {
        case needLocationPermission
        case notKoreaLocation
        case failLoadNaverMap
        case available
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
            appState = .needLocationPermission
        case .authorizedAlways, .authorizedWhenInUse:
            appState = .available
        case .restricted, .notDetermined:
            appState = .needLocationPermission
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            return
        }
    }
}

extension StoreViewModel {
    private func isKoreanLocation() -> Bool {
        return Location.koreaLongitude ~= currentCoordinate.longitude && Location.koreaLatitude ~= currentCoordinate.latitude
    }
    
    private func setStoreLocation() {
        if storeItems.isEmpty == false {
            return
        }
        
        Task {
            do {
                if isKoreanLocation() == false {
                    DispatchQueue.main.async {
                        self.appState = .notKoreaLocation
                    }
                    return
                }
                
                let currentAddress = try await Address.currentAddress(longitude: self.currentCoordinate.longitude, latitude: self.currentCoordinate.latitude)
                
                DispatchQueue.main.async {
                    self.areaName = currentAddress.results[0].region.area3.name
                }
                
                let storeInformation = try await Store.storeInformations(keyword: currentAddress.results[0].region.area3.name + " \(TextType.lottery)").items
                
                DispatchQueue.main.async {
                    self.storeItems = storeInformation
                    self.appState = .available
                }
            } catch {
                DispatchQueue.main.async {
                    self.appState = .failLoadNaverMap
                }
            }
        }
    }

    func urlForNaverMap(isInstalled: Bool) -> URL {
        return isInstalled ? URL(string: TextType.AppStore.installed)! : URL(string: TextType.AppStore.notInstalled)!
    }
}
