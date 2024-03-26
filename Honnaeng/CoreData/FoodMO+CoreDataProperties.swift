//
//  Food+CoreDataProperties.swift
//  Honnaeng
//
//  Created by Rarla on 3/26/24.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var count: Int16
    @NSManaged public var created: Date?
    @NSManaged public var emoji: String?
    @NSManaged public var expired: Date?
    @NSManaged public var group: String?
    @NSManaged public var image: URL?
    @NSManaged public var memo: String?
    @NSManaged public var name: String?
    @NSManaged public var storageType: Int16
    @NSManaged public var unit: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var storage: Storage?

}

extension Food : Identifiable {

}
