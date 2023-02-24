//
//  ContentView.swift
//  allinW Watch App
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            ResultView(result: viewModel.resultArray, fontSize: 20)
                        
            ButtonView(isAvailable: viewModel.isAvailable,
                       buttonTitle: viewModel.buttonTitle,
                       createNumbers: viewModel.createNumbers(_:),
                       width: 15,
                       fontSize: 15
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
