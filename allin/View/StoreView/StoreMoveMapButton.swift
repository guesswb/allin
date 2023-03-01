//
//  StoreMoveMapButton.swift
//  allin
//
//  Created by 김기훈 on 2023/02/28.
//

import SwiftUI

struct StoreMoveMapButton: View {
    var areaName: String
    
    init(areaName: String) {
        self.areaName = areaName
    }
    
    var body: some View {
        VStack {
            Text("\(areaName) 주변 복권 판매점입니다.")
            Button("네이버 지도로 더 자세히 보기") {
                let nmap = URL(string: "nmap://")!
                let urlString = "nmap://search?query=\(areaName)복권&appname=com.kim.allin"
                let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
                
                if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let url = URL(string: encoded) {
                    
                    if UIApplication.shared.canOpenURL(nmap) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.open(appStoreURL)
                    }
                }
            }
            .padding()
        }
    }
}
