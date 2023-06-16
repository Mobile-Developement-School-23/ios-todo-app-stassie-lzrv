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

struct TodoItem : Codable {
    
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let dateOfChange: Date?
    
    init(id: String = UUID().uuidString, text: String, importance: Importance, deadline: Date? = nil, isDone: Bool, creationDate: Date, dateOfChange: Date? = nil) {
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
        guard let dict = json as? [String : Any],
              let text = dict["text"] as? String,
              let creationDateString = dict["creationDate"] as? String,
              let creationDate = Formatter.date.date(from: creationDateString)
        else {return nil}
        let id = dict["id"] as? String ?? UUID().uuidString
        let importanceString = dict["importance"] as? String ?? "regular"
        let importance = Importance(rawValue : importanceString) ?? .regular
        let deadlineStr = dict["deadline"] as? String
        let deadline = deadlineStr.flatMap { Formatter.date.date(from: $0) }
        let IsDone = dict["isDone"] as? Bool ?? false
        let dateOfChangeString = dict["dateOfChange"] as? String
        let dateofChange = dateOfChangeString.flatMap{Formatter.date.date(from:$0)}
        
        return TodoItem(id: id, text: text, importance: importance, deadline: deadline, isDone: IsDone, creationDate: creationDate, dateOfChange: dateofChange)
        
    }
    
    var json: Any {
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
        let lines = csv.components(separatedBy: ";")
        guard lines.count >= 3,
              let text = lines.first?.trimmingCharacters(in: .whitespacesAndNewlines),
              let isDone = Bool(lines[1].trimmingCharacters(in: .whitespacesAndNewlines)) ,
              let creationDate = Formatter.date.date(from:lines[2].trimmingCharacters(in: .newlines))
        else{
            return nil
            
        }
        
        // ПЕРЕДЕЛАТЬ!!!!
        
        let id = lines.count >= 4 ? lines[3].trimmingCharacters(in: .whitespacesAndNewlines) : UUID().uuidString
        var importance = Importance.regular
        var deadline: Date? = nil
        var dateOfChange: Date? = nil
        if lines.count >= 5{
            let str = lines[4].trimmingCharacters(in: .whitespacesAndNewlines)
            if(str == "important" || str == "unimportant"){
                importance = Importance(rawValue: str) ?? .regular
                deadline = lines.count >= 6 ? Formatter.date.date(from: lines[5].trimmingCharacters(in: .whitespacesAndNewlines)) : nil
                dateOfChange = lines.count >= 7 ? Formatter.date.date(from: lines[6].trimmingCharacters(in: .whitespacesAndNewlines)) : nil
                
            } else {
                deadline = Formatter.date.date(from: str)
                dateOfChange = lines.count >= 6 ? Formatter.date.date(from: lines[5].trimmingCharacters(in: .whitespacesAndNewlines)): nil
            }
        }
        
        return TodoItem(id: id ,text: text, importance: importance, deadline: deadline, isDone: isDone, creationDate: creationDate, dateOfChange: dateOfChange)
    }
    
    var csv : String {
        var string = "\(text);\(isDone);\(Formatter.date.string(from: creationDate));\(id)"
        if importance != .regular{
            string += ";\(importance.rawValue)"
        }else{
            string += ";"
        }
        
        if let deadline = deadline {
            string += ";\(Formatter.date.string(from: deadline))"
        }else{
            string += ";"
        }
        
        if let dateOfChange = dateOfChange{
            string += ";\(Formatter.date.string(from: dateOfChange))"
        }else{
            string += ";"
        }
        return string
    }
}

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
