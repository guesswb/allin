//
//  StoreView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/26.
//

import SwiftUI

struct StoreView: View {
    
    @StateObject var viewModel: StoreViewModel
    
    private enum InformationText {
        static let onlyKorea: String = "대한민국에서만 사용 가능합니다."
        static let failToGetStore: String = "주변 복권점을 불러오는데 실패했습니다."
        static let failToGetArea: String = "지역정보를 가져오는데 실패했습니다."
    }
    
    var body: some View {
        switch viewModel.appState {
        case .needLocationPermission:
            StoreLocationSettingButton()
        case .notKoreaLocation:
            Text(InformationText.onlyKorea)
        case .failToGetArea:
            Text(InformationText.failToGetArea)
        case .failToGetStore:
            Text(InformationText.failToGetStore)
        case .available:
            StoreMapView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
                .onReceive(viewModel.$currentCoordinate) { _ in
                    viewModel.didCoordinateChanged()
                }
        }
    }
}

struct StoreView_Previews : PreviewProvider {
    static var previews: some View {
        StoreView(viewModel: StoreViewModel(service: StoreService(storeRepository: StoreRepository(), plistRepository: PlistRepository())))
    }
}
