//
//  WinNumber.swift
//  allin
//
//  Created by 김기훈 on 2023/05/16.
//

import Foundation

struct WinNumber: Decodable {
    var drwNo: Int = 0
    var drwtNo1: Int = 0
    var drwtNo2: Int = 0
    var drwtNo3: Int = 0
    var drwtNo4: Int = 0
    var drwtNo5: Int = 0
    var drwtNo6: Int = 0
    var bnusNo: Int = 0
    
    var winNumbers: [Int] {
        return [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6]
    }
}
