//
//  StoreViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/27.
//

import Foundation
import CoreLocation
import Alamofire

final class StoreViewModel: NSObject, ObservableObject {
    
    @Published var currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.554763, longitude: 126.97092)
    @Published var needPermission: Bool = true
    @Published var storeItems: [StoreItem] = []
    @Published var areaName: String = ""
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
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
        return 124...132 ~= currentCoordinate.longitude && 33...43 ~= currentCoordinate.latitude
    }
    
    private func getCurrentAddress() throws -> DataRequest {
        guard var urlComponent = URLComponents(string: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc") else { throw NetworkError.urlError }
        
        let coords = URLQueryItem(name: "coords", value: "\(currentCoordinate.longitude),\(currentCoordinate.latitude)")
        let targetcrs = URLQueryItem(name: "targetcrs", value: "nhn:128")
        let orders = URLQueryItem(name: "orders", value: "legalcode")
        let output = URLQueryItem(name: "output", value: "json")
        
        urlComponent.queryItems = [coords, targetcrs, orders, output]
        
        guard let url = urlComponent.url,
            let bundleURL = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            throw FileError.bundleError
        }
        
        let data = try Data(contentsOf: bundleURL)
        let result = try PropertyListDecoder().decode(Plist.self, from: data)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(result.NMFClientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        urlRequest.addValue(result.NMFClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        return AF.request(urlRequest)
    }
    
    private func getStore(_ area: String) throws -> DataRequest {
        guard var urlComponent = URLComponents(string: "https://openapi.naver.com/v1/search/local.json") else { throw NetworkError.urlError }

        let query = URLQueryItem(name: "query", value: "\(area) 복권")
        let display = URLQueryItem(name: "display", value: "5")
        let start = URLQueryItem(name: "start", value: "1")
        let sort = URLQueryItem(name: "sort", value: "random")
        
        urlComponent.queryItems = [query, display, start, sort]
        
        guard let url = urlComponent.url,
            let bundleURL = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            throw FileError.bundleError
        }
        
        let data = try Data(contentsOf: bundleURL)
        let result = try PropertyListDecoder().decode(Plist.self, from: data)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(result.naverClientId, forHTTPHeaderField: "X-Naver-Client-Id")
        urlRequest.addValue(result.naverClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        return AF.request(urlRequest)
    }
    
    private func setStoreLocation() {
        if !storeItems.isEmpty || !isKoreanLocation() { return }
        
        Task {
            do {
                let currentAddress = try await getCurrentAddress().serializingDecodable(Address.self).value
                
                if currentAddress.results.isEmpty { return }
                let currentArea = currentAddress.results[0].region.area3.name
                
                DispatchQueue.main.async {
                    self.areaName = currentArea
                }
                
                let store = try await getStore(currentArea).serializingDecodable(Store.self).value
                
                DispatchQueue.main.async {
                    self.storeItems = store.items
                }
            } catch (let error) {
                if error.localizedDescription == "" {
                    
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
