//
//  ReplayData.swift
//  allin
//
//  Created by 김기훈 on 2023/06/08.
//

import Foundation

struct Replay: Identifiable, Decodable {
    var id: Int { round }
    let round: Int
    let urlString: String
}
