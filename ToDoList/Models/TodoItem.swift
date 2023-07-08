//
//  ToDoItem.swift
//  ToDoList
//
//
//

import Foundation
import FileCachePackage

enum Importance : String, Codable{
    case important
    case basic
    case low
}

public struct TodoItem :IdentifiableType,Codable, Sendable {
    public let id: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isDone: Bool
    let creationDate: Date
    var dateOfChange: Date
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
    
   func toggle()->TodoItem{
        return TodoItem(id: self.id,
                        text: self.text,
                        importance: self.importance,
                        deadline: self.deadline,
                        isDone: !self.isDone,
                        creationDate: self.creationDate,
                        dateOfChange: self.dateOfChange,
                        hexColor: self.hexColor)
        
            
    }
}


extension TodoItem : JSONConvertible{

   
    
    public static func parse(json: Any) -> TodoItem? {
        // Обязательнеы поля - text, isDone, creationDate и id
        guard let dict = json as? [String : Any],
              let text = dict["text"] as? String,
              let creationDateString = dict["creationDate"] as? String,
              let creationDate = Formatter.date.date(from: creationDateString),
              let id = dict["id"] as? String,
              let isDone = dict["isDone"] as? Bool
        else {return nil}
        
        let importanceString = dict["importance"] as? String ?? "basic"
        let importance = Importance(rawValue : importanceString) ?? .basic
        let deadlineStr = dict["deadline"] as? String
        let deadline = deadlineStr.flatMap { Formatter.date.date(from: $0) }
        let dateOfChangeString = dict["dateOfChange"] as? String
        let dateofChange = dateOfChangeString.flatMap{Formatter.date.date(from:$0)} ?? Date()
        let hexColor = dict["hexColor"] as? String
        return TodoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        isDone: isDone,
                        creationDate: creationDate,
                        dateOfChange: dateofChange,
                        hexColor: hexColor)
        
    }
    
    public var json: Any {
        // Обязательнеы поля - text, isDone, creationDate и id
        var dictionary : [String : Any] = [
            "id" : id,
            "text" : text,
            "isDone" : isDone,
            "creationDate" : Formatter.date.string(from: creationDate),
            "dateOfChange" : Formatter.date.string(from: dateOfChange)
        ]
        if importance != .basic{
            dictionary["importance"] = importance.rawValue
        }
        if let deadline = deadline{
            dictionary["deadline"] = Formatter.date.string(from: deadline)
        }
       
        if let hexColor = hexColor {
            dictionary["hexColor"] = hexColor
        }
        
        return dictionary
    }
    
}


extension TodoItem {
    
    static func parse(csv: String) -> TodoItem? {
        
        // Обязательнеы поля - text, isDone, creationDate и id
        let lines = csv.components(separatedBy: CSVseparator )
        guard lines.count == 7,
              let text = lines.first?.trimmingCharacters(in: .whitespacesAndNewlines),
              let isDone = Bool(lines[1].trimmingCharacters(in: .whitespacesAndNewlines)) ,
              let creationDate = Formatter.date.date(from:lines[2].trimmingCharacters(in: .newlines))
        else{
            return nil
        }
        
        let id = lines[3].trimmingCharacters(in: .whitespacesAndNewlines)
        if id == "" {
            return nil
        }
        
        let importance = Importance(rawValue: lines[4].trimmingCharacters(in: .whitespacesAndNewlines)) ?? .basic
        let deadline = Formatter.date.date(from: lines[5].trimmingCharacters(in: .whitespacesAndNewlines)) ?? nil
        let dateOfChange =  Formatter.date.date(from: lines[6].trimmingCharacters(in: .whitespacesAndNewlines)) ?? Date()
       
        return TodoItem(id: id ,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        isDone: isDone,
                        creationDate: creationDate,
                        dateOfChange: dateOfChange)
    }
    
    var csv : String {
        // csv всегда создается в таком порядке и в parse соответсвенно попадает тоже
        var string = "\(text);\(isDone);\(Formatter.date.string(from: creationDate));\(id);"
        if importance != .basic{
            string += "\(importance.rawValue)"
        }
        
        string += ";"
        if let deadline = deadline {
            string += "\(Formatter.date.string(from: deadline))"
        }
        
        string += ";"
       
            string += "\(Formatter.date.string(from: dateOfChange))"
        
        
        return string
    }
}

extension TodoItem{
    static func convert(from networkToDoItem: NetworkToDoItem) -> TodoItem {
        var importance = Importance.basic
        switch networkToDoItem.importance {
        case "low":
            importance = .low
        case "basic":
            importance = .basic
        case "important":
            importance = .important
        default:
            break
        }
        var deadline: Date?
        if let deadlineTimeInterval = networkToDoItem.deadline {
            deadline = Date(timeIntervalSinceReferenceDate: Double(deadlineTimeInterval))
        }
        var changed =  Date()
        if let changedTimeInterval = networkToDoItem.changedAt {
            changed = Date(timeIntervalSinceReferenceDate: Double(changedTimeInterval))
        }
        
        let created = Date(timeIntervalSinceReferenceDate: Double(networkToDoItem.createdAt))
        let toDoItem = TodoItem(id: networkToDoItem.id,text: networkToDoItem.text, importance: importance, deadline: deadline, isDone: networkToDoItem.done, creationDate: created, dateOfChange: changed)
        return toDoItem
    }
    
    var networkItem: NetworkToDoItem {
        var importance = ""
        switch self.importance {
        case .low:
            importance = "low"
        case .basic:
            importance = "basic"
        case .important:
            importance = "important"
        }
        var deadline: Int?
        if let deadlineTimeInterval = self.deadline?.timeIntervalSinceReferenceDate {
            deadline = Int(deadlineTimeInterval)
        }
        var changed = 1
        let changedTimeInterval = 1
        let created = Int(creationDate.timeIntervalSinceReferenceDate)
        let networkItem = NetworkToDoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            creationDate: created,
            modificationDate: changed,
            lastUpdatedBy: "default"
        )
        
        return networkItem
    }
    
}
