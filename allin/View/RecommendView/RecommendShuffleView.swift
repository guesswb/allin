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
        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 60)), count: 6)) {
            ForEach(viewModel.numbers, id: \.self) { number in
                Text("\(number)")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .tint(.black)
                    .background(viewModel.recommendNumbers.contains(number) ? .yellow : .gray)
                    .cornerRadius(10)
                    .minimumScaleFactor(0.1)
            }
        }
        .padding()
    }
}
