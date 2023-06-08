//
//  ReplayViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/06/08.
//

import Foundation

final class ReplayViewModel: ObservableObject {
    @Published var replayData: [Replay] = []
    @Published var fetchDataStatus: FetchDataStatus = .success
    
    private let service: ReplayService
    
    enum FetchDataStatus {
        case success
        case lastPage
        case failFetch
    }
    
    init(replayService: ReplayService) {
        self.service = replayService
        request()
    }
}

extension ReplayViewModel {
    private func request() {
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let replay = try await self.service.requestReplay()
                
                await MainActor.run {
                    self.replayData += replay.sorted { $0.round > $1.round }
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
