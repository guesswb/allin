//
//  Plist.swift
//  allin
//
//  Created by 김기훈 on 2023/02/27.
//

import Foundation

struct Plist: Codable {
    //naverCloud map
    let naverAPIKeyId: String
    let naverAPIKey: String
    
    //naverDev
    let naverClientId: String
    let naverClientSecret: String
}
