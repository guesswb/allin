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
            static let result: String = "결과"
            static let recommend: String = "추첨"
            static let store: String = "판매점"
            static let replay: String = "다시보기"
        }
        
        enum Image {
            static let result: String = "chart.pie"
            static let recommend: String = "questionmark"
            static let store: String = "map"
            static let replay: String = "play.rectangle"
        }
    }
    
    var body: some View {
        TabView {
            ChartView(viewModel: ChartViewModel(
                service: ChartService(
                    recommendedResultRepository: RecommendedResultRepository())
                )
            )
            .tabItem {
                Label(TabItem.Text.result, systemImage: TabItem.Image.result)
            }
            RecommendView(viewModel: RecommendViewModel(
                service: RecommendService(
                    winNumberRepository: WinNumberEntityRepository(),
                    recommendNumberRepository: RecommendNumberRepository())
                )
            )
            .tabItem {
                Label(TabItem.Text.recommend, systemImage: TabItem.Image.recommend)
            }
            StoreView(viewModel: StoreViewModel(
                service: StoreService(
                    storeRepository: StoreRepository(),
                    plistRepository: PlistRepository())
                )
            )
            .tabItem {
                Label(TabItem.Text.store, systemImage: TabItem.Image.store)
            }
            
            ReplayView(viewModel: ReplayViewModel(
                replayService: ReplayService(
                    replayDataRepository: ReplayDataRepository())
                )
            )
            .tabItem {
                    Label(TabItem.Text.replay, systemImage: TabItem.Image.replay)
            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .systemGray6
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
