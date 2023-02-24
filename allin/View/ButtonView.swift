//
//  ButtonView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct ButtonView: View {
    var isAvailable: Bool
    var buttonTitle: [Int]
    var createNumbers: (_ count: Int) -> Void
    var width: CGFloat
    var fontSize: CGFloat
    
    var body: some View {
        if isAvailable {
            #if os(iOS)
            HStack {
                ForEach(buttonTitle, id: \.self) { number in
                    Button("\(number)line") {
                        createNumbers(number)
                    }
                    .frame(width: width)
                    .font(.system(size: fontSize))
                    .padding()
                    .foregroundColor(Color("systemColor"))
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("systemColor"), lineWidth: 4)
                    )
                }
            }
            .padding()
            #else
            HStack {
                ForEach(buttonTitle, id: \.self) { number in
                    Button("\(number)") {
                        createNumbers(number)
                    }
                    .font(.system(size: fontSize))
                    .foregroundColor(Color("systemColor"))
                }
            }
            #endif
        } else {
            Text("토요일 20시 ~ 일요일 08시는 이용이 불가능합니다.")
        }
    }
}
