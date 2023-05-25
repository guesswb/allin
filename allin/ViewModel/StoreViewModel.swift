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
        static let koreaLocale: String = "Ko-kr"
    }
    
    enum AppState {
        case needLocationPermission
        case notKoreaLocation
        case failToGetStore
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
        requestStoreLocation()
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
    private func isKoreaLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Bool {
        return Location.koreaLongitude ~= longitude && Location.koreaLatitude ~= latitude
    }
    
    private func area(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: Location.koreaLocale)
        
        guard let placemark = try? await geocoder.reverseGeocodeLocation(location, preferredLocale: locale).last,
              let area = placemark.thoroughfare else {
            throw GeoCodeError.reverseGeocode
        }
        return area
    }
    
    func requestStoreLocation() {
        if storeItems.isEmpty == false {
            return
        }
                
        if isKoreaLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude) == false {
            self.appState = .notKoreaLocation
            return
        }
        
        Task {
            do {
                let area = try await area(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
                let storeInformation = try await Store.storeInformations(keyword: area + " " + TextType.lottery).items
                
                DispatchQueue.main.async {
                    self.storeItems = storeInformation
                    self.appState = .available
                }
            } catch {
                DispatchQueue.main.async {
                    self.appState = .failToGetStore
                }
            }
        }
    }

    func urlForNaverMap(isInstalled: Bool) -> URL {
        return isInstalled ? URL(string: TextType.AppStore.installed)! : URL(string: TextType.AppStore.notInstalled)!
    }
}
