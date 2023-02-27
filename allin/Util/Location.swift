//
//  Location.swift
//  allin
//
//  Created by 김기훈 on 2023/02/27.
//

import Foundation
import CoreLocation

#if os(iOS)
class Location: NSObject, CLLocationManagerDelegate {
    static let shared = Location()
    
    private var locationManager: CLLocationManager
    
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    private override init() {
        locationManager = CLLocationManager()
        super.init()
        configure()
    }
    
    private func configure() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        getCurrentLocation()
    }
    
    private func getCurrentLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        currentLocation = coordinate
        Task {
            await getAddress()
        }
    }
    
    private func getAddress() async {
        guard var urlComponent = URLComponents(string: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc") else { return }
        
        let coords = URLQueryItem(name: "coords", value: "\(currentLocation.longitude),\(currentLocation.latitude)")
        let orders = URLQueryItem(name: "orders", value: "legalcode")
        let output = URLQueryItem(name: "output", value: "json")
        
        urlComponent.queryItems = [coords, orders, output]
        
        var urlRequest = URLRequest(url: urlComponent.url!)
        
        guard let bundleURL = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: bundleURL)
            let result = try PropertyListDecoder().decode(Plist.self, from: data)
            
            urlRequest.addValue(result.naverAPIKeyId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
            urlRequest.addValue(result.naverAPIKey, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
            
            let (responseData, _) = try await URLSession.shared.data(for: urlRequest)
            let jsonString = String(data: responseData, encoding: .utf8)!
            print(jsonString)
        } catch {
            
        }
    }
}
#endif
