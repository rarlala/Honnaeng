//
//  StorageMO+CoreDataProperties.swift
//  Honnaeng
//
//  Created by Rarla on 3/25/24.
//
//

import Foundation
import CoreData


extension StorageMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StorageMO> {
        return NSFetchRequest<StorageMO>(entityName: "Storage")
    }

    @NSManaged public var name: String?
    @NSManaged public var food: NSSet?

}

// MARK: Generated accessors for food
extension StorageMO {

    @objc(addFoodObject:)
    @NSManaged public func addToFood(_ value: StorageMO)

    @objc(removeFoodObject:)
    @NSManaged public func removeFromFood(_ value: StorageMO)

    @objc(addFood:)
    @NSManaged public func addToFood(_ values: NSSet)

    @objc(removeFood:)
    @NSManaged public func removeFromFood(_ values: NSSet)

}

extension StorageMO : Identifiable {

}
