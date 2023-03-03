//
//  ContentView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RecommendView()
                .tabItem {
                    VStack {
                        Image(systemName: "questionmark")
                        Text("추첨")
                    }
                }
            StoreView()
                .tabItem {
                    VStack {
                        Image(systemName: "map")
                        Text("판매점")
                    }
                }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
