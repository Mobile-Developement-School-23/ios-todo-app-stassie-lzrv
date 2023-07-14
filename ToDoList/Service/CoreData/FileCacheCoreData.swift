//
//  FileCacheCoreData.swift
//  ToDoList
//
//  Created by Настя Лазарева on 14.07.2023.
//

import Foundation
import CoreData

class FileCacheCoreData : FileCacheProtocol{
    private let context: NSManagedObjectContext
    var todoItemCollection: [TodoItem] = []
    
    init() {
        context = CoreDataContainer.shared.persistentContainer.viewContext
    }
    
    public func addNewTask(_ newTask : TodoItem){
        
        if let ind = todoItemCollection.firstIndex(where: {$0.id == newTask.id}){
            todoItemCollection[ind] = newTask
        } else {
            todoItemCollection.append(newTask)
        }
    }
    
    func save() {
        do {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ToDoItemEntity.fetchRequest()
            let deleteAllRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            try context.execute(deleteAllRequest)
            for item in todoItemCollection {
                if let itemEntity = item.coreDataEntity {
                    context.insert(itemEntity)
                }
            }
            try context.save()
            
        } catch {
            print("Failed to save todo items: \(error)")
            
        }
    }
    
    func load() {
        todoItemCollection = []
        let request: NSFetchRequest<ToDoItemEntity> = ToDoItemEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            for entity in entities {
                if let item = TodoItem.parse(entity: entity) {
                    todoItemCollection.append(item)
                }
            }
        } catch {
            print("Failed to fetch todo items: \(error)")
        }
    }
    
    func delete(with id: String) {
        let fetchRequest: NSFetchRequest<ToDoItemEntity> = ToDoItemEntity.fetchRequest()
        do {
            if let targetItem = try context.fetch(fetchRequest).first(where: { $0.id == id }) {
                context.delete(targetItem)
                try context.save()
                todoItemCollection.removeAll(where: { $0.id == id })
            }
        } catch {
            print("Failed to delete todo item: \(error)")
        }
    }
    
    func update(item: TodoItem){
        guard let ind = todoItemCollection.firstIndex(where: { $0.id == item.id }) else { return }
        let fetchRequest: NSFetchRequest<ToDoItemEntity> = ToDoItemEntity.fetchRequest()
        do {
            guard let oldItem = try context.fetch(fetchRequest).first(where: { $0.id == item.id })else { return}
            guard let newItem = item.coreDataEntity else { return}
            oldItem.text = newItem.text
            oldItem.creationDate = newItem.creationDate
            oldItem.importance = newItem.importance
            oldItem.deadline = newItem.deadline
            oldItem.dateOfChange = newItem.dateOfChange
            oldItem.isDone = newItem.isDone
            try context.save()
            todoItemCollection[ind] = item
        } catch {
            print("Failed to update todo item: \(error)")
        }
    }
    
    func insert(item: TodoItem)  {
        guard let itemEntity = item.coreDataEntity else { return }
        context.insert(itemEntity)
        do {
            try context.save()
            todoItemCollection.append(item)
        } catch {
            print("Failed to insert todo item: \(error)")
        }
    }
    
}
