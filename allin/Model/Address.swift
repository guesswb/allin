//
//  Address.swift
//  allin
//
//  Created by 김기훈 on 2023/02/28.
//

import Foundation
import CoreLocation

struct Address: Codable {
    var status: Status = Status(code: 0, name: "", message: "")
    var results: [Result] = []
    
    enum NaverDevelopers {
        enum Geocode {
            static let urlString: String = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
            
            static func queryItems(coordinate: String) -> [URLQueryItem] {
                return [URLQueryItem(name: "coords", value: coordinate),
                        URLQueryItem(name: "targetcrs", value: "nhn:128"),
                        URLQueryItem(name: "orders", value: "legalcode"),
                        URLQueryItem(name: "output", value: "json")]
            }
        }
        
        enum HTTPHeader {
            static let APIKeyId: String = "X-NCP-APIGW-API-KEY-ID"
            static let APIKey: String = "X-NCP-APIGW-API-KEY"
        }
    }
    
    static func currentAddress(longitude: CLLocationDegrees, latitude: CLLocationDegrees) async throws -> Address {
        guard var urlComponent = URLComponents(string: NaverDevelopers.Geocode.urlString) else {
            throw NetworkError.url
        }
                
        urlComponent.queryItems = NaverDevelopers.Geocode.queryItems(coordinate: "\(longitude),\(latitude)")
        
        guard let url = urlComponent.url else {
            throw NetworkError.url
        }
        
        let plistData = try Plist.data()
        let plist = try PropertyListDecoder().decode(Plist.self, from: plistData)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(plist.NMFClientId, forHTTPHeaderField: NaverDevelopers.HTTPHeader.APIKeyId)
        urlRequest.addValue(plist.NMFClientSecret, forHTTPHeaderField: NaverDevelopers.HTTPHeader.APIKey)
        
        guard let (data, response) = try? await URLSession.shared.data(for: urlRequest),
              let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299 ~= statusCode) == true else {
            throw NetworkError.response
        }
                
        let address = try JSONDecoder().decode(Address.self, from: data)
        
        return address
    }
    
}

struct Result: Codable {
    let name: String
    let code: Code
    let region: Region
}

struct Code: Codable {
    let id, type, mappingID: String

    enum CodingKeys: String, CodingKey {
        case id, type
        case mappingID = "mappingId"
    }
}

struct Region: Codable {
    let area0, area1, area2, area3, area4: Area
}

struct Area: Codable {
    let name: String
    let coords: Coords
}

struct Coords: Codable {
    let center: Center
}

struct Center: Codable {
    let crs: String
    let x, y: Double
}

struct Status: Codable {
    let code: Int
    let name, message: String
}
