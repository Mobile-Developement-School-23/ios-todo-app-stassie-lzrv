//
//  TodoItem.swift
//  TodoList_SUI
//
//  Created by Настя Лазарева on 19.07.2023.
//

import Foundation

enum Importance : String, Codable{
    case important
    case basic
    case low
}

public class TodoItem:  ObservableObject, Identifiable,  Equatable {
    public static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isDone: Bool
    let creationDate: Date
    var dateOfChange: Date?
    var hexColor:String?
    
    static let CSVseparator = ";"
    
    init(id: String = UUID().uuidString,
         text: String,
         importance: Importance,
         deadline: Date? = nil,
         isDone: Bool = false,
         creationDate: Date = Date(),
         dateOfChange: Date = Date(),
         hexColor:String? = nil)
    {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.dateOfChange = dateOfChange
        self.hexColor = hexColor
    }
    
}
