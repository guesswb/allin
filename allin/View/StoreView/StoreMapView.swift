//
//  StoreMapView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/26.
//

import SwiftUI
import NMapsMap

struct StoreMapView: UIViewRepresentable {
    @StateObject var viewModel: StoreViewModel = StoreViewModel()
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        view.showCompass = true
      
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let coordinate = viewModel.currentLocation
        
        let cameraUpdate = NMFCameraUpdate(
            scrollTo: NMGLatLng(
                lat: coordinate.latitude,
                lng: coordinate.longitude
            )
        )
        
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)
    }
}
