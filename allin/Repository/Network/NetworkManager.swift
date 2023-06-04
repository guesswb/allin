//
//  NetworkManager.swift
//  allin
//
//  Created by 김기훈 on 2023/05/31.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init () {}
    
    func request(with request: Requestable) async throws -> Data {
        guard let urlRequest = try? request.getRequest() else {
            throw NetworkError.url
        }
        
        guard let (data, response) = try? await URLSession.shared.data(for: urlRequest),
              let statusCode = (response as? HTTPURLResponse)?.statusCode,
              200...299 ~= statusCode else {
            throw NetworkError.response
        }
        
        return data
    }
}
