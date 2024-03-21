//
//  MainViewModel.swift
//  Honnaeng
//
//  Created by Rarla on 3/18/24.
//

import Foundation

final class MainViewModel {
    private var foodData: [FoodData] = [
        FoodData(name: "사과",
                 count: 3,
                 unit: .quantity,
                 group: .fruit,
                 storageType: .fridge,
                 storageName: "냉장고1",
                 emogi: "🍎"),
        FoodData(name: "포도",
                 count: 100,
                 unit: .weight,
                 group: .fruit,
                 storageType: .fridge,
                 storageName: "냉장고2",
                 emogi: "🍇"),
        FoodData(name: "계란",
                 count: 8,
                 unit: .quantity,
                 group: .dairy,
                 storageType: .fridge,
                 storageName: "냉장고1",
                 emogi: "🥚"),
        FoodData(name: "오징어",
                 count: 5,
                 unit: .quantity,
                 group: .seaFood,
                 storageType: .frozen,
                 storageName: "냉장고2",
                 emogi: "🦑"),
    ]
    
    func getFoodData() -> [FoodData] {
        return foodData
    }
    
    func addFoodData(food: FoodData) {
        foodData.append(food)
    }
}
