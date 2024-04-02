//
//  FoodMO+CoreDataProperties.swift
//  Honnaeng
//
//  Created by Rarla on 3/26/24.
//
//

import Foundation
import CoreData


extension FoodMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodMO> {
        return NSFetchRequest<FoodMO>(entityName: "FoodMO")
    }

    @NSManaged public var uuid: UUID
    @NSManaged public var created: Date
    @NSManaged public var name: String
    @NSManaged public var count: Int64
    @NSManaged public var unit: String
    @NSManaged public var group: String
    @NSManaged public var expired: Date
    @NSManaged public var storageType: Int16
    @NSManaged public var storage: StorageMO
    @NSManaged public var imageURL: String?
    @NSManaged public var memo: String?

}

extension FoodMO : Identifiable {

}
