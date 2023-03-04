//
//  Network.swift
//  allin
//
//  Created by 김기훈 on 2023/02/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    enum Request {
        case lottery, address
    }
    
    private static func request(_ urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse,
              200..<300 ~= response.statusCode
        else { throw NetworkError.statusCodeError }
        
        return data
    }
    
    static func getLottery(_ number: Int) async throws -> Data {
        guard let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)") else { throw NetworkError.urlError }
        let urlRequest = URLRequest(url: url)
        return try await request(urlRequest)
    }
    
    #if os(iOS)
    static func getAddress(_ lon: Double, _ lat: Double) async throws -> Data {
        guard var urlComponent = URLComponents(string: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc") else { throw NetworkError.urlError }
        
        let coords = URLQueryItem(name: "coords", value: "\(lon),\(lat)")
        let targetcrs = URLQueryItem(name: "targetcrs", value: "nhn:128")
        let orders = URLQueryItem(name: "orders", value: "legalcode")
        let output = URLQueryItem(name: "output", value: "json")
        
        urlComponent.queryItems = [coords, targetcrs, orders, output]
        
        var urlRequest = URLRequest(url: urlComponent.url!)
        
        guard let bundleURL = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            throw FileError.bundleError
        }
        
        let data = try Data(contentsOf: bundleURL)
        let result = try PropertyListDecoder().decode(Plist.self, from: data)
        
        urlRequest.addValue(result.NMFClientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        urlRequest.addValue(result.NMFClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        return try await request(urlRequest)
    }
    
    static func getStore(_ area: String) async throws -> Data {
        guard var urlComponent = URLComponents(string: "https://openapi.naver.com/v1/search/local.json") else { throw NetworkError.urlError }

        let query = URLQueryItem(name: "query", value: "\(area) 복권")
        let display = URLQueryItem(name: "display", value: "5")
        let start = URLQueryItem(name: "start", value: "1")
        let sort = URLQueryItem(name: "sort", value: "random")
        
        urlComponent.queryItems = [query, display, start, sort]

        var urlRequest = URLRequest(url: urlComponent.url!)
        
        guard let bundleURL = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            throw FileError.bundleError
        }
        
        let data = try Data(contentsOf: bundleURL)
        let result = try PropertyListDecoder().decode(Plist.self, from: data)
        
        urlRequest.addValue(result.naverClientId, forHTTPHeaderField: "X-Naver-Client-Id")
        urlRequest.addValue(result.naverClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        return try await request(urlRequest)
    }
    #endif
}
