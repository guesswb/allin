//
//  ContentView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            ResultView(result: viewModel.resultArray, fontSize: 25)
            
            Spacer()
                        
            ButtonView(isAvailable: viewModel.isAvailable,
                       buttonTitle: viewModel.buttonTitle,
                       createNumbers: viewModel.createNumbers(_:),
                       width: 80,
                       fontSize: 30
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
