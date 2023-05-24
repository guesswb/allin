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
    
    private var thisWeekRound = 0
    private var lotteries: [Lottery] = Array(repeating: Lottery(), count: 5)
    private var conditionCount: Int = 0
    
    enum AppState {
        case unavailableDate
        case unavailableNetwork
        case available
    }
    
    private enum DateType {
        static let firstRound: DateComponents = DateComponents(year: 2002, month: 11, day: 30, hour: 20)
    }
}

extension RecommendViewModel {
    func configure() {
        do {
            try checkDate()
            try checkRound()
            try request(round: thisWeekRound)
            
            self.appState = .available
        } catch {
            switch error {
            case DateError.fetchDate, DateError.unAvailableDate:
                self.appState = .unavailableDate
            default:
                self.appState = .unavailableNetwork
            }
        }
    }
    
    private func checkDate() throws {
        let date = Calendar.current.dateComponents([.weekday, .hour], from: Date())
        
        guard let weekday = date.weekday, let hour = date.hour else {
            throw DateError.fetchDate
        }
        
        if (weekday == 7 && hour >= 20) == true || (weekday == 1 && hour <= 8) == true {
            throw DateError.unAvailableDate
        }
    }
    
    private func checkRound() throws {
        guard let date = Calendar.current.date(from: DateType.firstRound),
              let daysSinceFirstDay = Calendar.current.dateComponents([.day], from: date, to: Date()).day else {
            throw DateError.fetchDate
        }
        self.thisWeekRound = daysSinceFirstDay / 7 + 1
    }
    
    private func request(round: Int) throws {
        Task {
            let lotteries = try await Lottery.fetchInitialLottery(round: round)
            self.lotteries = lotteries
            try Lottery.saveAtCoreData(lotteries: lotteries)
        }
    }
    
    func recommend() {
        while true {
            let randomSet = numbers.shuffled()[0...5].sorted()
            let condition = Lottery.checkCondition(randomSet: randomSet, lotteries: lotteries)
            
            if conditionCount < 4 && condition.allSatisfy({ $0 == true }) == false {
                continue
            }
            
            if conditionCount == 4 && (condition[1] == false && condition.filter({ $0 == false }).count == 1) == false {
                continue
            }
                
            recommendNumbers = randomSet
            Lottery.storeAtFirebase(round: thisWeekRound, numbers: randomSet)
            conditionCount += conditionCount < 4 ? 1 : -conditionCount
            return
        }
    }
}
