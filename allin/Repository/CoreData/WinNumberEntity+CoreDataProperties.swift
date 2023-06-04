//
//  WinNumber+CoreDataProperties.swift
//  allin
//
//  Created by 김기훈 on 2023/05/17.
//
//

import Foundation
import CoreData


extension WinNumberEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WinNumberEntity> {
        return NSFetchRequest<WinNumberEntity>(entityName: "WinNumberEntity")
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

extension WinNumberEntity : Identifiable {

}
