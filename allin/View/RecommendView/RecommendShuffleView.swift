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
        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50)), count: 6)) {
            ForEach(viewModel.numbers, id: \.self) { number in
                Text("\(number)")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.recommendNumbers.contains(number) ? .yellow : .gray)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
