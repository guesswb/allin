//
//  Requestable.swift
//  allin
//
//  Created by 김기훈 on 2023/05/31.
//

import Foundation

enum HTTPMethod: String {
    case `get` = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

typealias RequestHeaders = [String: String]
typealias RequestParameters = [String: Any]

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: RequestHeaders? { get }
    var queryParameters: RequestParameters? { get }
    var bodyParameters: RequestParameters? { get }
}

extension Requestable {
    func getRequest() throws -> URLRequest? {
        let url = try getURL()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if let parameters = bodyParameters {
            guard let json = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
                throw APIError.invalidBody
            }
            urlRequest.httpBody = json
        }
        return urlRequest
    }
    
    func getURL() throws -> URL {
        let fullPath: String = "\(baseURL + path)"
        guard var urlComponents = URLComponents(string: fullPath) else { throw APIError.invalidURL }
        
        let queryItems = queryParameters?.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { throw APIError.badRequest }
        return url
    }
}
