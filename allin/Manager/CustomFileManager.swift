//
//  File.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import Foundation

final class CustomFileManager {
    static let shared = CustomFileManager()
    
    static let fileManager = FileManager.default
    
    static var filePath: URL {
        get {
            let documentPath: URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return documentPath.appendingPathComponent("numbers.txt")
        }
    }
    
    private init() {}
    
    static func storeFile(_ numberSet: [[Int]], _ drawDate: Int) {
        do {
            var result = ""
            
            for index in 0..<5 {
                result += "\(drawDate - (5-index)) " + numberSet[index].map{ String($0) }.joined(separator: " ") + "\n"
            }

            try result.write(to: CustomFileManager.filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("store fail")
        }
    }

    static func getNumberSetFromFile(_ drawDate: Int) -> [[Int]]? {
        if !fileManager.fileExists(atPath: filePath.absoluteString) {
            do {
                let text: String = try String(contentsOf: CustomFileManager.filePath, encoding: .utf8)
                let numberSet = text.split(separator: "\n")
                
                var result: [[Int]] = Array(repeating: [Int](), count: 5)
                
                for index in 0..<5 {
                    let numbers = numberSet[index].components(separatedBy: " ").map { Int($0) }.compactMap { $0 }
                    
                    if numbers[0] >= drawDate-5 {
                        result[4-index] = [numbers[1], numbers[2], numbers[3], numbers[4], numbers[5], numbers[6], numbers[7]]
                    } else {
                        return nil
                    }
                }
                return Array(result.reversed())
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
