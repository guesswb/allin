//
//  Lottery.swift
//  allin
//
//  Created by 김기훈 on 2023/05/16.
//

import Foundation
import CoreData

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
    }

    private enum DateType {
        static let firstRound: DateComponents = DateComponents(year: 2002, month: 11, day: 30, hour: 20)
    }
}

extension Lottery {
    func winNumbers() -> [Int] {
        return [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6].map { Int($0) }
    }
    
    static func thisWeekRound() -> Int {
        guard let date = Calendar.current.date(from: DateComponents(year: 2002, month: 11, day: 30, hour: 20)),
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
        if let lottery = try fetchFromCoreData(round: round) {
            return lottery
        }
        
        guard let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=" + String(round)),
              let (data, response) = try? await URLSession.shared.data(from: url),
              let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299 ~= statusCode) == true else {
            throw NetworkError.response
        }
        
        guard let lottery = try? JSONDecoder().decode(Lottery.self, from: data) else {
            throw JSONError.decode
        }
        
        guard let _ = try? saveAtCoreData(lottery: lottery) else {
            throw CoreDataError.save
        }
        
        return lottery
    }
    
    static func fetchFromCoreData(round: Int) throws -> Lottery? {
        let request = NSFetchRequest<WinNumber>(entityName: "WinNumber")
        let context = PersistenceController.shared.container.viewContext
        
        let predicate = NSPredicate(format: "drwNo == %d", round)
        request.predicate = predicate
        
        let result = try context.fetch(request)
        guard let winNumber = result.filter({ $0.drwNo == round }).first else { return nil }
        
        return convertWinNumberToLottery(winNumber: winNumber)
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
    
    static func saveAtCoreData(lottery: Lottery) throws {
        let context = PersistenceController.shared.container.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "WinNumber", in: context) else {
            throw CoreDataError.entity
        }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(lottery.drwNo, forKey: "drwNo")
        object.setValue(lottery.bnusNo, forKey: "bnusNo")
        object.setValue(lottery.drwtNo1, forKey: "drwtNo1")
        object.setValue(lottery.drwtNo2, forKey: "drwtNo2")
        object.setValue(lottery.drwtNo3, forKey: "drwtNo3")
        object.setValue(lottery.drwtNo4, forKey: "drwtNo4")
        object.setValue(lottery.drwtNo5, forKey: "drwtNo5")
        object.setValue(lottery.drwtNo6, forKey: "drwtNo6")
        
        try context.save()
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
}
