//
//  HomeViewModel.swift
//  recommendNumber
//
//  Created by 김기훈 on 2023/02/16.
//

import Foundation

final class HomeViewModel: ObservableObject {
    private var numberSet: [[Int]] = Array(repeating: [Int](), count: 5)
    private let numberArray: [Int] = [Int](1...45)
    private var lastWeekNumbers: [Int] = []
    private var last3WeeksNumberSet: [Int] = []
    private var last5WeeksNumberSet: [Int] = []
    
    @Published var resultArray = [[Int]]()
    
    init() {
        if isAvailable() == false {
            return
        }
        
        let firstTime = Calendar.current.date(from: DateComponents(year: 2002, month: 11, day: 30, hour: 20))!
        let dDay = Calendar.current.dateComponents([.day], from: firstTime, to: Date()).day!
        let drawDate = dDay / 7 + 1

        Task {
            try await getNumberSet(drawDate)
        }
    }
}

extension HomeViewModel {
    private func isAvailable() -> Bool {
        let today = Calendar.current.dateComponents([.weekday, .hour], from: Date())
        
        guard let weekday = today.weekday, let hour = today.hour else {
            return false
        }
        
        if (weekday == 7 && hour >= 20) || (weekday == 1 && hour <= 8) {
            return false
        }
        
        return true
    }
    
    func createNumbers(_ count: Int) {
        var result: [[Int]] = []
        
        if count == 10 {
            while result.count != 10 {
                let randomSet = numberArray.shuffled()[0...5].sorted()
                let (result1, result2, result3, result4, result5, result6) = checkAll(randomSet)
                
                if result.count < 7 {
                    if result1 && result2 && result3 && result4 && result5 && result6 {
                        result.append(randomSet)
                    }
                } else if result.count < 8 {
                    if !result1 && result2 && result3 && result4 && result5 && result6 {
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
                    let caseOne = !result1 && result2 && result3 && result4 && result5 && result6
                    let caseTwo = result1 && !result2 && result3 && result4 && result5 && result6
                    let caseThree = result1 && result2 && result3 && !result4 && result5 && result6

                    if caseOne || caseTwo || caseThree {
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

extension HomeViewModel {
    private func getNumberSet(_ N: Int) async throws {
        for number in (N-5)..<N {
            guard let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)") else { return }

            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)

            let json = try JSONDecoder().decode(Lottery.self, from: data)
            numberSet[number-N+5] = [json.drwtNo1, json.drwtNo2, json.drwtNo3, json.drwtNo4, json.drwtNo5, json.drwtNo6, json.bnusNo]
        }
        lastWeekNumbers = numberSet[4]
        last3WeeksNumberSet = numberSet[2...4].reduce([], +)
        last5WeeksNumberSet = numberSet.reduce([], +)
    }
}

extension HomeViewModel {
    private func checkAll(_ randomSet: [Int]) -> (Bool, Bool, Bool, Bool, Bool, Bool) {
        let result1 = checkPairCount(randomSet)
        let result2 = checkSum(randomSet)
        let result3 = checkReappear(randomSet, Array(lastWeekNumbers[0...5]))
        let result4 = checkLastBonus(randomSet, lastWeekNumbers[6])
        let result5 = checkLastWeeks(randomSet, last3WeeksNumberSet, 2, 5)
        let result6 = checkLastWeeks(randomSet, last5WeeksNumberSet, 1, 4)
        
        return (result1, result2, result3, result4, result5, result6)
    }
    
    private func checkPairCount(_ numbers: [Int]) -> Bool {
        var result = 0

        for index in 0...4 {
            if numbers[index] == numbers[index + 1] {
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
        return numbers.contains(bonus)
    }

    private func checkLastWeeks(_ numbers: [Int], _ lastWeeksNumberSet: [Int], _ minNum: Int, _ maxNum: Int) -> Bool {
        return minNum...maxNum ~= Set([Int](1...45)).subtracting(Set(lastWeeksNumberSet)).intersection(Set(numbers)).count
    }
}
