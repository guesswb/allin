//
//  StoreService.swift
//  allin
//
//  Created by 김기훈 on 2023/05/31.
//

import Foundation
import Combine

final class StoreService {
    let storeRepository: StoreRepository
    let plistRepository: PlistRepository
    
    init(storeRepository: StoreRepository, plistRepository: PlistRepository) {
        self.storeRepository = storeRepository
        self.plistRepository = plistRepository
    }
    
    func requestStore(area: String) async throws -> Store {
        guard let plistData = try? plistRepository.data(fileName: "Info"),
              let naverCloudPlatform = try? PropertyListDecoder().decode(NaverDeveloper.self, from: plistData) else {
            throw PlistError.getData
        }
        
        let data = try await storeRepository.request(clientId: naverCloudPlatform.naverClientId, clientSecret: naverCloudPlatform.naverClientSecret, area: area)
        guard var store = try? JSONDecoder().decode(Store.self, from: data) else {
            throw JSONError.decode
        }
        store.items = store.items.map { item in
            var temp = item
            temp.title = Array(temp.title)
                .filter { $0.isASCII == false }
                .map { String($0) }
                .joined(separator: "")
            return temp
        }
        return store
    }
}
