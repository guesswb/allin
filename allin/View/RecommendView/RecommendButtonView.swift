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
        HStack {
            Button(action: {
                viewModel.checkTime()
                viewModel.recommend()
            }, label: {
                Text(TextType.recommend)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 30))
                    .background(Color(red: 0.82, green: 0.82, blue: 0.82))
                    .cornerRadius(25)
            })
        }
    }
}
