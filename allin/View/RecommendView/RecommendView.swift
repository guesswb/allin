//
//  RecommendView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/25.
//

import SwiftUI

struct RecommendView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var viewModel: RecommendViewModel = RecommendViewModel()
    
    enum InfromationText {
        static let pleaseCheckNetwork: String = "Network를 확인해 주세요."
        static let notAvailableTime: String = "토요일 20시 ~ 일요일 08시는 이용이 불가능합니다."
    }
    
    var body: some View {
        VStack {
            if viewModel.isAvailableTime && viewModel.isAvailableNetwork {
                RecommendResultView(viewModel: viewModel)
                RecommendButtonView(viewModel: viewModel)
            } else {
                Text(viewModel.isAvailableTime ? InfromationText.notAvailableTime : InfromationText.pleaseCheckNetwork )
            }
        }
        .padding()
        .onAppear {
            viewModel.checkTime()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.checkTime()
            }
        }
    }
}

struct RecommendView_Previews : PreviewProvider {
    static var previews: some View {
        RecommendView()
    }
}
