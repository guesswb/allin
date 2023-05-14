//
//  ButtonView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct RecommendButtonView: View {
    @ObservedObject var viewModel: RecommendViewModel
    
    var body: some View {
        HStack {
            ForEach([1, 5, 10], id: \.self) { number in
                Button(action: {
                    viewModel.checkTime()
                    viewModel.recommendNumbers(count: number)
                }, label: {
                    Text("\(number)")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 30))
                        .background(Color(red: 0.82, green: 0.82, blue: 0.82))
                        .cornerRadius(25)
                })
            }
        }
    }
}
