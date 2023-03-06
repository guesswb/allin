//
//  StoreMoveMapButton.swift
//  allin
//
//  Created by 김기훈 on 2023/02/28.
//

import SwiftUI

struct StoreMoveMapButton: View {
    var areaName: String
    var urlForNaverMap: (_ isOpenApp: Bool) -> URL?
    
    var body: some View {
        VStack {
            Text("\(areaName) 주변 복권 판매점입니다.")
            Button("네이버 지도로 더 자세히 보기") {
                guard let nmap = URL(string: "nmap://") else { return }
                
                let isOpenApp = UIApplication.shared.canOpenURL(nmap)
                guard let url = urlForNaverMap(isOpenApp) else { return }

                UIApplication.shared.open(url)
            }
            .padding()
        }
    }
}
