//
//  ButtonView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct RecommendButtonView: View {
    var isAvailableTime: Bool
    var isAvailableNetwork: Bool
    var buttonTitle: [Int]
    var createNumbers: (_ count: Int) -> Void
    
    var body: some View {
        if isAvailableTime {
            if isAvailableNetwork {
                HStack {
                    ForEach(buttonTitle, id: \.self) { number in
                        #if os(iOS)
                        Button("\(number)line") {
                            createNumbers(number)
                        }
                        .frame(width: 80)
                        .font(.system(size: 30))
                        .padding()
                        .foregroundColor(Color("systemColor"))
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("systemColor"), lineWidth: 4)
                        )
                        #else
                        Button("\(number)") {
                            createNumbers(number)
                        }
                        .font(.system(size: 15))
                        .foregroundColor(Color("systemColor"))
                        #endif
                    }
                }
                .padding()
            } else {
                Spacer()
                Text("Network를 확인해 주세요.")
                Spacer()
            }
        } else {
            Spacer()
            Text("토요일 20시 ~ 일요일 08시는 이용이 불가능합니다.")
            Spacer()
        }
    }
}
