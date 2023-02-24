//
//  ResultView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct ResultView: View {
    var result: [[Int]]
    var fontSize: CGFloat
    
    var body: some View {
        if result.isEmpty {
            Text("Good Luck!")
                .font(.system(size: fontSize))
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(result, id: \.self) { numbers in
                        Text("\(numbers.map{String($0)}.joined(separator: ", "))")
                            .font(.system(size: fontSize))
                            .padding()
                            .border(.black)
                    }
                }
            }
        }
    }
}
