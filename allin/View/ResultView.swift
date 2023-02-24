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
            Spacer()
            Text("Good Luck!")
                .font(.system(size: fontSize))
            Spacer()
        } else {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(result, id: \.self) { numbers in
                            Text("\(numbers.map{String($0)}.joined(separator: ", "))")
                                .font(.system(size: fontSize))
                                .padding()
                                .border(Color("systemColor"))
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
    }
}
