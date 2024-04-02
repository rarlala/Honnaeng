//
//  StorageMO+CoreDataProperties.swift
//  Honnaeng
//
//  Created by Rarla on 3/26/24.
//
//

import Foundation
import CoreData


extension StorageMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StorageMO> {
        return NSFetchRequest<StorageMO>(entityName: "StorageMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var food: NSSet?

}

// MARK: Generated accessors for food
extension StorageMO {

    @objc(addFoodObject:)
    @NSManaged public func addToFood(_ value: FoodMO)

    @objc(removeFoodObject:)
    @NSManaged public func removeFromFood(_ value: FoodMO)

    @objc(addFood:)
    @NSManaged public func addToFood(_ values: NSSet)

    @objc(removeFood:)
    @NSManaged public func removeFromFood(_ values: NSSet)

}

extension StorageMO : Identifiable {

}
