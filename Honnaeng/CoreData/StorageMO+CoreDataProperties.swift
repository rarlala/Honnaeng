//
//  Storage+CoreDataProperties.swift
//  Honnaeng
//
//  Created by Rarla on 3/26/24.
//
//

import Foundation
import CoreData


extension Storage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Storage> {
        return NSFetchRequest<Storage>(entityName: "Storage")
    }

    @NSManaged public var name: String?
    @NSManaged public var food: NSSet?

}

// MARK: Generated accessors for food
extension Storage {

    @objc(addFoodObject:)
    @NSManaged public func addToFood(_ value: Food)

    @objc(removeFoodObject:)
    @NSManaged public func removeFromFood(_ value: Food)

    @objc(addFood:)
    @NSManaged public func addToFood(_ values: NSSet)

    @objc(removeFood:)
    @NSManaged public func removeFromFood(_ values: NSSet)

}

extension Storage : Identifiable {

}
