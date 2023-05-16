//
//  ContentView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct ContentView: View {
    
    private enum TabItem {
        enum Text {
            static let recommend: String = "추첨"
            static let store: String = "판매점"
        }
        
        enum Image {
            static let recommend: String = "questionmark"
            static let store: String = "map"
        }
    }
    
    var body: some View {
        TabView {
            StoreView(viewModel: StoreViewModel()).tabItem {
                Label(TabItem.Text.store, systemImage: TabItem.Image.store)
            }
            RecommendView(viewModel: RecommendViewModel()).tabItem {
                Label(TabItem.Text.recommend, systemImage: TabItem.Image.recommend)
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
