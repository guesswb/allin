//
//  Lottery.swift
//  allin
//
//  Created by 김기훈 on 2023/02/28.
//

import Foundation

struct Lottery: Codable {
    let drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6, bnusNo :Int
    
#if os(watchOS)
    static func getArray(_ string: String) -> [Int] {
        var temp = string
        temp.removeFirst()
        temp.removeLast()
        
        let array = temp.components(separatedBy: ",")
        
        var result = Array(repeating: 0, count: 7)
        
        for line in array {
            let split = line.components(separatedBy: ":")
            
            switch split[0] {
            case "\"drwtNo1\"": result[0] = Int(split[1])!
            case "\"drwtNo2\"": result[1] = Int(split[1])!
            case "\"drwtNo3\"": result[2] = Int(split[1])!
            case "\"drwtNo4\"": result[3] = Int(split[1])!
            case "\"drwtNo5\"": result[4] = Int(split[1])!
            case "\"drwtNo6\"": result[5] = Int(split[1])!
            case "\"bnusNo\"": result[6] = Int(split[1])!
            default: continue
            }
        }
        
        return result
    }
#endif
}
