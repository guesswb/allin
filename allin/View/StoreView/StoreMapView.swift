//
//  StoreMapView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/26.
//

import SwiftUI
import NMapsMap

struct StoreMapView: UIViewRepresentable {
    
    @ObservedObject var viewModel: StoreViewModel
    
    private enum TextType {
        static let category: String = "생활,편의>복권,로또"
    }
    
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
                lat: viewModel.currentCoordinate.latitude,
                lng: viewModel.currentCoordinate.longitude
            )
        )
        
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.zoomLevel = 14
        uiView.mapView.moveCamera(cameraUpdate)
        
        if viewModel.storeItems.isEmpty { return }
        
        let storeItems = viewModel.storeItems.filter { $0.category == TextType.category }
        
        storeItems.forEach { storeItem in
            guard let x = Double(storeItem.mapx), let y = Double(storeItem.mapy) else { return }
            let marker = NMFMarker()
            let latlon = NMGTm128(x: x, y: y).toLatLng()
            
            marker.position = NMGLatLng(lat: latlon.lat, lng: latlon.lng)
            marker.mapView = uiView.mapView
        }
    }
}
