//
//  Address.swift
//  allin
//
//  Created by 김기훈 on 2023/02/28.
//

import Foundation

struct Address: Codable {
    let status: Status
    let results: [Result]
}

struct Result: Codable {
    let name: String
    let code: Code
    let region: Region
}

struct Code: Codable {
    let id, type, mappingID: String

    enum CodingKeys: String, CodingKey {
        case id, type
        case mappingID = "mappingId"
    }
}

struct Region: Codable {
    let area0, area1, area2, area3, area4: Area
}

struct Area: Codable {
    let name: String
    let coords: Coords
}

struct Coords: Codable {
    let center: Center
}

struct Center: Codable {
    let crs: String
    let x, y: Double
}

struct Status: Codable {
    let code: Int
    let name, message: String
}
