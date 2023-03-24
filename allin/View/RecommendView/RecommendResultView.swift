//
//  ResultView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct RecommendResultView: View {
    var result: [[Int]]
    
    var body: some View {
        GeometryReader { geometry in
            if result.isEmpty {
                Text("Good Luck!")
                    .font(.system(size: 25))
                    .frame(
                        minWidth: geometry.size.width,
                        minHeight: geometry.size.height)
            }
            ScrollView(.vertical) {
                ForEach(result, id: \.self) { numbers in
                    Text("\(numbers.map{String($0)}.joined(separator: ", "))")
                        .padding()
                        .font(.system(size: 25))
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray4))
                        .clipShape(Capsule())
                }
                .padding()
                .frame(
                    minWidth: geometry.size.width,
                    minHeight: geometry.size.height)
            }
        }
        .background(Color(.systemGray))
        .cornerRadius(50)
    }
}
