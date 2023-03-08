//
//  StoreView.swift
//  allin
//
//  Created by 김기훈 on 2023/02/26.
//

import SwiftUI

struct StoreView: View {
    @StateObject var viewModel: StoreViewModel = StoreViewModel()
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            if viewModel.needPermission {
                Button("설정으로 이동") {
                    showingAlert.toggle()
                }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("위치 접근이 허용되어 있지 않습니다. 설정으로 이동하시겠습니까?"),
                              primaryButton: .destructive(Text("아니오"), action: {
                        }),
                              secondaryButton: .default(Text("네"), action: {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }))
                    }
            } else {
                if viewModel.storeLocation == nil {
                    Text("대한민국에서만 사용 가능합니다.")
                } else {
                    StoreMapView(
                        currentCoordinate: viewModel.currentCoordinate,
                        storeLocation: viewModel.storeLocation
                    ).padding()
                    StoreMoveMapButton(
                        areaName: viewModel.areaName,
                        urlForNaverMap: viewModel.urlForNaverMap
                    ).padding()
                }
                
            }
        }
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
