//
//  RecommendShuffleView.swift
//  allin
//
//  Created by 김기훈 on 2023/05/14.
//

import SwiftUI

struct RecommendShuffleView: View {
    
    @ObservedObject var viewModel: RecommendViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(viewModel.numbers, id: \.self) { number in
                if viewModel.recommendNumbers.contains(number) {
                    Text("\(number)")
                        .foregroundColor(.green)
                } else {
                    Text("\(number)")
                }
            }
        }
    }
}
