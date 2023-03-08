//
//  Location.swift
//  allin
//
//  Created by 김기훈 on 2023/02/27.
//

import Foundation
import CoreLocation
import Combine

#if os(iOS)
final class LocationManager: NSObject {
    var locationManager: CLLocationManager
    var currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37, longitude: 126)
    
    var needPermission: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        configure()
    }
    
    private func configure() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        currentCoordinate = coordinate
    }
    
    func getCurrentAddress() async throws -> Data {
        return try await NetworkManager.getAddress(currentCoordinate.longitude, currentCoordinate.latitude)
    }
    
    func getStoreAAA(_ area: String) async throws -> Data {
        return try await NetworkManager.getStore(area)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            needPermission.send(true)
        case .authorizedAlways, .authorizedWhenInUse:
            needPermission.send(false)
        case .restricted, .notDetermined:
            needPermission.send(true)
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            return
        }
    }
}
#endif
