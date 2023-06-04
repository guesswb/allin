//
//  StoreViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/27.
//

import Foundation
import CoreLocation
import NMapsMap

final class StoreViewModel: NSObject, ObservableObject {
    
    @Published var currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.554763, longitude: 126.97092)
    @Published var appState: AppState = .needLocationPermission
    @Published var storeItems: [StoreItem] = []
    
    private let service: StoreService
    private let locationManager: CLLocationManager = CLLocationManager()
    
    enum Location {
        static let koreaLongitude: ClosedRange = (124.0)...(132.0)
        static let koreaLatitude: ClosedRange = (33.0)...(43.0)
        static let koreaLocale: String = "Ko-kr"
    }
    
    enum AppState {
        case needLocationPermission
        case notKoreaLocation
        case failToGetArea
        case failToGetStore
        case available
    }
    
    init(service: StoreService) {
        self.service = service
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
    
    func didCoordinateChanged() {
        if isKoreaLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude) == false {
            self.appState = .notKoreaLocation
            return
        }
        
        Task { [weak self] in
            guard let self = self else { return }
            
            guard let area = try? await area(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude) else {
                self.appState = .failToGetArea
                return
            }
            
            if self.storeItems.isEmpty == false {
                return
            }
            
            guard var store = try? await service.requestStore(area: area) else {
                self.appState = .failToGetStore
                return
            }
            
            store.items = store.items.map { [weak self] item in
                guard let self = self,
                      let x = Double(item.mapx), let y = Double(item.mapy) else {
                    return StoreItem()
                }
                let latlon = NMGTm128(x: x, y: y).toLatLng()
                var newItem = item
                
                newItem.latitude = latlon.lat
                newItem.longitude = latlon.lng
                
                newItem.distance = self.calculateDistance(
                    latitude1: self.currentCoordinate.latitude,
                    longitude1: self.currentCoordinate.longitude,
                    latitude2: latlon.lat,
                    longitude2: latlon.lng)
                return newItem
            }
            let newStore = store
            
            await MainActor.run {
                self.storeItems = newStore.items
            }
        }
    }

    private func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    private func calculateDistance(latitude1: Double, longitude1: Double, latitude2: Double, longitude2: Double) -> Double {
        let dLat = degreesToRadians(latitude2 - latitude1)
        let dLon = degreesToRadians(longitude2 - longitude1)
        
        let a = sin(dLat/2) * sin(dLat/2) +
                cos(degreesToRadians(latitude1)) * cos(degreesToRadians(latitude2)) *
                sin(dLon/2) * sin(dLon/2)
        
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        let distance = 6371 * c
        
        return distance
    }
}
