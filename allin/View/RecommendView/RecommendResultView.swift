//
//  ResultView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct RecommendResultView: View {
    
    @ObservedObject var viewModel: RecommendViewModel
    
    private enum TextType {
        static let goodLuck: String = "Good Luck!"
    }
    
    var body: some View {
        if viewModel.recommendNumbers.isEmpty {
            Text(TextType.goodLuck)
                .font(.title3)
                .padding()
        } else {
            HStack {
                ForEach(viewModel.recommendNumbers, id: \.self) { number in
                    Text("\(number)")
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .font(.title3)
                        .background(.yellow)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
