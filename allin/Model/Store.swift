//
//  Store.swift
//  allin
//
//  Created by 김기훈 on 2023/02/28.
//

import Foundation

struct Store: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [StoreItem]
}

struct StoreItem: Codable {
    var title: String = ""
    var link: String = ""
    var category: String = ""
    var description: String = ""
    var telephone: String = ""
    var address: String = ""
    var roadAddress: String = ""
    var mapx: String = ""
    var mapy: String = ""
}
