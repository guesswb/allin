//
//  Error.swift
//  allin
//
//  Created by 김기훈 on 2023/03/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidBody
    case badRequest
}

enum NetworkError: Error {
    case url
    case response
}

enum JSONError: Error {
    case decode
    case encode
}

enum PlistError: Error {
    case getData
}

enum CoreDataError: Error {
    case entity
    case save
    case fetch
    case convert
}

enum DateError: Error {
    case round
    case fetchDate
    case unAvailableDate
}

enum GeoCodeError: Error {
    case reverseGeocode
}

enum FirebaseError: Error {
    case noDocument
    case fetch
    case failAddDocument
}
