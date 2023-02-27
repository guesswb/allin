//
//  StoreViewModel.swift
//  allin
//
//  Created by 김기훈 on 2023/02/27.
//

import Foundation

final class StoreViewModel: ObservableObject {
    
    @Published var currentLocation = Location.shared.currentLocation
    
    init() {
        
//        configure()
    }
    
//    private func configure() {
//        Task {
//            try await getStoreData()
//        }
//    }
//
//
//    private func getStoreData() async throws {
//        guard var urlComponent = URLComponents(string: "https://openapi.naver.com/v1/search/local.json") else { return }
//
//        let query = URLQueryItem(name: "query", value: "복권")
//        let display = URLQueryItem(name: "display", value: "5")
//        let start = URLQueryItem(name: "start", value: "1")
//        let sort = URLQueryItem(name: "sort", value: "random")
//
//        urlComponent.queryItems = [query, display, start, sort]
//
//        var urlRequest = URLRequest(url: urlComponent.url!)
//
//        guard let bundleURL = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
//            return
//        }
//
//        do {
//            let data = try Data(contentsOf: bundleURL)
//            let result = try PropertyListDecoder().decode(Plist.self, from: data)
//
//            urlRequest.addValue(result.naverClientId, forHTTPHeaderField: "X-Naver-Client-Id")
//            urlRequest.addValue(result.naverClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
//
//            let (responseData, _) = try await URLSession.shared.data(for: urlRequest)
//            let jsonString = String(data: responseData, encoding: .utf8)!
//            print(jsonString)
//        } catch {
//
//        }
//    }
}
