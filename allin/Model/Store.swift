//
//  Store.swift
//  allin
//
//  Created by 김기훈 on 2023/02/28.
//

import Foundation

struct Store: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [StoreItem]
    
    enum NaverCloud {
        enum Location {
            static let urlString: String = "https://openapi.naver.com/v1/search/local.json"
            
            static func queryItems(keyword: String) -> [URLQueryItem] {
                return [URLQueryItem(name: "query", value: "\(keyword)"),
                        URLQueryItem(name: "display", value: "5"),
                        URLQueryItem(name: "start", value: "1"),
                        URLQueryItem(name: "sort", value: "random")]
            }
        }
        
        enum HTTPHeader {
            static let clientID: String = "X-Naver-Client-Id"
            static let clientSecret: String = "X-Naver-Client-Secret"
        }
    }
    
    //TODO: 네트워크 분리
    static func storeInformations(keyword: String) async throws -> Store {
        guard var urlComponent = URLComponents(string: NaverCloud.Location.urlString) else {
            throw NetworkError.url
        }
    
        urlComponent.queryItems = NaverCloud.Location.queryItems(keyword: keyword)
        
        guard let url = urlComponent.url else {
            throw NetworkError.url
        }
        
        let plistData = try Plist.data()
        let plist = try PropertyListDecoder().decode(Plist.self, from: plistData)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(plist.naverClientId, forHTTPHeaderField: NaverCloud.HTTPHeader.clientID)
        urlRequest.addValue(plist.naverClientSecret, forHTTPHeaderField: NaverCloud.HTTPHeader.clientSecret)
        
        guard let (data, response) = try? await URLSession.shared.data(for: urlRequest),
              let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299 ~= statusCode) == true else {
            throw NetworkError.response
        }
        
        let store = try JSONDecoder().decode(Store.self, from: data)
        
        return store
    }
}

struct StoreItem: Codable {
    var title: String = ""
    var link: String = ""
    var category: String = ""
    var description: String = ""
    var telephone: String = ""
    var address: String = ""
    var roadAddress: String = ""
    var mapx: String = ""
    var mapy: String = ""
}
