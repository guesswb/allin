//
//  StoreView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/26.
//

import SwiftUI

struct StoreView: View {
    @StateObject var viewModel: StoreViewModel = StoreViewModel()
    
    private let onlyKoreaText = "대한민국에서만 사용 가능합니다."
    
    var body: some View {
        VStack {
            if viewModel.needPermission {
                StoreLocationSettingButton()
            } else {
                if viewModel.isKoreanLocation() {
                    StoreMapView(
                        currentCoordinate: viewModel.currentCoordinate,
                        stores: viewModel.storeItems
                    ).padding()
                    StoreMoveMapButton(
                        areaName: viewModel.areaName,
                        urlForNaverMap: viewModel.urlForNaverMap
                    )
                } else {
                    Text(onlyKoreaText)
                }
            }
        }
    }
}
