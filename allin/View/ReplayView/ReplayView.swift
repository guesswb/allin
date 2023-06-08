//
//  ReplayView.swift
//  allin
//
//  Created by 김기훈 on 2023/06/08.
//

import SwiftUI
import AVFoundation

struct ReplayView: View {
    
    @StateObject var viewModel: ReplayViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.replayData) { data in
                NavigationLink("\(data.round)") {
                    WebView(urlToLoad: "\(data.urlString)")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .navigationTitle("회차")
            }
        }
    }
}

struct ReplayView_Previews: PreviewProvider {
    static var previews: some View {
        ReplayView(viewModel: ReplayViewModel(replayService: ReplayService(replayDataRepository: ReplayDataRepository())))
    }
}
