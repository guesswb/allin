//
//  PlistRepository.swift
//  allin
//
//  Created by 김기훈 on 2023/06/01.
//

import Foundation

final class PlistRepository {
    func data(fileName: String) throws -> Data {
        guard let bundleURL = Bundle.main.url(forResource: fileName, withExtension: "plist"),
              let data = try? Data(contentsOf: bundleURL) else {
            throw PlistError.getData
        }
        return data
    }
}
