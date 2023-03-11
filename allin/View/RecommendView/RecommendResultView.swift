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
        if result.isEmpty {
            Spacer()
            Text("Good Luck!")
                #if os(iOS)
                .font(.system(size: 25))
                #else
                .font(.system(size: 20))
                #endif
            Spacer()
        } else {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(result, id: \.self) { numbers in
                            Text("\(numbers.map { String($0) }.joined(separator: ", "))")
                                #if os(iOS)
                                .font(.system(size: 25))
                                #else
                                .font(.system(size: 15))
                                #endif
                                .padding()
                                .frame(maxWidth: .infinity)
                                .border(Color("systemColor"))
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
    }
}
