//
//  NetworkError.swift
//  allin
//
//  Created by 김기훈 on 2023/02/28.
//

import Foundation

enum NetworkError: Error {
    case urlRequestError, urlError, statusCodeError
}
