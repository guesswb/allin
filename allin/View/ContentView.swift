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
                    Label("추첨", systemImage: "questionmark")
                }
            StoreView()
                .tabItem {
                    VStack {
                        Image(systemName: "map")
                        Text("판매점")
                    }
                }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .systemGray6
        }
        .tint(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
