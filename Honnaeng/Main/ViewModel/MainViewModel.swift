//
//  MainViewModel.swift
//  Honnaeng
//
//  Created by Rarla on 3/18/24.
//

import Foundation

final class MainViewModel {
    
    private let coreData = CoreDataManager.shared
    private var storageType: StorageType = .all
    private var storageName: String = "전체"
    private var sortType: ListSortType = .expirationDateimminent
    private var searchText: String = ""
    
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
    
    func getFoodData() -> [FoodData] {
        let storageTypeFilterData = getStorageTypeFilterData()
        let storageNameFilterData = getStorageNameFilterData(data: storageTypeFilterData)
        let sortedFoodData = sortedList(data: storageNameFilterData)
        let searchFoodData = searchList(data: sortedFoodData)
        return searchText != "" ? searchFoodData : sortedFoodData
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
    
    private func getStorageTypeFilterData() -> [FoodData] {
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
    
    private func getStorageNameFilterData(data: [FoodData]) -> [FoodData] {
        return storageName == "전체" ? data : foodData.filter{ $0.storageName == storageName }
    }
    
    func changeStorageName(name: String) {
        self.storageName = name
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
    
    // MARK: - Storage List
    
    func getStorageList() -> [String] {
        return coreData.getStroageList()
    }
    
    func addStorageList(name: String) {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if coreData.getStroageList().contains(name) {
            // TODO : Error, 이미 존재하는 냉장고 이름입니다.
            print("Error, 이미 존재하는 냉장고 이름입니다.")
        } else {
            coreData.createStorage(name: name)
        }
    }
    
    func updateStorageList(prevName: String?, newName: String, idx: Int?) {
        guard let prevName = prevName else { return }
        let newName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        coreData.updateStorage(prevName: prevName, newName: newName)
    }
}
