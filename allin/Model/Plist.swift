//
//  Plist.swift
//  allin
//
//  Created by 김기훈 on 2023/02/27.
//

import Foundation

struct Plist: Codable {
    //naverDeveloper
    let naverClientId: String
    let naverClientSecret: String
    
    static func data() throws -> Data {
        guard let bundleURL = Bundle.main.url(forResource: "Info", withExtension: "plist"),
              let bundleData = try? Data(contentsOf: bundleURL) else {
            throw FileError.bundle
        }
        return bundleData
    }
}
