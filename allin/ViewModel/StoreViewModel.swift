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
    
    init() {
        currentCoordinate = locationManager.currentCoordinate
        Task {
            do {
                let addressData = try await locationManager.getCurrentAddress()
                let address = try JSONDecoder().decode(Address.self, from: addressData)
                let area = address.results[0].region.area3.name
                
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
