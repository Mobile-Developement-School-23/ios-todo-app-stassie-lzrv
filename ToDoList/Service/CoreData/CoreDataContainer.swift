//
//  CoreDataContainer.swift
//  ToDoList
//
//  Created by Настя Лазарева on 14.07.2023.
//

import Foundation
import CoreData

final class CoreDataContainer {
    static let shared = CoreDataContainer()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
