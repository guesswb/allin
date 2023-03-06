//
//  StoreMapView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/26.
//

import SwiftUI
import NMapsMap

struct StoreMapView: UIViewRepresentable {
    var currentCoordinate: CLLocationCoordinate2D
    var storeLocation: Store?
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.showCompass = true
      
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let coordinate = currentCoordinate
        
        let cameraUpdate = NMFCameraUpdate(
            scrollTo: NMGLatLng(
                lat: coordinate.latitude,
                lng: coordinate.longitude
            )
        )
        
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.zoomLevel = 14
        uiView.mapView.moveCamera(cameraUpdate)
        
        guard let stores = storeLocation else { return }
        
        for index in 0..<stores.items.count  {
            let store = stores.items[index]
            
            if store.category == "생활,편의>복권,로또" {
                guard let x = Double(store.mapx), let y = Double(store.mapy) else { continue }
                let marker = NMFMarker()
                let latlon = NMGTm128(x: x, y: y).toLatLng()
                
                marker.position = NMGLatLng(lat: latlon.lat, lng: latlon.lng)
                marker.mapView = uiView.mapView
            }
        }
    }
}
