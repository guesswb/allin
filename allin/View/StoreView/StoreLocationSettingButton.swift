//
//  StoreLocationSettingButton.swift
//  allin
//
//  Created by 김기훈 on 2023/03/24.
//

import SwiftUI

struct StoreLocationSettingButton: View {
    @State private var isShowingAlert = false
    
    private enum TextType {
        static let needLocationTitle: String = "위치 권한 필요"
        static let alertMoveToSetting: String = "위치 접근이 허용되어 있지 않습니다. 설정으로 이동하시겠습니까?"
        static let moveToSetting: String = "설정으로 이동"
        static let confirm: String = "네"
        static let refuse: String = "아니오"
    }
    
    var body: some View {
        Button(TextType.moveToSetting) {
            isShowingAlert.toggle()
        }
        .alert(
            TextType.needLocationTitle,
            isPresented: $isShowingAlert,
            actions: {
                Button(TextType.confirm, role: .cancel, action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                Button(TextType.refuse, role: .destructive, action: {})
            },
            message: { Text(TextType.alertMoveToSetting) }
        )
    }
}

struct StoreLocationSettingButton_Previews: PreviewProvider {
    static var previews: some View {
        StoreLocationSettingButton()
    }
}
