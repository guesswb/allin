//
//  StoreRequest.swift
//  allin
//
//  Created by 김기훈 on 2023/05/31.
//

import Foundation

enum StoreRequest {
    case stores(clientID: String, clientSecret: String, area: String)
}

extension StoreRequest: Requestable {
    var baseURL: String {
        return URLConstants.naverDeveloperURLString
    }
    
    var path: String {
        switch self {
        case .stores: return "/v1/search/local.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .stores: return .get
        }
    }
        
    var headers: RequestHeaders? {
        switch self {
        case .stores(let id, let secret, _): return ["X-Naver-Client-Id": "\(id)", "X-Naver-Client-Secret": "\(secret)"]
        }
    }
    
    var queryParameters: RequestParameters? {
        switch self {
        case .stores(_,_, let area): return ["query": "\(area) 복권", "display": "5", "start": "1", "sort": "random"]
        }
    }
    
    var bodyParameters: RequestParameters? {
        switch self {
        case .stores(_,_,_): return nil
        }
    }
}
