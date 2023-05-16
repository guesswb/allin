//
//  ButtonView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct RecommendButtonView: View {
    
    @ObservedObject var viewModel: RecommendViewModel
    
    private enum TextType {
        static let recommend: String = "추천"
    }
    
    var body: some View {
        Button(action: {
            viewModel.checkTime()
            viewModel.recommend()
        }, label: {
            Text(TextType.recommend)
                .frame(maxWidth: .infinity)
                .padding()
                .font(.system(size: 30))
                .background(.green)
                .cornerRadius(25)
                .tint(.black)
        })
        .padding(.horizontal)
    }
}
