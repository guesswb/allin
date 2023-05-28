//
//  ChartViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/05/25.
//

import Foundation

final class ChartViewModel: ObservableObject {
    @Published var lotteryRound: [Int] = []
    @Published var lotteryResult: [[Double]] = []
    @Published var isLastPage: Bool = false
    
    private var thisWeekRound: Int = 0
        
    init() {
        configure()
    }
}

extension ChartViewModel {
    private func configure() {
        do {
            self.thisWeekRound = try Lottery.thisWeekRound()
        } catch {
            
        }
    }
    
    func request() async {
        do {
            let round = lotteryRound.isEmpty ? thisWeekRound - 1 : lotteryRound[lotteryRound.count - 1] - 1
            let numbers = try await Lottery.requestToFireStore(round: round)
            let rounds = [Int](0..<numbers.count).map { round - $0 }
            
            DispatchQueue.main.async {
                self.lotteryRound += rounds
                self.lotteryResult += numbers
            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.isLastPage = true
            }
        }
        
    }
}
