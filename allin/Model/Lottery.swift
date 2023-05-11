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
    
    static let allNumbers: [Int] = [Int](1...45)
    static let urlString: String = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo="
    private static let firstRoundDate: DateComponents = DateComponents(year: 2002, month: 11, day: 30, hour: 20)
}

extension Lottery {
    func winNumbers() -> [Int] {
        return [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6]
    }
    
    static func thisWeekRound() -> Int {
        guard let date = Calendar.current.date(from: firstRoundDate),
              let daysSinceFirstDay = Calendar.current.dateComponents([.day], from: date, to: Date()).day else {
            return 0
        }
        return daysSinceFirstDay / 7 + 1
    }
    
    static func isAvailableTime() -> Bool {
        let today = Calendar.current.dateComponents([.weekday, .hour], from: Date())
        guard let weekday = today.weekday,
              let hour = today.hour else {
            return false
        }
        
        if (weekday == 7 && hour >= 20) || (weekday == 1 && hour <= 8) {
            return false
        }
        
        return true
    }
    
    static func request(round: Int) async throws -> Lottery {
        guard let url = URL(string: Lottery.urlString + String(round)),
              let (data, response) = try? await URLSession.shared.data(from: url),
              let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299 ~= statusCode) == true else {
            throw NetworkError.response
        }
        
        guard let lottery = try? JSONDecoder().decode(Lottery.self, from: data) else {
            throw JSONError.decode
        }

        return lottery
    }
}
