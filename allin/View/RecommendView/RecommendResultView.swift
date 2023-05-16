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
                .font(.system(size: 25))
        } else {
            Text("\(viewModel.recommendNumbers.map{String($0)}.joined(separator: " "))")
                .padding()
                .font(.system(size:30))
                .frame(maxWidth: .infinity)
                .cornerRadius(25)
        }
    }
}
