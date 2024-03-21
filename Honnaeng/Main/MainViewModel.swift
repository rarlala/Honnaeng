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
    
    private var storageType: StorageType = .all
    
    // TODO: 유저가 추가한 냉장고 목록으로 변경 필요
    private var refrigeraterList: [String] = ["전체 냉장고", "냉장고1", "냉장고2"]
    
    private var sortList: [String] = ["유통기한 남은 순", "최근 추가 순"]
    
    func getFoodData() -> [FoodData] {
        let food = getFilteringData(type: storageType)
        return food
    }
    
    func addFoodData(food: FoodData) {
        foodData.append(food)
    }
    
    func deleteFoodData(uid: UUID) {
        guard let idx = foodData.firstIndex(where: { $0.uuid == uid }) else { return }
        foodData.remove(at: idx)
    }
    
    func getFilteringData(type: StorageType) -> [FoodData] {
        switch type {
        case .all:
            return foodData
        case .fridge:
            return foodData.filter{ $0.storageType == .fridge }
        case .frozen:
            return foodData.filter{ $0.storageType == .frozen }
        }
    }
    
    func changeStorageType(type: StorageType) {
        self.storageType = type
    }
    
    func getRefrigeraterList() -> [String] {
        return self.refrigeraterList
    }
    
    func getSortList() -> [String] {
        return self.sortList
    }
}
