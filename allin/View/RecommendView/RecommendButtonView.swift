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
                Button(action: {
                    createNumbers(number)
                }, label: {
                    Text("\(number)")
                        .padding()
                        .frame(maxWidth: .infinity)
                    #if os(iOS)
                        .font(.system(size: 30))
                        .background(Color(red: 0.82, green: 0.82, blue: 0.82))
                        .cornerRadius(25)
                    #else
                        .font(.system(size: 16))
                    #endif
                })
            }
        }
    }
}
