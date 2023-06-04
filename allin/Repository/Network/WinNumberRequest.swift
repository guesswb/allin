//
//  LotteryRequest.swift
//  allin
//
//  Created by 김기훈 on 2023/05/31.
//

import Foundation

enum WinNumberRequest {
    case winNumber(round: Int)
}

extension WinNumberRequest: Requestable {
    var baseURL: String {
        return URLConstants.lotteryURLString
    }
    
    var path: String {
        switch self {
        case .winNumber: return "/common.do"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .winNumber: return .get
        }
    }
    
    var headers: RequestHeaders? {
        switch self {
        case .winNumber(_): return nil
        }
    }
    
    var queryParameters: RequestParameters? {
        switch self {
        case .winNumber(let round): return ["method": "getLottoNumber", "drwNo": "\(round)"]
        }
    }
    
    var bodyParameters: RequestParameters? {
        switch self {
        case .winNumber(_): return nil
        }
    }
}
