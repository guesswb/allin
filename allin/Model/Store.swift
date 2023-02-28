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
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let link: String
    let category, description, telephone, address, roadAddress: String
    let mapx, mapy: String
}
