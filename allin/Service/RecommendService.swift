//
//  RecommendService.swift
//  allin
//
//  Created by 김기훈 on 2023/05/31.
//

import Foundation

struct RecommendService {
    let winNumberRepository: WinNumberEntityRepository
    let recommendNumberRepository: RecommendNumberRepository
    
    init(winNumberRepository: WinNumberEntityRepository, recommendNumberRepository: RecommendNumberRepository) {
        self.winNumberRepository = winNumberRepository
        self.recommendNumberRepository = recommendNumberRepository
    }
    
    func fetchWinNumber(above: Int) throws -> [WinNumber] {
        let winNumberEntities: [WinNumberEntity] = try winNumberRepository.fetch(above: above)
        
        return winNumberEntities.map { (winNumberEntity) -> WinNumber in
            return WinNumber(drwNo: Int(winNumberEntity.drwNo),
                             drwtNo1: Int(winNumberEntity.drwtNo1),
                             drwtNo2: Int(winNumberEntity.drwtNo2),
                             drwtNo3: Int(winNumberEntity.drwtNo3),
                             drwtNo4: Int(winNumberEntity.drwtNo4),
                             drwtNo5: Int(winNumberEntity.drwtNo5),
                             drwtNo6: Int(winNumberEntity.drwtNo6),
                             bnusNo: Int(winNumberEntity.bnusNo))
        }
    }
    
    func requestWinNumber(round: Int) async throws -> WinNumber {
        let data = try await winNumberRepository.request(round: round)
        guard let winNumber = try? JSONDecoder().decode(WinNumber.self, from: data) else {
            throw JSONError.decode
        }
        save(winNumber: winNumber)
        return winNumber
    }
    
    func save(winNumber: WinNumber) {
        winNumberRepository.save(winNumber: winNumber)
    }
    
    func save(round: Int, recommendNumber: [Int]) {
        recommendNumberRepository.save(round: round, numbers: recommendNumber)
    }
}
