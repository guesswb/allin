//
//  HomeViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import Foundation

final class RecommendViewModel: ObservableObject {
    
    @Published var isAvailableTime: Bool = Lottery.isAvailableTime()
    @Published var isAvailableNetwork: Bool = true
    @Published var recommendNumbers: [[Int]] = [[Int]]()
    
    private var lotteryRound: Int = Lottery.thisWeekRound()
    private var winNumbers: [Lottery] = Array(repeating: Lottery(), count: 5)
    
    init() {
        winNumbers(weeks: 5)
    }
}

extension RecommendViewModel {
    private func winNumbers(weeks: Int) {
        ((lotteryRound-weeks)..<lotteryRound).forEach { round in
            Task {
                do {
                    let lottery = try await Lottery.request(round: round)
                    winNumbers[round - lotteryRound + weeks] = lottery
                } catch {
                    self.isAvailableNetwork = false
                }
            }
        }
    }
    
    func checkTime() {
        self.isAvailableTime = Lottery.isAvailableTime()
    }
    
    func recommendNumbers(count: Int) {
        var result: [[Int]] = []
        
        while result.count != count {
            let randomSet = Lottery.allNumbers.shuffled()[0...5].sorted()
            let allCondition = checkAllCondition(randomSet: randomSet)
            
            if result.count != count && allCondition.allSatisfy({$0}) {
                result.append(randomSet)
            } else if result.count == count - 1 &&
                        allCondition[1] == false &&
                        allCondition.filter({$0 == false}).count == 1 {
                    result.append(randomSet)
            }
        }
        recommendNumbers = result
    }
    
    private func checkAllCondition(randomSet: [Int]) -> [Bool] {
        let result1 = VerifyNumber.checkPairCount(randomSet)
        let result2 = VerifyNumber.checkSum(randomSet)
        let result3 = VerifyNumber.checkReappear(randomSet, winNumbers[4])
        let result4 = VerifyNumber.checkLastBonus(randomSet, winNumbers[4].bnusNo)
        let result5 = VerifyNumber.checkLastWeeks(randomSet, Array(winNumbers[2...4]), 2, 5)
        let result6 = VerifyNumber.checkLastWeeks(randomSet, winNumbers, 1, 4)
        
        return [result1, result2, result3, result4, result5, result6]
    }
}
