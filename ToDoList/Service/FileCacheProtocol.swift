//
//  FileCacheProtocol.swift
//  ToDoList
//
//  Created by Настя Лазарева on 14.07.2023.
//

import Foundation


protocol FileCacheProtocol{
    var todoItemCollection: [TodoItem] {get set}
    func save()
    func load()
    func delete(with id: String)
    func update(item: TodoItem)
    func insert(item: TodoItem)
}
