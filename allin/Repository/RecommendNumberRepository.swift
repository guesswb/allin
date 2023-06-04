//
//  RecommendNumberRepository.swift
//  allin
//
//  Created by 김기훈 on 2023/06/01.
//

import Foundation
import FirebaseFirestore

final class RecommendNumberRepository {
    func save(round: Int, numbers: [Int]) {
        let db = Firestore.firestore()
        
        db.collection("RecommendNumbers")
            .document("\(round)")
            .collection("RecommendNumber")
            .addDocument(data: [
                "numbers": numbers
            ])
    }
}
