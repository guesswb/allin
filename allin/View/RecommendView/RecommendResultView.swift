//
//  ResultView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct RecommendResultView: View {
    @ObservedObject var viewModel: RecommendViewModel
    
    private let goodLuckText: String = "Good Luck!"
    
    var body: some View {
        GeometryReader { geometry in
            if viewModel.recommendNumbers.isEmpty {
                Text(goodLuckText)
                    .font(.system(size: 25))
                    .frame(
                        minWidth: geometry.size.width,
                        minHeight: geometry.size.height)
            }
            
            ScrollView(.vertical) {
                ForEach(viewModel.recommendNumbers, id: \.self) { numbers in
                    Text("\(numbers.map{String($0)}.joined(separator: " "))")
                        .padding()
                        .font(.system(size:30))
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.76, green: 0.76, blue: 0.76))
                        .cornerRadius(25)
                }
                .padding()
                .frame(
                    minWidth: geometry.size.width,
                    minHeight: geometry.size.height)
            }
        }
        .background(Color(.gray))
        .cornerRadius(25)
    }
}
