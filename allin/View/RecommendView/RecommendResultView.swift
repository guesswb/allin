//
//  ResultView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct RecommendResultView: View {
    var result: [[Int]]
    
    private let goodLuckText: String = "Good Luck!"
    
    var body: some View {
        GeometryReader { geometry in
            if result.isEmpty {
                Text(goodLuckText)
                    .font(.system(size: 25))
                    .frame(
                        minWidth: geometry.size.width,
                        minHeight: geometry.size.height)
            }
            ScrollView(.vertical) {
                ForEach(result, id: \.self) { numbers in
                    Text("\(numbers.map{String($0)}.joined(separator: " "))")
                        .padding()
                    #if os(iOS)
                        .font(.system(size:30))
                    #else
                        .font(.system(size: 16))
                    #endif
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
