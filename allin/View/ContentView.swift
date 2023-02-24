//
//  ContentView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    let buttonTitle: [Int] = [1, 5, 10]
    
    var body: some View {
        VStack {
            Spacer()
            
            if viewModel.resultArray.isEmpty {
                Text("Good Luck!")
                    .font(.system(size: 25))
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.resultArray, id: \.self) { result in
                            Text("\(result.map{String($0)}.joined(separator: ", "))")
                                .font(.system(size: 25))
                                .padding()
                                .border(.black)
                        }
                    }
                }
            }
            
            Spacer()
                        
            HStack {
                if viewModel.isAvailable {
                    ForEach(buttonTitle, id: \.self) { number in
                        Button("\(number)line") {
                            viewModel.createNumbers(number)
                        }
                        .frame(width: 80)
                        .font(.system(size: 30))
                        .foregroundColor(Color("systemColor"))
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("systemColor"), lineWidth: 4)
                        )
                    }
                } else {
                    Text("토요일 20시 ~ 일요일 08시는 이용이 불가능합니다.")
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
