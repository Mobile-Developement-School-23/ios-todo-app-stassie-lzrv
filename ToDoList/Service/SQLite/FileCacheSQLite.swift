//
//  FileCacheSQLite.swift
//  ToDoList
//
//  Created by Настя Лазарева on 14.07.2023.
//

import Foundation
import SQLite

class FileCacheSQLite: FileCacheProtocol {
    var todoItemCollection: [TodoItem] = []
    private var db: Connection
    private var table: Table
    
    private static let id = Expression<String>("id")
    private static let text = Expression<String>("text")
    private static let importance = Expression<String>("importance")
    private static let deadline = Expression<Date?>("deadline")
    private static let isDone = Expression<Bool>("isDone")
    private static let creationDate = Expression<Date>("creationDate")
    private static let dateOfChange = Expression<Date?>("dateOfChange")
    
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        var db: Connection?
        var table: Table?
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            table = Table("todoTable")
        } catch {
            print("Error connecting to existing DB")
        }
        
        guard
            let db, let table
        else {
            print("Unable to get DB")
            fatalError()
        }
        
        self.db = db
        self.table = table
        
        do{
           try db.scalar(table.exists)
            print("exist")
        } catch{
            configureDB()
        }
        
    }
    
    private func configureDB() {
        do {
            try db.run(table.create { t in
                t.column(FileCacheSQLite.id, unique: true)
                t.column(FileCacheSQLite.text)
                t.column(FileCacheSQLite.importance)
                t.column(FileCacheSQLite.deadline)
                t.column(FileCacheSQLite.isDone)
                t.column(FileCacheSQLite.creationDate)
                t.column(FileCacheSQLite.dateOfChange)
            })
        } catch {
            
        }
    }
    
    
    func save() {
        do{
            for item in todoItemCollection {
                try db.run(table.insert(FileCacheSQLite.id <- item.id,
                                        FileCacheSQLite.text <- item.text,
                                        FileCacheSQLite.importance <- item.importance.rawValue,
                                        FileCacheSQLite.deadline <- item.deadline,
                                        FileCacheSQLite.isDone <- item.isDone,
                                        FileCacheSQLite.creationDate <- item.creationDate,
                                        FileCacheSQLite.dateOfChange <- item.dateOfChange))
            }
        } catch{
            print("Failed to save db: \(error)")
        }
    }
    
    func load() {
        todoItemCollection = []
        do {
            for todo in try db.prepare(table) {
                let todoItem = TodoItem(id: todo[FileCacheSQLite.id],
                                        text: todo[FileCacheSQLite.text],
                                        importance: Importance(rawValue: todo[FileCacheSQLite.importance]) ?? .basic,
                                        deadline: todo[FileCacheSQLite.deadline],
                                        isDone: todo[FileCacheSQLite.isDone],
                                        creationDate: todo[FileCacheSQLite.creationDate],
                                        dateOfChange:  todo[FileCacheSQLite.dateOfChange] ?? Date())
                todoItemCollection.append(todoItem)
            }
        } catch {
            print("Failed to load db: \(error)")
        }
    }
    
    
    func delete(with id: String) {
        do {
            let todo = table.filter(FileCacheSQLite.id == id)
            try db.run(todo.delete())
            
        } catch {
            print("Failed to delete todo item: \(error)")
        }
    }
    
    func update(item: TodoItem) {
        do {
            let todo = table.filter(FileCacheSQLite.id == item.id)
            try db.run(todo.update(FileCacheSQLite.text <- item.text,
                                   FileCacheSQLite.importance <- item.importance.rawValue,
                                   FileCacheSQLite.deadline <- item.deadline,
                                   FileCacheSQLite.isDone <- item.isDone,
                                   FileCacheSQLite.creationDate <- item.creationDate,
                                   FileCacheSQLite.dateOfChange <- item.dateOfChange))
        } catch {
            print("Failed to update todo item: \(error)")
        }
    }
    
    func insert(item: TodoItem) {
        do {
            try db.run(table.insert(FileCacheSQLite.id <- item.id,
                                    FileCacheSQLite.text <- item.text,
                                    FileCacheSQLite.importance <- item.importance.rawValue,
                                    FileCacheSQLite.deadline <- item.deadline,
                                    FileCacheSQLite.isDone <- item.isDone,
                                    FileCacheSQLite.creationDate <- item.creationDate,
                                    FileCacheSQLite.dateOfChange <- item.dateOfChange))
            
        } catch {
            print("Failed to insert todo item: \(error)")
        }
    }
    
    
}
