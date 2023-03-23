//
//  HomeViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import Foundation
import Combine
import Alamofire

final class RecommendViewModel: ObservableObject {
    
    @Published var isAvailableTime: Bool = false
    @Published var isAvailableNetwork: Bool = true
    @Published var recommendNumberSet: [[Int]] = [[Int]]()
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    private var drawRound: Int = 0
    private var numberSet: [Lottery] = Array(repeating: Lottery(), count: 5)
    
    init() {
        self.isAvailableTime = checkTime()
        self.drawRound = getDrawRound()
        setNumberSet()
    }
}

extension RecommendViewModel {
    
    private func setNumberSet() {
        let drawRound = drawRound
        
        for number in (drawRound-5)..<drawRound {
            AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)")
                .responseDecodable(of: Lottery.self) { response in
                    DispatchQueue.main.async {
                        self.numberSet[number - drawRound + 5] = (Lottery(drwtNo1: response.value?.drwtNo1 ?? 0,
                                                                          drwtNo2: response.value?.drwtNo2 ?? 0,
                                                                          drwtNo3: response.value?.drwtNo3 ?? 0,
                                                                          drwtNo4: response.value?.drwtNo4 ?? 0,
                                                                          drwtNo5: response.value?.drwtNo5 ?? 0,
                                                                          drwtNo6: response.value?.drwtNo6 ?? 0,
                                                                          bnusNo: response.value?.bnusNo ?? 0))
                    }
                }
        }
    }
    
    private func checkTime() -> Bool {
        let today = Calendar.current.dateComponents([.weekday, .hour], from: Date())
        
        guard let weekday = today.weekday, let hour = today.hour else {
            return false
        }
        
        if (weekday == 7 && hour >= 20) || (weekday == 1 && hour <= 8) {
            return false
        }
        
        return true
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
        let result1 = checkPairCount(randomSet)
        let result2 = checkSum(randomSet)
        let result3 = checkReappear(randomSet, numberSet[4])
        let result4 = checkLastBonus(randomSet, numberSet[4].bnusNo)
        let result5 = checkLastWeeks(randomSet, Array(numberSet[2...4]), 2, 5)
        let result6 = checkLastWeeks(randomSet, numberSet, 1, 4)
        
        return (result1, result2, result3, result4, result5, result6)
    }
    
    private func checkPairCount(_ numbers: [Int]) -> Bool {
        var result = 0

        for index in 0...4 {
            if numbers[index] + 1 == numbers[index + 1] {
                result += 1
            }
        }
        return 0...1 ~= result
    }

    private func checkSum(_ numbers: [Int]) -> Bool {
        return 90...180 ~= numbers.reduce(0, +)
    }

    private func checkReappear(_ numbers: [Int], _ lastNumbers: Lottery) -> Bool {
        return 0...1 ~= Set(numbers).intersection(Set(lastNumbers.winNumbers())).count
    }

    private func checkLastBonus(_ numbers: [Int], _ bonus: Int) -> Bool {
        return !numbers.contains(bonus)
    }

    private func checkLastWeeks(_ numbers: [Int], _ lastWeeksNumberSet: [Lottery], _ minNum: Int, _ maxNum: Int) -> Bool {
        let appearNumbers = lastWeeksNumberSet.map { $0.winNumbers() }.flatMap { $0 }
        return minNum...maxNum ~= Set([Int](1...45)).subtracting(Set(appearNumbers)).intersection(Set(numbers)).count
    }
}
