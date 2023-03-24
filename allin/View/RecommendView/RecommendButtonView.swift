//
//  ButtonView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct RecommendButtonView: View {
    var createNumbers: (_ count: Int) -> Void
    
    var body: some View {
        HStack {
            ForEach([1, 5, 10], id: \.self) { number in
                Button("\(number) line") { createNumbers(number) }
            }
            .padding()
            .font(.system(size: 30))
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray4))
            .clipShape(Capsule())
        }
        .padding()
        .tint(Color(red: 0.53, green: 0.35, blue: 0.18))
    }
}
