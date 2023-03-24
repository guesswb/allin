//
//  ContentView.swift
//  allinW Watch App
//
//  Created by 김기훈 on 2023/02/24.
//

import SwiftUI

struct WatchContentView: View {
    var body: some View {
        RecommendView()
            .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct WatchContentView_Previews: PreviewProvider {
    static var previews: some View {
        WatchContentView()
    }
}
