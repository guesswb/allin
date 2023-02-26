//
//  ContentView.swift
//  allinW Watch App
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: RecommendViewModel = RecommendViewModel()
    
    var body: some View {
        VStack {
            RecommendResultView(
                result: viewModel.resultArray
            )
                        
            RecommendButtonView(
                isAvailableTime: viewModel.isAvailableTime,
                isAvailableNetwork: viewModel.isAvailableNetwork,
                buttonTitle: viewModel.buttonTitle,
                createNumbers: viewModel.createNumbers(_:)
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
