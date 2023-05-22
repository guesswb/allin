//
//  WinNumber+CoreDataProperties.swift
//  allin
//
//  Created by 김기훈 on 2023/05/17.
//
//

import Foundation
import CoreData


extension WinNumber {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WinNumber> {
        return NSFetchRequest<WinNumber>(entityName: "WinNumber")
    }

    @NSManaged public var drwNo: Int16
    @NSManaged public var drwtNo1: Int16
    @NSManaged public var drwtNo2: Int16
    @NSManaged public var drwtNo3: Int16
    @NSManaged public var drwtNo4: Int16
    @NSManaged public var drwtNo5: Int16
    @NSManaged public var drwtNo6: Int16
    @NSManaged public var bnusNo: Int16

}

extension WinNumber : Identifiable {

}

extension WinNumber {
    static func fetch(round: Int) throws -> WinNumber? {
        let context = PersistenceController.shared.container.viewContext
        let request = WinNumber.fetchRequest()
        
        return try context.fetch(request).filter { $0.drwNo == round }.first
    }
    
    static func save(lottery: Lottery) throws {
        let context = PersistenceController.shared.container.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "WinNumber", in: context) else {
            throw CoreDataError.entity
        }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        
        object.setValue(lottery.drwNo, forKey: "drwNo")
        object.setValue(lottery.bnusNo, forKey: "bnusNo")
        object.setValue(lottery.drwtNo1, forKey: "drwtNo1")
        object.setValue(lottery.drwtNo2, forKey: "drwtNo2")
        object.setValue(lottery.drwtNo3, forKey: "drwtNo3")
        object.setValue(lottery.drwtNo4, forKey: "drwtNo4")
        object.setValue(lottery.drwtNo5, forKey: "drwtNo5")
        object.setValue(lottery.drwtNo6, forKey: "drwtNo6")
        
        try context.save()
    }
}
