//
//  StoreView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/26.
//

import SwiftUI

struct StoreView: View {
    @StateObject var viewModel: StoreViewModel = StoreViewModel()
    
    var body: some View {
        VStack {
            StoreMapView(
                currentCoordinate: viewModel.currentCoordinate,
                storeLocation: viewModel.storeLocation
            ).padding()
            StoreMoveMapButton(
                areaName: viewModel.areaName,
                urlForNaverMap: viewModel.urlForNaverMap
            ).padding()
        }
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
