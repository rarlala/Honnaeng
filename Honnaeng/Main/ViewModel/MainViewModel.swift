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
    private var storageName: String = "전체 냉장고"
    private var sortType: ListSortType = .expirationDateimminent
    private var groupType: String = "전체 분류"
    private var searchText: String = ""

    func changeStorageType(type: StorageType) {
        self.storageType = type
    }
    
    private func getStorageNameFilterData(data: [FoodData]) -> [FoodData] {
        return storageName == "전체 냉장고" ? data : coreData.getFoodDataList().filter{ $0.storageName == storageName }
    }
    
    func changeStorageName(name: String) {
        self.storageName = name
    }
    
    func getGroupTypeList() -> [String] {
        var list: [String] = []
        for type in FoodGroup.allCases {
            list.append(type.rawValue)
        }
        return list
    }
    
    func changeGroupType(type: String) {
        groupType = type
    }
    
    private func getSelectedGroupList(data: [FoodData]) -> [FoodData] {
        return groupType == "전체 분류" ? data : data.filter { $0.group == FoodGroup(rawValue: groupType) }
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
    
    func addStorage(name: String) throws {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if coreData.getStroageList().contains(name) {
            throw StorageError.nameAlreadyExists
        } else {
            coreData.createStorage(name: name)
        }
    }
    
    func updateStorageList(prevName: String?, newName: String, idx: Int?) {
        guard let prevName = prevName else { return }
        let newName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        coreData.updateStorage(prevName: prevName, newName: newName)
    }
    
    func deleteStorage(name: String?) {
        guard let name = name else { return }
        coreData.deleteStorage(name: name)
    }
    
    // MARK: - FoodData List
    
    func getFoodData() -> [FoodData] {
        let storageTypeFilterData = getStorageTypeFilterData()
        let storageNameFilterData = getStorageNameFilterData(data: storageTypeFilterData)
        let groupFilterData = getSelectedGroupList(data: storageNameFilterData)
        let sortedFoodData = sortedList(data: groupFilterData)
        let searchFoodData = searchList(data: sortedFoodData)
        return searchText != "" ? searchFoodData : sortedFoodData
    }
    
    private func getStorageTypeFilterData() -> [FoodData] {
        let foodData = coreData.getFoodDataList()
        switch self.storageType {
        case .all:
            return foodData
        case .fridge:
            return foodData.filter{ $0.storageType == .fridge }
        case .frozen:
            return foodData.filter{ $0.storageType == .frozen }
        case .room:
            return foodData.filter{ $0.storageType == .room }
        }
    }
    
    // MARK: - Food
    
    func addFoodData(food: FoodData) {
        coreData.createFoodData(data: food)
    }
    
    func updateFoodData(food: FoodData) {
        coreData.updateFoodData(data: food)
    }
    
    func deleteFoodData(food: FoodData) {
        coreData.deleteFoodData(data: food)
    }
}
