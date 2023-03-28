//
//  RecommendView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/25.
//

import SwiftUI

struct RecommendView: View {
    @StateObject private var viewModel: RecommendViewModel = RecommendViewModel()
    
    private let checkNetworkText = "Network를 확인해 주세요."
    private let notAvailableTimeText = "토요일 20시 ~ 일요일 08시는 이용이 불가능합니다."
    
    var body: some View {
        VStack {
            if viewModel.isAvailableTime {
                if viewModel.isAvailableNetwork {
                    RecommendResultView(
                        result: viewModel.recommendNumberSet
                    )
                } else {
                    Text(checkNetworkText)
                }
                RecommendButtonView(
                    createNumbers: viewModel.createNumbers,
                    checkTime: viewModel.checkTime
                )
            } else {
                Text(notAvailableTimeText)
            }
        }
        .padding()
        .onAppear {
            viewModel.checkTime()
        }
    }
}

struct RecommendView_Previews : PreviewProvider {
    static var previews: some View {
        RecommendView()
    }
}
