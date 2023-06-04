//
//  RecommendedResult.swift
//  allin
//
//  Created by 김기훈 on 2023/06/01.
//

import Foundation

struct RecommendedResult: Identifiable, Decodable {
    var id: Int { round }
    var round: Int = 0
    
    var firstPlace: Double = 0
    var secondPlace: Double = 0
    var thirdPlace: Double = 0
    var fourthPlace: Double = 0
    var fifthPlace: Double = 0
    var hitTwoNumber: Double = 0
    var hitOneNumber: Double = 0
    var hitZeroNumber: Double = 0
    
    var allCase: [Double] {
        return [firstPlace, secondPlace, thirdPlace, fourthPlace, fifthPlace, hitTwoNumber, hitOneNumber, hitZeroNumber]
    }
    
    var allCaseCount: Double {
        return firstPlace + secondPlace + thirdPlace + fourthPlace + fifthPlace + hitTwoNumber + hitOneNumber + hitZeroNumber
    }
}
