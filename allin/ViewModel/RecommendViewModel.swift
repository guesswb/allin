//
//  HomeViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import Foundation

final class RecommendViewModel: ObservableObject {
    
    @Published var appState: AppState = .available
    @Published var recommendNumbers: [Int] = []
    
    let numbers: [Int] = Lottery.allNumbers
    
    private var winNumbers: [Lottery] = []
    private var conditionCount: Int = 0
    
    enum AppState {
        case unavailableTime
        case unavailableNetwork
        case available
    }
    
    init() {
        Task {
            self.winNumbers = await winNumbers()
        }
    }
}

extension RecommendViewModel {
    private func winNumbers() async -> [Lottery] {
        let lotteryRound: Int = Lottery.thisWeekRound()
        
        async let lotteryBeforeFiveWeeks = Lottery.request(round: lotteryRound - 5)
        async let lotteryBeforeFourWeeks = Lottery.request(round: lotteryRound - 4)
        async let lotteryBeforeThreeWeeks = Lottery.request(round: lotteryRound - 3)
        async let lotteryBeforeTwoWeeks = Lottery.request(round: lotteryRound - 2)
        async let lotteryBeforeOneWeeks = Lottery.request(round: lotteryRound - 1)
        
        do {
            let lottery = try await [lotteryBeforeFiveWeeks,
                                     lotteryBeforeFourWeeks,
                                     lotteryBeforeThreeWeeks,
                                     lotteryBeforeTwoWeeks,
                                     lotteryBeforeOneWeeks]
            DispatchQueue.main.async {
                self.appState = .available
            }
            return lottery
        } catch {
            DispatchQueue.main.async {
                self.appState = .unavailableNetwork
            }
            return []
        }
    }
    
    func checkTime() {
        self.appState = Lottery.isAvailableTime() ? .available : .unavailableTime
    }
    
    func recommend() {
        if conditionCount == 4 {
            let randomSet = numbers.shuffled()[0...5].sorted()
            let condition = Lottery.checkCondition(randomSet: randomSet, winNumbers: winNumbers)
            
            if condition[1] == false && condition.filter({ $0 == false }).count == 1 {
                recommendNumbers = randomSet
                conditionCount = 0
                return
            }
        }
        
        while true {
            let randomSet = numbers.shuffled()[0...5].sorted()
            let condition = Lottery.checkCondition(randomSet: randomSet, winNumbers: winNumbers)
            
            if condition.allSatisfy({ $0 == true }) {
                recommendNumbers = randomSet
                conditionCount += 1
                return
            }
        }
    }
}
