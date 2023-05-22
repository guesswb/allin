//
//  Lottery.swift
//  allin
//
//  Created by 김기훈 on 2023/05/16.
//

import Foundation
import CoreData
import FirebaseFirestore

struct Lottery: Decodable {
    var drwNo: Int16 = 0
    var drwtNo1: Int16 = 0
    var drwtNo2: Int16 = 0
    var drwtNo3: Int16 = 0
    var drwtNo4: Int16 = 0
    var drwtNo5: Int16 = 0
    var drwtNo6: Int16 = 0
    var bnusNo: Int16 = 0

    static let allNumbers: [Int] = [Int](1...45)

    private enum TextType {
        static let urlString: String = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo="
        
        enum Firebase {
            static let recommendNumbers: String = "RecommendNumbers"
            static let round: String = "round"
            static let numbers: String = "numbers"
        }
    }

    private enum DateType {
        static let firstRound: DateComponents = DateComponents(year: 2002, month: 11, day: 30, hour: 20)
    }
}

extension Lottery {
    func winNumbers() -> [Int] {
        return [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6].map { Int($0) }
    }
    
    static func thisWeekRound() throws -> Int {
        guard let date = Calendar.current.date(from: DateType.firstRound),
              let daysSinceFirstDay = Calendar.current.dateComponents([.day], from: date, to: Date()).day else {
            throw DateError.requestRound
        }
        return daysSinceFirstDay / 7 + 1
    }
    
    static func currentDate() -> DateComponents {
        return Calendar.current.dateComponents([.weekday, .hour], from: Date())
    }
    
    static func isAvailableTime(time: DateComponents) -> Bool {
        guard let weekday = time.weekday, let hour = time.hour else {
            return false
        }
        
        return (weekday == 7 && hour >= 20) == false && (weekday == 1 && hour <= 8) == false
    }
    
    static func request(round: Int) async throws -> Lottery {
        if let winNumber = try WinNumber.fetch(round: round) {
            let lottery = convertWinNumberToLottery(winNumber: winNumber)
            return lottery
        }
        
        guard let url = URL(string: TextType.urlString + String(round)),
              let (data, response) = try? await URLSession.shared.data(from: url),
              let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299 ~= statusCode) == true else {
            throw NetworkError.response
        }

        guard let lottery = try? JSONDecoder().decode(Lottery.self, from: data) else {
            throw JSONError.decode
        }
        
        guard let _ = try? WinNumber.save(lottery: lottery) else {
            throw CoreDataError.save
        }
        
        return lottery
    }
    
    static func convertWinNumberToLottery(winNumber: WinNumber) -> Lottery {
        return Lottery(drwNo: winNumber.drwNo,
                       drwtNo1: winNumber.drwtNo1,
                       drwtNo2: winNumber.drwtNo2,
                       drwtNo3: winNumber.drwtNo3,
                       drwtNo4: winNumber.drwtNo4,
                       drwtNo5: winNumber.drwtNo5,
                       drwtNo6: winNumber.drwtNo6,
                       bnusNo: winNumber.bnusNo)
    }
    
    static func checkCondition(randomSet: [Int], winNumbers: [Lottery]) -> [Bool] {
        let result1 = VerifyNumber.checkPairCount(randomSet)
        let result2 = VerifyNumber.checkSum(randomSet)
        let result3 = VerifyNumber.checkReappear(randomSet, winNumbers[4])
        let result4 = VerifyNumber.checkLastBonus(randomSet, Int(winNumbers[4].bnusNo))
        let result5 = VerifyNumber.checkLastWeeks(randomSet, Array(winNumbers[2...4]), 2, 5)
        let result6 = VerifyNumber.checkLastWeeks(randomSet, winNumbers, 1, 4)
        
        return [result1, result2, result3, result4, result5, result6]
    }
    
    static func storeAtFirebase(round: Int, numbers: [Int]) {
        let db = Firestore.firestore()
        db.collection(TextType.Firebase.recommendNumbers).addDocument(data: [
            TextType.Firebase.round: round,
            TextType.Firebase.numbers: numbers
        ])
    }
}
