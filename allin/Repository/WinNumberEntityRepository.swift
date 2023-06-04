//
//  WinNumberRepository.swift
//  allin
//
//  Created by 김기훈 on 2023/06/01.
//

import Foundation
import CoreData

final class WinNumberEntityRepository {
    func fetch(above: Int) throws -> [WinNumberEntity] {
        let context = CoreDataManager.shared.container.viewContext
        let request = WinNumberEntity.fetchRequest()
        let predicate = NSPredicate(format: "drwNo >= %d", above)
        request.predicate = predicate
        
        guard let winNumberEntities = try? context.fetch(request) else {
            throw CoreDataError.fetch
        }
        return winNumberEntities
    }
    
    func request(round: Int) async throws -> Data {
        let request = WinNumberRequest.winNumber(round: round)
        return try await NetworkManager.shared.request(with: request)
    }
    
    func save(winNumber: WinNumber) {
        let context = CoreDataManager.shared.container.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "WinNumberEntity", in: context) else {
            return
        }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        
        object.setValue(winNumber.drwNo, forKey: "drwNo")
        object.setValue(winNumber.bnusNo, forKey: "bnusNo")
        object.setValue(winNumber.drwtNo1, forKey: "drwtNo1")
        object.setValue(winNumber.drwtNo2, forKey: "drwtNo2")
        object.setValue(winNumber.drwtNo3, forKey: "drwtNo3")
        object.setValue(winNumber.drwtNo4, forKey: "drwtNo4")
        object.setValue(winNumber.drwtNo5, forKey: "drwtNo5")
        object.setValue(winNumber.drwtNo6, forKey: "drwtNo6")
        
        try? context.save()
    }
}
