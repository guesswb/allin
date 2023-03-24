//
//  Lottery.swift
//  allin
//
//  Created by 김기훈 on 2023/02/28.
//

import Foundation

struct Lottery: Codable {
    var drwtNo1: Int = 0
    var drwtNo2: Int = 0
    var drwtNo3: Int = 0
    var drwtNo4: Int = 0
    var drwtNo5: Int = 0
    var drwtNo6: Int = 0
    var bnusNo: Int = 0
    
    func winNumbers() -> [Int] {
        return [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6]
    }
}
