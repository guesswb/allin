//
//  StoreMoveMapButton.swift
//  allin
//
//  Created by 김기훈 on 2023/02/28.
//

import SwiftUI

struct StoreMoveMapButton: View {
    
    @ObservedObject var viewModel: StoreViewModel
    
    private enum TextType {
        static let moveToNaverMap: String = "네이버 지도로 이동"
    }
    
    var body: some View {
        VStack {
            Button(TextType.moveToNaverMap) {
                guard let naverMapURL = URL(string: "nmap://") else { return }
                
                let url = UIApplication.shared.canOpenURL(naverMapURL) ?
                viewModel.urlForNaverMap(isInstalled: true) :
                viewModel.urlForNaverMap(isInstalled: false)
                UIApplication.shared.open(url)
            }
            .frame(maxWidth: .infinity)
            .font(.system(size: 30))
            .background(Color(red: 0.82, green: 0.82, blue: 0.82))
            .cornerRadius(25)
            .tint(.black)
        }
        .padding()
    }
}
