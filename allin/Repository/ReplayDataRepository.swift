//
//  ReplayDataRepository.swift
//  allin
//
//  Created by 김기훈 on 2023/06/08.
//

import Foundation
import FirebaseFirestore

final class ReplayDataRepository {
    func requestToFireStore() async throws -> [QueryDocumentSnapshot] {
        let db = Firestore.firestore()
        
        guard let snapshot = try? await db
            .collection("ReplayData")
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
