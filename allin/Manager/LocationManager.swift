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
    var locationManager: CLLocationManager = CLLocationManager()
    
    var currentCoordinate: CurrentValueSubject<CLLocationCoordinate2D, Never> = CurrentValueSubject<CLLocationCoordinate2D, Never>(CLLocationCoordinate2D(latitude: 37.0, longitude: 126.0))
    var needPermission: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
    
    override init() {
        super.init()
        configure()
    }
    
    private func configure() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func getCurrentAddress() async throws -> Data {
        return try await NetworkManager.getAddress(currentCoordinate.value.longitude, currentCoordinate.value.latitude)
    }
    
    func getStoreAAA(_ area: String) async throws -> Data {
        return try await NetworkManager.getStore(area)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else { return }
        currentCoordinate.send(coordinate)
    }
    
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
