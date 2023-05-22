//
//  HomeViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import Foundation

final class RecommendViewModel: ObservableObject {
    
    @Published var appState: AppState = .unavailableNetwork
    @Published var recommendNumbers: [Int] = []
    
    let numbers: [Int] = Lottery.allNumbers
    
    private var winNumbers: [Lottery] = []
    private var conditionCount: Int = 0
    private var thisWeekRound = 0
    
    enum AppState {
        case unavailableTime
        case unavailableNetwork
        case available
    }
    
    init() {
        configure()
    }
}

extension RecommendViewModel {
    private func configure() {
        checkTime()
        
        if appState == .unavailableTime {
            return
        }
        Task {
            self.thisWeekRound = try Lottery.thisWeekRound()
            self.winNumbers = await winNumbers(thisWeekRound: thisWeekRound)
        }
    }
    
    func checkTime() {
        let currentTime = Lottery.currentDate()
        self.appState = Lottery.isAvailableTime(time: currentTime) ? .available : .unavailableTime
    }
    
    private func winNumbers(thisWeekRound: Int) async -> [Lottery] {
        do {
            async let lotteryBeforeFiveWeeks = Lottery.request(round: thisWeekRound - 5)
            async let lotteryBeforeFourWeeks = Lottery.request(round: thisWeekRound - 4)
            async let lotteryBeforeThreeWeeks = Lottery.request(round: thisWeekRound - 3)
            async let lotteryBeforeTwoWeeks = Lottery.request(round: thisWeekRound - 2)
            async let lotteryBeforeOneWeeks = Lottery.request(round: thisWeekRound - 1)

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
    
    func recommend() {
        if conditionCount == 4 {
            let randomSet = numbers.shuffled()[0...5].sorted()
            let condition = Lottery.checkCondition(randomSet: randomSet, winNumbers: winNumbers)
            
            if condition[1] == false && condition.filter({ $0 == false }).count == 1 {
                recommendNumbers = randomSet
                Lottery.storeAtFirebase(round: thisWeekRound, numbers: randomSet)
                conditionCount = 0
                return
            }
        }
        
        while true {
            let randomSet = numbers.shuffled()[0...5].sorted()
            let condition = Lottery.checkCondition(randomSet: randomSet, winNumbers: winNumbers)
            
            if condition.allSatisfy({ $0 == true }) {
                recommendNumbers = randomSet
                Lottery.storeAtFirebase(round: thisWeekRound, numbers: randomSet)
                conditionCount += 1
                return
            }
        }
    }
}
