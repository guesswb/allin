//
//  RecommendView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/25.
//

import SwiftUI

struct RecommendView: View {
    @StateObject var viewModel: RecommendViewModel = RecommendViewModel()
    
    var body: some View {
        VStack {
            RecommendResultView(
                result: viewModel.resultArray
            )
            
            RecommendButtonView(
                isAvailableTime: viewModel.isAvailableTime,
                isAvailableNetwork: viewModel.isAvailableNetwork,
                buttonTitle: viewModel.buttonTitle,
                createNumbers: viewModel.createNumbers(_:)
            )
        }
        .padding()
    }
}

struct RecommendView_Previews : PreviewProvider {
    static var previews: some View {
        RecommendView()
    }
}
