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
    
    let foodEntityName = "Food"
    let storageEntityName = "Storage"
    
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
}
