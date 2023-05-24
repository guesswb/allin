//
//  Error.swift
//  allin
//
//  Created by 김기훈 on 2023/03/24.
//

import Foundation

enum NetworkError: Error {
    case url
    case response
}

enum JSONError: Error {
    case decode
}

enum FileError: Error {
    case bundle
}

enum CoreDataError: Error {
    case entity
    case save
    case fetch
}

enum DateError: Error {
    case round
    case fetchDate
    case unAvailableDate
}

enum GeoCodeError: Error {
    case reverseGeocode
}
