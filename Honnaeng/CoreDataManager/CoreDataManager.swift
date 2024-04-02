//
//  CoreDataManager.swift
//  Honnaeng
//
//  Created by Rarla on 3/25/24.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let foodEntityName = "FoodMO"
    let storageEntityName = "StorageMO"
    
    // MARK: - Storage CRUD
    func getStroageList() -> [String] {
        var list: [String] = []
        
        guard let context = context else { return list }
        
        let request = NSFetchRequest<StorageMO>(entityName: storageEntityName)
        guard let storageList = try? context.fetch(request) else { return list }
        
        list = storageList.compactMap{ $0.name }
        return list
    }
    
    func createStorage(name: String) {
        guard let context,
              let entity = NSEntityDescription.entity(forEntityName: storageEntityName, in: context),
              let data = NSManagedObject(entity: entity, insertInto: context) as? StorageMO else { return }
        
        data.name = name
        appDelegate?.saveContext()
    }
    
    func updateStorage(prevName: String, newName: String) {
        guard let context = context else { return }
        
        let request = NSFetchRequest<StorageMO>(entityName: storageEntityName)
        request.predicate = NSPredicate(format: "name = %@", prevName as CVarArg)
        
        guard let fetchData = try? context.fetch(request),
              let storage = fetchData.first else { return }
        
        storage.name = newName
        appDelegate?.saveContext()
    }
    
    func deleteStorage(name: String) {
        guard let context = context else { return }
        
        let request = NSFetchRequest<StorageMO>(entityName: storageEntityName)
        request.predicate = NSPredicate(format: "name = %@", name as CVarArg)
        
        guard let fetchData = try? context.fetch(request),
              let storage = fetchData.first else { return }
        
        context.delete(storage)
        appDelegate?.saveContext()
    }
    
    // MARK: - Food CRUD
    func getFoodDataList() -> [FoodData] {
        var list: [FoodData] = []
        
        guard let context = context else { return list }
        
        let request = NSFetchRequest<FoodMO>(entityName: foodEntityName)
        guard let foodDataList = try? context.fetch(request) else { return list }
        
        list = foodDataList.map({ data in
            FoodData(uuid: data.uuid,
                     createDate: data.created,
                     name: data.name,
                     count: Int(data.count),
                     unit: FoodUnit(rawValue: data.unit) ?? .quantity,
                     group: FoodGroup(rawValue: data.group) ?? .bakery,
                     exDate: data.expired,
                     storageType: StorageType(rawValue: Int(data.storageType)) ?? .fridge,
                     storageName: data.storage.name ?? "",
                     imageUrl: data.imageURL,
                     memo: data.memo)
        })
        return list
    }
    
    func createFoodData(data: FoodData) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: foodEntityName, in: context) else { return }
        
        let storageRequest = NSFetchRequest<StorageMO>(entityName: storageEntityName)
        storageRequest.predicate = NSPredicate(format: "name = %@", data.storageName)
        guard let storageFetchData = try? context.fetch(storageRequest) else { return }
        guard let storage = storageFetchData.first else { return }
        
        guard let newFood = NSManagedObject(entity: entity, insertInto: context) as? FoodMO else { return }
        
        newFood.uuid = data.uuid
        newFood.created = data.createDate
        newFood.name = data.name
        newFood.count = Int64(data.count)
        newFood.unit = data.unit.rawValue
        newFood.group = data.group.rawValue
        newFood.expired = data.exDate
        newFood.storageType = Int16(data.storageType.rawValue)
        newFood.imageURL = data.imageUrl
        newFood.memo = data.memo
        
        storage.addToFood(newFood)
        appDelegate?.saveContext()
    }
    
    func updateFoodData(data: FoodData) {
        guard let context = context else { return }
        
        let request = NSFetchRequest<FoodMO>(entityName: foodEntityName)
        request.predicate = NSPredicate(format: "uuid = %@", data.uuid as CVarArg)
        guard let fetchData = try? context.fetch(request) else { return }
        guard let food = fetchData.first else { return }
        
        let storageRequest = NSFetchRequest<StorageMO>(entityName: storageEntityName)
        storageRequest.predicate = NSPredicate(format: "name = %@", data.storageName)
        guard let storageFetchData = try? context.fetch(storageRequest) else { return }
        guard let storage = storageFetchData.first else { return }
        
        food.uuid = data.uuid
        food.created = data.createDate
        food.name = data.name
        food.count = Int64(data.count)
        food.unit = data.unit.rawValue
        food.group = data.group.rawValue
        food.expired = data.exDate
        food.storageType = Int16(data.storageType.rawValue)
        food.storage = storage
        food.imageURL = data.imageUrl
        food.memo = data.memo
        
        appDelegate?.saveContext()
    }
    
    func deleteFoodData(data: FoodData) {
        guard let context = context else { return }
        
        let request = NSFetchRequest<FoodMO>(entityName: foodEntityName)
        request.predicate = NSPredicate(format: "uuid = %@", data.uuid as CVarArg)
        guard let fetchData = try? context.fetch(request) else { return }
        guard let food = fetchData.first else { return }
        
        let storageRequest = NSFetchRequest<StorageMO>(entityName: storageEntityName)
        storageRequest.predicate = NSPredicate(format: "name = %@", data.storageName)
        guard let storageFetchData = try? context.fetch(storageRequest) else { return }
        guard let storage = storageFetchData.first else { return }
        
        storage.removeFromFood(food)
        context.delete(food)
        appDelegate?.saveContext()
    }
}
