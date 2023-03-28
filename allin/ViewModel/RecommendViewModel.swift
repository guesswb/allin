//
//  HomeViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import Foundation
import Alamofire

final class RecommendViewModel: ObservableObject {
    
    @Published var isAvailableTime: Bool = false
    @Published var isAvailableNetwork: Bool = true
    @Published var recommendNumberSet: [[Int]] = [[Int]]()
    
    private var drawRound: Int = 0
    private var numberSet: [Lottery] = Array(repeating: Lottery(), count: 5)
    
    init() {
        self.drawRound = getDrawRound()
        checkTime()
        setNumberSet()
    }
}

extension RecommendViewModel {
    
    private func setNumberSet() {
        Task {
            do {
                for number in (drawRound-5)..<drawRound {
                    let lottery = try await AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)")
                        .serializingDecodable(Lottery.self).value
                    numberSet[number - drawRound + 5] = lottery
                    DispatchQueue.main.async {
                        self.isAvailableNetwork = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isAvailableNetwork = false
                }
            }
        }
    }
    
    func checkTime() {
        let today = Calendar.current.dateComponents([.weekday, .hour], from: Date())
        
        guard let weekday = today.weekday, let hour = today.hour else {
            self.isAvailableTime = false
            return
        }
        
        if (weekday == 7 && hour >= 20) || (weekday == 1 && hour <= 8) {
            self.isAvailableTime = false
            return
        }
        
        self.isAvailableTime = true
    }
    
    private func getDrawRound() -> Int {
        let calendar = Calendar.current
        
        guard let firstTime = calendar.date(from: DateComponents(year: 2002, month: 11, day: 30, hour: 20)),
              let dDay = calendar.dateComponents([.day], from: firstTime, to: Date()).day
        else {
            return 0
        }
        
        return dDay / 7 + 1
    }
}

extension RecommendViewModel {
    func createNumbers(_ count: Int) {
        if numberSet.isEmpty {
            setNumberSet()
        }
        
        let numberArray: [Int] = [Int](1...45)
        
        var result: [[Int]] = []
        
        while result.count != count {
            let randomSet = numberArray.shuffled()[0...5].sorted()
            let (result1, result2, result3, result4, result5, result6) = checkAll(randomSet, numberSet)
            
            if result.count < 8 && count != 5 {
                if result1 && result2 && result3 && result4 && result5 && result6 {
                    result.append(randomSet)
                }
            } else {
                let caseOne = result1 && !result2 && result3 && result4 && result5 && result6
                let caseTwo = result1 && result2 && result3 && !result4 && result5 && result6

                if caseOne || caseTwo {
                    result.append(randomSet)
                }
            }
        }
        
        recommendNumberSet = result
    }

    private func checkAll(_ randomSet: [Int], _ numberSet: [Lottery]) -> (Bool, Bool, Bool, Bool, Bool, Bool) {
        let result1 = VerifyNumber.checkPairCount(randomSet)
        let result2 = VerifyNumber.checkSum(randomSet)
        let result3 = VerifyNumber.checkReappear(randomSet, numberSet[4])
        let result4 = VerifyNumber.checkLastBonus(randomSet, numberSet[4].bnusNo)
        let result5 = VerifyNumber.checkLastWeeks(randomSet, Array(numberSet[2...4]), 2, 5)
        let result6 = VerifyNumber.checkLastWeeks(randomSet, numberSet, 1, 4)
        
        return (result1, result2, result3, result4, result5, result6)
    }
}
