//
//  ContentView.swift
//  allinW Watch App
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
                                .font(.system(size: 20))
                                .padding()
                                .border(Color("systemColor"))
                        }
                    }
                }
            }
            
            Spacer()
                        
            HStack {
                if viewModel.isAvailable {
                    ForEach(buttonTitle, id: \.self) { number in
                        Button("\(number)") {
                            viewModel.createNumbers(number)
                        }
                        .font(.system(size: 15))
                        .foregroundColor(Color("systemColor"))
                    }
                } else {
                    Text("토요일 20시 ~ 일요일 08시는 이용이 불가능합니다.")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
