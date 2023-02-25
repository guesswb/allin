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
            RecommendResultView(result: viewModel.resultArray, fontSize: 25)
                        
            RecommendButtonView(isAvailable: viewModel.isAvailable,
                       buttonTitle: viewModel.buttonTitle,
                       createNumbers: viewModel.createNumbers(_:),
                       width: 80,
                       fontSize: 30
            )
        }
    }
}

struct RecommendView_Previews : PreviewProvider {
    static var previews: some View {
        RecommendView()
    }
}
