//
//  FoodData.swift
//  Honnaeng
//
//  Created by Rarla on 3/15/24.
//

import UIKit

struct FoodData: Hashable {
    var uuid = UUID()
    var createDate = Date.now
    let name: String
    var count: Int
    var unit: FoodUnit
    var group: FoodGroup
    var exDate: Date
    var storageType: StorageType
    var storageName: String
    var image: UIImage?
    var emoji: String?
    var memo: String?
    
    static func == (lhs: FoodData, rhs: FoodData) -> Bool {
        return lhs.uuid == rhs.uuid &&
                lhs.name == rhs.name &&
                lhs.count == rhs.count &&
                lhs.unit == rhs.unit &&
                lhs.group == rhs.group &&
                lhs.exDate == rhs.exDate &&
                lhs.storageType == rhs.storageType &&
                lhs.emoji == rhs.emoji
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
