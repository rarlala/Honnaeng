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
                 exDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
                 storageType: .fridge,
                 storageName: "냉장고1",
                 emogi: "🍎"),
        FoodData(name: "포도",
                 count: 100,
                 unit: .weight,
                 group: .fruit,
                 exDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
                 storageType: .fridge,
                 storageName: "냉장고2",
                 emogi: "🍇"),
        FoodData(name: "계란",
                 count: 8,
                 unit: .quantity,
                 group: .dairy,
                 exDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                 storageType: .fridge,
                 storageName: "냉장고1",
                 emogi: "🥚"),
        FoodData(name: "오징어",
                 count: 5,
                 unit: .quantity,
                 group: .seaFood,
                 exDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                 storageType: .frozen,
                 storageName: "냉장고2",
                 emogi: "🦑"),
    ]
    
    private var storageType: StorageType = .all
    private var sortType: ListSortType = .expirationDateimminent
    private var searchText: String = ""
    
    // TODO: 유저가 추가한 냉장고 목록으로 변경 필요
    private var refrigeraterList: [String] = ["전체 냉장고", "냉장고1", "냉장고2"]
    
    func getFoodData() -> [FoodData] {
        let filteredFood = getFilteringData()
        let sortedFood = sortedList(data: filteredFood)
        let searchFood = searchList(data: sortedFood)
        return searchText != "" ? searchFood : sortedFood
    }
    
    func addFoodData(food: FoodData) {
        foodData.append(food)
    }
    
    func updateFoodData(food: FoodData) {
        let uid = food.uuid
        let newFoodData = foodData.map { $0.uuid == uid ? food : $0 }
        foodData = newFoodData
    }
    
    func deleteFoodData(uid: UUID) {
        guard let idx = foodData.firstIndex(where: { $0.uuid == uid }) else { return }
        foodData.remove(at: idx)
    }
    
    private func getFilteringData() -> [FoodData] {
        switch self.storageType {
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
    
    func getSortTypeList() -> [String] {
        var list: [String] = []
        for type in ListSortType.allCases {
            list.append(type.rawValue)
        }
        return list
    }
    
    func changeSortType(type: ListSortType) {
        sortType = type
    }
    
    private func sortedList(data: [FoodData]) -> [FoodData] {
        switch sortType {
        case .expirationDateimminent:
            return data.sorted { $0.exDate < $1.exDate }
        case .recentlyAdded:
            return data.sorted { $0.createDate > $1.createDate }
        }
    }
    
    func changeSearchText(text: String) {
        searchText = text
    }
    
    private func searchList(data: [FoodData]) -> [FoodData] {
        return data.filter { $0.name.contains(searchText) }
    }
}
