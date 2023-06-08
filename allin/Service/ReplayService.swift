//
//  ReplayService.swift
//  allin
//
//  Created by 김기훈 on 2023/06/08.
//

import Foundation
import FirebaseFirestore

final class ReplayService {
    let replayDataRepository: ReplayDataRepository
    
    init(replayDataRepository: ReplayDataRepository) {
        self.replayDataRepository = replayDataRepository
    }
    
    func requestReplay() async throws -> [Replay] {
        let snapshots = try await replayDataRepository.requestToFireStore()
        
        let replayData = try snapshots.map { snapshot in
            guard let json = try? JSONSerialization.data(withJSONObject: snapshot.data()),
                  let recommendedResult = try? JSONDecoder().decode(Replay.self, from: json) else {
                throw JSONError.decode
            }
            return recommendedResult
        }
        
        return replayData
    }
}
