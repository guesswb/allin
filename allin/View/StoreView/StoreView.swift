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
    }
    
    init(viewModel: StoreViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            switch viewModel.appState {
            case .available:
                StoreMapView(viewModel: viewModel)
                StoreMoveMapButton(viewModel: viewModel)
            case .notKoreaLocation:
                Text(InformationText.onlyKorea)
            case .needLocationPermission:
                StoreLocationSettingButton()
            }
        }
    }
}

struct StoreView_Previews : PreviewProvider {
    static var previews: some View {
        StoreView(viewModel: StoreViewModel())
    }
}
