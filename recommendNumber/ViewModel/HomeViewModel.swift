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
    
    @Published var resultArray = [[Int]]()
    @Published var readyFlag: Bool = false
    
    init() {
        Task {
            try await getNumberSet(1054)
            
            DispatchQueue.main.async {
                self.readyFlag = true
            }
        }
    }
}

extension HomeViewModel {
    func createNumbers(_ count: Int) {
        var result: [[Int]] = []
        var lastWeekNumbers: [Int] = numberSet[4]
        var last3WeeksNumberSet: [Int] = numberSet[2...4].reduce([], +)
        var last5WeeksNumberSet: [Int] = numberSet.reduce([], +)
        
        
        if count == 10 {
            while result.count != 7 {
                let randomSet = numberArray.shuffled()[0...5].sorted()

                let result1 = checkPairCount(randomSet)
                let result2 = checkSum(randomSet)
                let result3 = checkReappear(randomSet, Array(lastWeekNumbers[0...5]))
                let result4 = checkLastBonus(randomSet, lastWeekNumbers[6])
                let result5 = checkLastWeeks(randomSet, last3WeeksNumberSet, 2, 5)
                let result6 = checkLastWeeks(randomSet, last5WeeksNumberSet, 1, 4)

                if result1 && result2 && result3 && result4 && result5 && result6 {
                    result.append(randomSet)
                }
            }

            while result.count != 8 {
                let randomSet = numberArray.shuffled()[0...5].sorted()

                let result1 = checkPairCount(randomSet)
                let result2 = checkSum(randomSet)
                let result3 = checkReappear(randomSet, Array(lastWeekNumbers[0...5]))
                let result4 = checkLastBonus(randomSet, lastWeekNumbers[6])
                let result5 = checkLastWeeks(randomSet, last3WeeksNumberSet, 2, 5)
                let result6 = checkLastWeeks(randomSet, last5WeeksNumberSet, 1, 4)

                if !result1 && result2 && result3 && result4 && result5 && result6 {
                    result.append(randomSet)
                }
            }

            while result.count != 9 {
                let randomSet = numberArray.shuffled()[0...5].sorted()

                let result1 = checkPairCount(randomSet)
                let result2 = checkSum(randomSet)
                let result3 = checkReappear(randomSet, Array(lastWeekNumbers[0...5]))
                let result4 = checkLastBonus(randomSet, lastWeekNumbers[6])
                let result5 = checkLastWeeks(randomSet, last3WeeksNumberSet, 2, 5)
                let result6 = checkLastWeeks(randomSet, last5WeeksNumberSet, 1, 4)

                if result1 && !result2 && result3 && result4 && result5 && result6 {
                    result.append(randomSet)
                }
            }

            while result.count != 10 {
                let randomSet = numberArray.shuffled()[0...5].sorted()

                let result1 = checkPairCount(randomSet)
                let result2 = checkSum(randomSet)
                let result3 = checkReappear(randomSet, Array(lastWeekNumbers[0...5]))
                let result4 = checkLastBonus(randomSet, lastWeekNumbers[6])
                let result5 = checkLastWeeks(randomSet, last3WeeksNumberSet, 2, 5)
                let result6 = checkLastWeeks(randomSet, last5WeeksNumberSet, 1, 4)

                if result1 && result2 && result3 && !result4 && result5 && result6 {
                    result.append(randomSet)
                }
            }

        } else if count == 5 {
            while result.count != 4 {
                let randomSet = numberArray.shuffled()[0...5].sorted()

                let result1 = checkPairCount(randomSet)
                let result2 = checkSum(randomSet)
                let result3 = checkReappear(randomSet, Array(lastWeekNumbers[0...5]))
                let result4 = checkLastBonus(randomSet, lastWeekNumbers[6])
                let result5 = checkLastWeeks(randomSet, last3WeeksNumberSet, 2, 5)
                let result6 = checkLastWeeks(randomSet, last5WeeksNumberSet, 1, 4)
                
                if result1 && result2 && result3 && result4 && result5 && result6 {
                    result.append(randomSet)
                }
            }

            while result.count != 5 {
                let randomSet = numberArray.shuffled()[0...5].sorted()

                let result1 = checkPairCount(randomSet)
                let result2 = checkSum(randomSet)
                let result3 = checkReappear(randomSet, Array(lastWeekNumbers[0...5]))
                let result4 = checkLastBonus(randomSet, lastWeekNumbers[6])
                let result5 = checkLastWeeks(randomSet, last3WeeksNumberSet, 2, 5)
                let result6 = checkLastWeeks(randomSet, last5WeeksNumberSet, 1, 4)

                let caseOne = !result1 && result2 && result3 && result4 && result5 && result6
                let caseTwo = result1 && !result2 && result3 && result4 && result5 && result6
                let caseThree = result1 && result2 && result3 && !result4 && result5 && result6

                if caseOne || caseTwo || caseThree {
                    result.append(randomSet)
                }
            }
        } else {
            while result.count != 1 {
                let randomSet = numberArray.shuffled()[0...5].sorted()

                let result1 = checkPairCount(randomSet)
                let result2 = checkSum(randomSet)
                let result3 = checkReappear(randomSet, Array(lastWeekNumbers[0...5]))
                let result4 = checkLastBonus(randomSet, lastWeekNumbers[6])
                let result5 = checkLastWeeks(randomSet, last3WeeksNumberSet, 2, 5)
                let result6 = checkLastWeeks(randomSet, last5WeeksNumberSet, 1, 4)

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
    }
}

extension HomeViewModel {
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
