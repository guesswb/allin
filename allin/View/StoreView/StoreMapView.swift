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
    var stores: [StoreItem]
    
    private let categoryText = "생활,편의>복권,로또"
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.showCompass = true
      
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let cameraUpdate = NMFCameraUpdate(
            scrollTo: NMGLatLng(
                lat: currentCoordinate.latitude,
                lng: currentCoordinate.longitude
            )
        )
        
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.zoomLevel = 14
        uiView.mapView.moveCamera(cameraUpdate)
        
        if stores.isEmpty { return }
        
        stores.forEach { storeItem in
            if storeItem.category == categoryText {
                guard let x = Double(storeItem.mapx), let y = Double(storeItem.mapy) else { return }
                let marker = NMFMarker()
                let latlon = NMGTm128(x: x, y: y).toLatLng()
                
                marker.position = NMGLatLng(lat: latlon.lat, lng: latlon.lng)
                marker.mapView = uiView.mapView
            }
        }
    }
}
