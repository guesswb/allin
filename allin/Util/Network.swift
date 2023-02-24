//
//  Network.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import Foundation

func requestNumberSet(_ numbers: [Int], _ drawDate: Int) async throws -> [[Int]] {
    var numberSet: [[Int]] = Array(repeating: [Int](), count: 5)
    
    for number in numbers {
        guard let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)") else { return [[Int]]() }

        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonString = String(data: data, encoding: .utf8)!
        
        let array = getArray(jsonString)

        numberSet[number-drawDate+5] = array
    }
    
    return numberSet
}


func getArray(_ string: String) -> [Int] {
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
