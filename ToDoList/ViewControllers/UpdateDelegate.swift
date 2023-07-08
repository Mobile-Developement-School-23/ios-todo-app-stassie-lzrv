//
//  UpdateDelegate.swift
//  ToDoList
//
//  Created by Настя Лазарева on 29.06.2023.
//

import Foundation

protocol UpdateDelegate: AnyObject{
    func saveCell(_ toDoItem: TodoItem, isNewItem: Bool)
    func deleteCell(_ toDoItem: TodoItem, _ reloadTable: Bool)
}
