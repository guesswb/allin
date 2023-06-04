//
//  Date.swift
//  allin
//
//  Created by 김기훈 on 2023/06/01.
//

import Foundation

extension Date {
    
    private enum DateType {
        static let firstRound: DateComponents = DateComponents(year: 2002, month: 11, day: 30, hour: 20)
    }
    
    static func thisWeekRound() throws -> Int {
        guard let date = Calendar.current.date(from: DateType.firstRound),
              let daysSinceFirstDay = Calendar.current.dateComponents([.day], from: date, to: Date()).day else {
            throw DateError.fetchDate
        }
        return daysSinceFirstDay / 7 + 1
    }
}
