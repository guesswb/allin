//
//  StoreRepository.swift
//  allin
//
//  Created by 김기훈 on 2023/06/01.
//

import Foundation
import Combine

final class StoreRepository {
    func request(clientId: String, clientSecret: String, area: String) async throws -> Data {
        let request = StoreRequest.stores(clientID: clientId, clientSecret: clientSecret, area: area)
        return try await NetworkManager.shared.request(with: request)
    }
}
