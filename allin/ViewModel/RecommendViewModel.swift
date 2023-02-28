//
//  HomeViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import Foundation
import Network

final class RecommendViewModel: ObservableObject {
    private var numberSet: [[Int]] = Array(repeating: [Int](), count: 5)
    private let numberArray: [Int] = [Int](1...45)
    private let monitor = NWPathMonitor()
    
    let buttonTitle: [Int] = [1, 5, 10]
    
    @Published var resultArray: [[Int]] = []
    @Published var isAvailableTime: Bool = false
    @Published var isAvailableNetwork: Bool = false
    
    init() {
        configure()
    }
    
    deinit {
        monitor.cancel()
    }
    
    private func configure() {
        checkIsAvailableNetwork()
        
        isAvailableTime = getIsAvailableTime()
        if isAvailableTime == false { return }
        
        Task {
            await getNumberSet()
        }
    }
}

extension RecommendViewModel {
    private func getIsAvailableTime() -> Bool {
        let today = Calendar.current.dateComponents([.weekday, .hour], from: Date())
        
        guard let weekday = today.weekday,
                let hour = today.hour
        else {
            return false
        }
        
        if (weekday == 7 && hour >= 20) || (weekday == 1 && hour <= 8) {
            return false
        }
        
        return true
    }
    
    private func getDrawDate() -> Int {
        let calendar = Calendar.current
        
        guard let firstTime = calendar.date(from: DateComponents(year: 2002, month: 11, day: 30, hour: 20)),
              let dDay = calendar.dateComponents([.day], from: firstTime, to: Date()).day
        else {
            return 0
        }
        
        return dDay / 7 + 1
    }
    
    private func checkIsAvailableNetwork() {
        let queue = DispatchQueue.global(qos: .background)
        
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.isAvailableNetwork = true
                }
                    
            } else {
                if self.numberSet[0].isEmpty {
                    DispatchQueue.main.async {
                        self.isAvailableNetwork = false
                    }
                }
            }
        }
    }
}

extension RecommendViewModel {
    private func getNumberSet() async {
        let drawDate = getDrawDate()
        
        do {
            if let result = CustomFileManager.getNumberSetFromFile(drawDate) {
                numberSet = result
            } else {
                var numbers: [[Int]] = Array(repeating: [Int](), count: 5)
                
                for number in (drawDate-5)..<drawDate {
                    let data = try await NetworkManager.getLottery(number)
                    
                    let lottery = try JSONDecoder().decode(Lottery.self, from: data)
                    numbers[number-drawDate+5] = [lottery.drwtNo1, lottery.drwtNo2, lottery.drwtNo3, lottery.drwtNo4, lottery.drwtNo5, lottery.drwtNo6, lottery.bnusNo]
                }
                numberSet = numbers
                CustomFileManager.storeFile(numbers, drawDate)
            }
        } catch {
            print("numberSet error")
        }
    }
}

extension RecommendViewModel {
    func createNumbers(_ count: Int) {
        var result: [[Int]] = []
        
        if count == 10 {
            while result.count != 10 {
                let randomSet = numberArray.shuffled()[0...5].sorted()
                let (result1, result2, result3, result4, result5, result6) = checkAll(randomSet)
                
                if result.count < 8 {
                    if result1 && result2 && result3 && result4 && result5 && result6 {
                        result.append(randomSet)
                    }
                } else if result.count < 9 {
                    if result1 && !result2 && result3 && result4 && result5 && result6 {
                        result.append(randomSet)
                    }
                } else {
                    if result1 && result2 && result3 && !result4 && result5 && result6 {
                        result.append(randomSet)
                    }
                }
            }
        } else if count == 5 {
            while result.count != 5 {
                let randomSet = numberArray.shuffled()[0...5].sorted()
                let (result1, result2, result3, result4, result5, result6) = checkAll(randomSet)
                
                if result.count < 4 {
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
        } else {
            while result.count != 1 {
                let randomSet = numberArray.shuffled()[0...5].sorted()
                let (result1, result2, result3, result4, result5, result6) = checkAll(randomSet)

                if result1 && result2 && result3 && result4 && result5 && result6 {
                    result.append(randomSet)
                }
            }
        }
        
        resultArray = result
    }
}

extension RecommendViewModel {
    private func checkAll(_ randomSet: [Int]) -> (Bool, Bool, Bool, Bool, Bool, Bool) {
        let result1 = checkPairCount(randomSet)
        let result2 = checkSum(randomSet)
        let result3 = checkReappear(randomSet, Array(numberSet[4][0...5]))
        let result4 = checkLastBonus(randomSet, numberSet[4][6])
        let result5 = checkLastWeeks(randomSet, numberSet[2...4].reduce([], +), 2, 5)
        let result6 = checkLastWeeks(randomSet, numberSet.reduce([], +), 1, 4)
        
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

    private func checkReappear(_ numbers: [Int], _ lastNumbers: [Int]) -> Bool {
        return 0...1 ~= Set(numbers).intersection(Set(lastNumbers)).count
    }

    private func checkLastBonus(_ numbers: [Int], _ bonus: Int) -> Bool {
        return !numbers.contains(bonus)
    }

    private func checkLastWeeks(_ numbers: [Int], _ lastWeeksNumberSet: [Int], _ minNum: Int, _ maxNum: Int) -> Bool {
        return minNum...maxNum ~= Set([Int](1...45)).subtracting(Set(lastWeeksNumberSet)).intersection(Set(numbers)).count
    }
}
