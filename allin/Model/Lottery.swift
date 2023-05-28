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
            static let recommendNumber: String = "RecommendNumber"
            static let round: String = "round"
            static let numbers: String = "numbers"
            static let winResult: String = "WinResult"
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
            throw DateError.fetchDate
        }
        return daysSinceFirstDay / 7 + 1
    }
    
    static func fetchInitialLottery(round: Int) async throws -> [Lottery] {
        let winNumbers: [WinNumber] = try WinNumber.fetch(round: round)
            .filter { $0.drwNo >= round - 5 }
        let drwNos: [Int] = winNumbers.map { Int($0.drwNo) }
        
        async let lotteryBeforeFiveWeeks = drwNos.contains(round - 5) ? convertToLottery(winNumber: winNumbers.first { $0.drwNo == round - 5 }!) : request(round: round - 5)
        async let lotteryBeforeFourWeeks = drwNos.contains(round - 4) ? convertToLottery(winNumber: winNumbers.first { $0.drwNo == round - 4 }!) : request(round: round - 4)
        async let lotteryBeforeThreeWeeks = drwNos.contains(round - 3) ? convertToLottery(winNumber: winNumbers.first { $0.drwNo == round - 3 }!) : request(round: round - 3)
        async let lotteryBeforeTwoWeeks = drwNos.contains(round - 2) ? convertToLottery(winNumber: winNumbers.first { $0.drwNo == round - 2 }!) : request(round: round - 2)
        async let lotteryBeforeOneWeeks = drwNos.contains(round - 1) ? convertToLottery(winNumber: winNumbers.first { $0.drwNo == round - 1 }!) : request(round: round - 1)
        
        let lotteries = try await [lotteryBeforeFiveWeeks,
                                 lotteryBeforeFourWeeks,
                                 lotteryBeforeThreeWeeks,
                                 lotteryBeforeTwoWeeks,
                                 lotteryBeforeOneWeeks]
        
        return lotteries
    }
    
    //TODO: 네트워크 분리
    static func request(round: Int) async throws -> Lottery {
        guard let url = URL(string: TextType.urlString + String(round)),
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
    
    static func saveAtCoreData(lotteries: [Lottery]) throws {
        try lotteries.forEach { try WinNumber.save(lottery: $0) }
    }
    
    static func convertToLottery(winNumber: WinNumber) -> Lottery {
        return Lottery(drwNo: winNumber.drwNo,
                       drwtNo1: winNumber.drwtNo1,
                       drwtNo2: winNumber.drwtNo2,
                       drwtNo3: winNumber.drwtNo3,
                       drwtNo4: winNumber.drwtNo4,
                       drwtNo5: winNumber.drwtNo5,
                       drwtNo6: winNumber.drwtNo6,
                       bnusNo: winNumber.bnusNo)
    }
    
    static func checkCondition(randomSet: [Int], lotteries: [Lottery]) -> [Bool] {
        let result1 = VerifyNumber.checkPairCount(randomSet)
        let result2 = VerifyNumber.checkSum(randomSet)
        let result3 = VerifyNumber.checkReappear(randomSet, lotteries[4])
        let result4 = VerifyNumber.checkLastBonus(randomSet, Int(lotteries[4].bnusNo))
        let result5 = VerifyNumber.checkLastWeeks(randomSet, Array(lotteries[2...4]), 2, 5)
        let result6 = VerifyNumber.checkLastWeeks(randomSet, lotteries, 1, 4)
        
        return [result1, result2, result3, result4, result5, result6]
    }
    
    static func storeAtFirebase(round: Int, numbers: [Int]) {
        let db = Firestore.firestore()
        db.collection(TextType.Firebase.recommendNumbers)
            .document("\(round)")
            .collection(TextType.Firebase.recommendNumber)
            .addDocument(data: [
                TextType.Firebase.numbers: numbers
        ])
    }
    
    static func requestToFireStore(round: Int) async throws -> [[Double]] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection(TextType.Firebase.winResult)
            .whereField("round", in: [Int](0..<4).map { "\(round - $0)" })
            .getDocuments()
        let documents = snapshot.documents.reversed()
        
        if documents.count == 0 {
            throw FirebaseError.noDocument
        }
        
        let result = documents.map { document -> [Double] in
            guard let data = document.data() as? [String: String],
                  let numbers = data["result"]?.split(separator: ",").compactMap({ Double($0) })
            else { return [] }
            return numbers
        }
        return result
    }
}
