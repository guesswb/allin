//
//  HomeViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import Foundation
import Combine

final class RecommendViewModel: ObservableObject {
    
    @Published var appState: AppState = .unavailableNetwork
    @Published var recommendNumbers: [Int] = []
    
    private let service: RecommendService
    
    let numbers: [Int] = [Int](1...45)
    
    private var thisWeekRound: Int?
    private var winNumbers: [WinNumber] = Array(repeating: WinNumber(), count: 5)
    private var conditionCount: Int = 0
    private var cancellables = Set<AnyCancellable>()
    
    enum AppState {
        case unavailableDate
        case unavailableNetwork
        case available
    }
    
    init(service: RecommendService) {
        self.service = service
    }
}

extension RecommendViewModel {
    func configure() {
        do {
            try checkDate()
            let thisWeekRound = try Date.thisWeekRound()
            self.thisWeekRound = thisWeekRound
            
            let winNumberFromCoreData = try service.fetchWinNumber(above: thisWeekRound - 5)
            
            Task {
                let beforeFiveWeek = pickWinNumberFromArray(round: thisWeekRound - 5, winNumber: winNumberFromCoreData)
                async let winNumberBeforeFiveWeeks = beforeFiveWeek == nil ? service.requestWinNumber(round: thisWeekRound-5) : beforeFiveWeek
                
                let beforeFourWeek = pickWinNumberFromArray(round: thisWeekRound - 4, winNumber: winNumberFromCoreData)
                async let winNumberBeforeFourWeeks = beforeFourWeek == nil ? service.requestWinNumber(round: thisWeekRound-4) : beforeFourWeek
                
                let beforeThreeWeek = pickWinNumberFromArray(round: thisWeekRound - 3, winNumber: winNumberFromCoreData)
                async let winNumberBeforeThreeWeeks = beforeThreeWeek == nil ? service.requestWinNumber(round: thisWeekRound-3) : beforeThreeWeek
                
                let beforeTwoWeek = pickWinNumberFromArray(round: thisWeekRound - 2, winNumber: winNumberFromCoreData)
                async let winNumberBeforeTwoWeeks = beforeThreeWeek == nil ? service.requestWinNumber(round: thisWeekRound-2) : beforeTwoWeek
                
                let beforeOneWeek = pickWinNumberFromArray(round: thisWeekRound - 1, winNumber: winNumberFromCoreData)
                async let winNumberBeforeOneWeeks = beforeOneWeek == nil ? service.requestWinNumber(round: thisWeekRound-1) : beforeOneWeek

                let winNumbers = try await [winNumberBeforeFiveWeeks,
                                           winNumberBeforeFourWeeks,
                                           winNumberBeforeThreeWeeks,
                                           winNumberBeforeTwoWeeks,
                                            winNumberBeforeOneWeeks].compactMap { $0 }
                
                self.winNumbers = winNumbers
                
                await MainActor.run {
                    self.appState = .available
                }

            }
        } catch {
            switch error {
            case DateError.fetchDate, DateError.unAvailableDate:
                self.appState = .unavailableDate
            default:
                self.appState = .unavailableNetwork
            }
        }
    }
    
    private func pickWinNumberFromArray(round: Int, winNumber: [WinNumber]) -> WinNumber? {
        return winNumber.first { $0.drwNo == round }
    }
    
    private func checkDate() throws {
        let date = Calendar.current.dateComponents([.weekday, .hour, .minute], from: Date())

        guard let weekday = date.weekday, let hour = date.hour, let minute = date.minute else {
            throw DateError.fetchDate
        }
        
        if (weekday == 7 && hour >= 20 && minute >= 0) == true
            || (weekday == 1 && hour <= 8 && minute <= 0) == true {
            throw DateError.unAvailableDate
        }
    }
}

extension RecommendViewModel {
    func recommend() {
        while true {
            let randomSet = numbers.shuffled()[0...5].sorted()
            let condition = checkCondition(randomSet: randomSet, winNumbers: winNumbers)

            if conditionCount < 4 && condition.allSatisfy({ $0 == true }) == false {
                continue
            }

            if conditionCount == 4 && (condition[1] == false && condition.filter({ $0 == false }).count == 1) == false {
                continue
            }
            recommendNumbers = randomSet
            conditionCount += conditionCount < 4 ? 1 : -conditionCount
            
            service.save(round: thisWeekRound ?? 0, recommendNumber: randomSet)
            return
        }
    }

    private func checkCondition(randomSet: [Int], winNumbers: [WinNumber]) -> [Bool] {
        let result1 = VerifyNumber.checkPairCount(randomSet)
        let result2 = VerifyNumber.checkSum(randomSet)
        let result3 = VerifyNumber.checkReappear(randomSet, winNumbers[4])
        let result4 = VerifyNumber.checkLastBonus(randomSet, Int(winNumbers[4].bnusNo))
        let result5 = VerifyNumber.checkLastWeeks(randomSet, Array(winNumbers[2...4]), 2, 5)
        let result6 = VerifyNumber.checkLastWeeks(randomSet, winNumbers, 1, 4)

        return [result1, result2, result3, result4, result5, result6]
    }
}
