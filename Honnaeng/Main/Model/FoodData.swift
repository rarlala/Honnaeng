//
//  FoodData.swift
//  Honnaeng
//
//  Created by Rarla on 3/15/24.
//

import UIKit

struct FoodData: Hashable {
    let uuid = UUID()
    let name: String
    var count: Int
    var unit: FoodUnit
    var group: FoodGroup
    var storageType: StorageType
    var storageName: String?
    var image: UIImage?
    var emogi: String?
    var dueDate: Date?
    var memo: String?
    
    static func == (lhs: FoodData, rhs: FoodData) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
