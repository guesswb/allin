//
//  ChartService.swift
//  allin
//
//  Created by 김기훈 on 2023/05/31.
//

import Foundation
import FirebaseFirestore

final class ChartService {
    let recommendedResultRepository: RecommendedResultRepository
    
    init(recommendedResultRepository: RecommendedResultRepository) {
        self.recommendedResultRepository = recommendedResultRepository
    }
    
    func requestRecommendedResult(beginRound: Int) async throws -> [RecommendedResult] {
        let snapshots = try await recommendedResultRepository.requestToFireStore(rounds: [beginRound, beginRound-1, beginRound-2, beginRound-3])
        
        let recommededResult = try snapshots.map { snapshot in
            guard let json = try? JSONSerialization.data(withJSONObject: snapshot.data()),
                  let recommendedResult = try? JSONDecoder().decode(RecommendedResult.self, from: json) else {
                throw JSONError.decode
            }
            return recommendedResult
        }
        
        return recommededResult
    }
}
