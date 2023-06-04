//
//  RecommendedResultRepository.swift
//  allin
//
//  Created by 김기훈 on 2023/06/01.
//

import Foundation
import FirebaseFirestore

final class RecommendedResultRepository {
    func requestToFireStore(rounds: [Int]) async throws -> [QueryDocumentSnapshot] {
        let db = Firestore.firestore()
        
        guard let snapshot = try? await db
            .collection("RecommendedResult")
            .whereField("round", in: rounds)
            .getDocuments() else {
            throw FirebaseError.fetch
        }
        
        if snapshot.documents.isEmpty {
            throw FirebaseError.noDocument
        }
        
        let documents = Array(snapshot.documents.reversed())
        return documents
    }
    
}
