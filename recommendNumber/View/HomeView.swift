//
//  ContentView.swift
//  recommendNumber
//
//  Created by 김기훈 on 2023/01/19.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.resultArray, id: \.self) { result in
                Text("\(result.map{String($0)}.joined(separator: " "))")
                    .frame(alignment: .center)
            }
            
            HStack {
                Button("1") {
                    viewModel.createNumbers(1)
                }
                Button("5") {
                    viewModel.createNumbers(5)
                }
                Button("10") {
                    viewModel.createNumbers(10)
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
