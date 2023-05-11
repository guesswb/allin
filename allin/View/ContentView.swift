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
                    Label("판매점", systemImage: "map")
                }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .systemGray6
        }
        .tint(Color(red: 0.38, green: 0.2, blue: 0.1))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
