//
//  FileCache.swift
//  ToDoList
//
//
//

import Foundation

// Пока что ошибки печатаются в консоль, но дальше со следующими дз будут пробрасоваться ошибки
class FileCache{
    private(set) var todoItemCollection : [TodoItem] = []
    
    func addNewTask(_ new_task : TodoItem){
        if let i = todoItemCollection.firstIndex(where: {$0.id == new_task.id}){
            todoItemCollection[i] = new_task
        } else {
            todoItemCollection.append(new_task)
        }
    }
    
    func deleteTask(with id: String){
        todoItemCollection.removeAll(where: {$0.id == id})
    }
    
    func saveJSON(filename: String){
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(filename)
        let jsonItems = todoItemCollection.map({$0.json})
        let data = try! JSONSerialization.data(withJSONObject: jsonItems, options: .prettyPrinted)
        do {
            try data.write(to: url)
        } catch {
            print("Error saving data: ",error)
        }
    }
    
    func loadJSON(filename: String){
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: url.path),
           let data = try? Data(contentsOf: url),
           let jsonItems = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
            todoItemCollection = jsonItems.compactMap({TodoItem.parse(json: $0)})
        } else {
            print("File not found")
        }
    }
    
    func saveCSV(filename: String) {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(filename)
        var csvString = ""
        for item in todoItemCollection {
            csvString.append("\(item.csv)\n")
        }
        do {
            try csvString.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving data: ",error)
        }
    }
    
    func loadCSV(filename: String){
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(filename)
        do {
            let csvData = try String(contentsOf: url, encoding: .utf8)
            let lines = csvData.components(separatedBy: .newlines)
            for line in lines{
                guard let task = TodoItem.parse(csv: line) else {continue}
                addNewTask(task)
            }
        } catch {
            print("Error loading data: ", error)
        }
    }
}






