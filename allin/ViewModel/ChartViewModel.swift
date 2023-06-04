//
//  ChartViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/05/25.
//

import Foundation
import Combine

final class ChartViewModel: ObservableObject {
    
    @Published var recommendedResult: [RecommendedResult] = []
    @Published var fetchDataStatus: FetchDataStatus = .success
    
    private let service: ChartService
    private var thisWeekRound: Int?
    private var cancellables = Set<AnyCancellable>()
    
    enum FetchDataStatus {
        case success
        case lastPage
        case failFetch
    }
        
    init(service: ChartService) {
        self.service = service
        self.thisWeekRound = try? Date.thisWeekRound()
    }
}

extension ChartViewModel {
    func request() {
        guard let thisWeekRound = thisWeekRound else { return }
        
        let beginRound = recommendedResult.isEmpty ? thisWeekRound - 1 : recommendedResult[recommendedResult.count - 1].round - 1
        
        Task { [weak self] in
            
            guard let self = self else { return }
            
            do {
                let recommendedResult = try await self.service.requestRecommendedResult(beginRound: beginRound)
                
                await MainActor.run {
                    self.recommendedResult += recommendedResult
                    self.fetchDataStatus = .success
                }
            } catch {
                await MainActor.run {
                    switch error {
                    case FirebaseError.fetch: self.fetchDataStatus = .failFetch
                    case FirebaseError.noDocument: self.fetchDataStatus = .lastPage
                    default: return
                    }
                }
            }
        }
    }
}
