//
//  StoreMoveMapButton.swift
//  allin
//
//  Created by 김기훈 on 2023/02/28.
//

import SwiftUI

struct StoreMoveMapButton: View {
    @ObservedObject var viewModel: StoreViewModel
    
    private let aroundStoreText: String = "주변 복권 판매점입니다."
    private let goToNaverMapText: String = "네이버 지도로\n더 자세히 보기"
    
    var body: some View {
        VStack {
            Text("\(viewModel.areaName) " + aroundStoreText)
            Button(goToNaverMapText) {
                guard let nmap = URL(string: "nmap://") else { return }
                
                let isOpenApp = UIApplication.shared.canOpenURL(nmap)
                guard let url = viewModel.urlForNaverMap(isOpenApp: isOpenApp) else { return }
                
                UIApplication.shared.open(url)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .font(.system(size: 30))
            .background(Color(red: 0.82, green: 0.82, blue: 0.82))
            .cornerRadius(25)
        }
        .padding()
    }
}
