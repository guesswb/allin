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
                .tabItem { Text("추첨") }
            Text("sceond")
                .tabItem { Text("판매점") }
            Text("third")
                .tabItem { Text("위시리스트") }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
