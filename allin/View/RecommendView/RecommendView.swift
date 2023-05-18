//
//  RecommendView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/25.
//

import SwiftUI

struct RecommendView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @StateObject private var viewModel: RecommendViewModel
    
    enum InformationText {
        static let checkNetwork: String = "Network를 확인해 주세요."
        static let unavailableTime: String = "토요일 20시 ~ 일요일 08시는 이용이 불가능합니다."
    }
    
    init(viewModel: RecommendViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometryReader in
            VStack {
                switch viewModel.appState {
                case .available:
                    RecommendShuffleView(viewModel: viewModel)
                    RecommendButtonView(viewModel: viewModel)
                case .unavailableNetwork:
                    Text(InformationText.checkNetwork)
                case .unavailableTime:
                    Text(InformationText.unavailableTime)
                }
            }
            .padding()
            .frame(width: geometryReader.size.width, height: geometryReader.size.height)
        }
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
        RecommendView(viewModel: RecommendViewModel())
    }
}
