//
//  ToDoItem.swift
//  ToDoList
//
//
//

import Foundation

enum Importance : String, Codable{
    case important
    case regular
    case unimportant
}

struct TodoItem  {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let dateOfChange: Date?
    
    static let CSVseparator = ";"
    
    init(id: String = UUID().uuidString,
         text: String,
         importance: Importance,
         deadline: Date? = nil,
         isDone: Bool = false,
         creationDate: Date = Date(),
         dateOfChange: Date? = nil)
    {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.dateOfChange = dateOfChange
    }
}


extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        // Обязательнеы поля - text, isDone, creationDate и id
        guard let dict = json as? [String : Any],
              let text = dict["text"] as? String,
              let creationDateString = dict["creationDate"] as? String,
              let creationDate = Formatter.date.date(from: creationDateString),
              let id = dict["id"] as? String,
              let IsDone = dict["isDone"] as? Bool
        else {return nil}
        
        let importanceString = dict["importance"] as? String ?? "regular"
        let importance = Importance(rawValue : importanceString) ?? .regular
        let deadlineStr = dict["deadline"] as? String
        let deadline = deadlineStr.flatMap { Formatter.date.date(from: $0) }
        let dateOfChangeString = dict["dateOfChange"] as? String
        let dateofChange = dateOfChangeString.flatMap{Formatter.date.date(from:$0)}
        
        return TodoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        isDone: IsDone,
                        creationDate: creationDate,
                        dateOfChange: dateofChange)
        
    }
    
    var json: Any {
        // Обязательнеы поля - text, isDone, creationDate и id
        var dictionary : [String : Any] = [
            "id" : id,
            "text" : text,
            "isDone" : isDone,
            "creationDate" : Formatter.date.string(from: creationDate)
        ]
        if importance != .regular{
            dictionary["importance"] = importance.rawValue
        }
        if let deadline = deadline{
            dictionary["deadline"] = Formatter.date.string(from: deadline)
        }
        if let dateOfChange = dateOfChange{
            dictionary["dateOfChange"] = Formatter.date.string(from: dateOfChange)
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
        
        let importance = Importance(rawValue: lines[4].trimmingCharacters(in: .whitespacesAndNewlines)) ?? .regular
        let deadline = Formatter.date.date(from: lines[5].trimmingCharacters(in: .whitespacesAndNewlines)) ?? nil
        let dateOfChange =  Formatter.date.date(from: lines[6].trimmingCharacters(in: .whitespacesAndNewlines)) ?? nil
        
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
        if importance != .regular{
            string += "\(importance.rawValue)"
        }
        
        string += ";"
        if let deadline = deadline {
            string += "\(Formatter.date.string(from: deadline))"
        }
        
        string += ";"
        if let dateOfChange = dateOfChange{
            string += "\(Formatter.date.string(from: dateOfChange))"
        }
        
        return string
    }
}

// Расширение для конвертации даты в строку и обратно
extension Formatter {
    static var date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        formatter.dateFormat = "d MMMM HH:mm"
        return formatter
    }()
}
