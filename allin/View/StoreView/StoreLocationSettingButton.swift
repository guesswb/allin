//
//  StoreLocationSettingButton.swift
//  allin
//
//  Created by 김기훈 on 2023/03/24.
//

import SwiftUI

struct StoreLocationSettingButton: View {
    @State private var showingAlert = false
    
    private let alertSettingText = "위치 접근이 허용되어 있지 않습니다. 설정으로 이동하시겠습니까?"
    private let goToSettingText = "설정으로 이동"
    
    var body: some View {
        Button(goToSettingText) {
            showingAlert.toggle()
        }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertSettingText),
                      primaryButton: .destructive(Text("아니오"), action: {
                }),
                      secondaryButton: .default(Text("네"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
            }
    }
}

struct StoreLocationSettingButton_Previews: PreviewProvider {
    static var previews: some View {
        StoreLocationSettingButton()
    }
}
