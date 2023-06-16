//
//  ToDoListTests.swift
//  ToDoListTests
//
//  
//

import XCTest
@testable import ToDoList

final class ToDoListTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
    }
    
    func testJsonParseAllFields() throws {
        let json : [String:Any] =
        [
            "id" : "testId",
            "text" : "testText",
            "importance" : "important",
            "deadline" : "15 июня 23:59",
            "isDone" : false,
            "creationDate" : "15 июня 23:00",
            "dateOfChange" : "15 июня 23:30"
        ]
        
        guard let result = TodoItem.parse(json: json) else{
            XCTFail("Ошибка преобразования json в объект")
            return
        }
        
        XCTAssertEqual(result.id, "testId", "преобразовние id")
        XCTAssertEqual(result.text, "testText", "преобразовние текста задачи")
        XCTAssertEqual(result.importance, Importance.important, "преобразовние важности задачи")
        XCTAssertEqual(result.deadline, Formatter.date.date(from: "15 июня 23:59"), "преобразовние даты дедлайна задачи")
        XCTAssertEqual(result.creationDate, Formatter.date.date(from: "15 июня 23:00"), "преобразовние даты создания задачи")
        XCTAssertEqual(result.dateOfChange, Formatter.date.date(from: "15 июня 23:30"), "преобразовние даты создания задачи")
        XCTAssertEqual(result.isDone, false, "преобразовние статуса готовности задачи")
    }
    
    func testJsonParseWithoutRequiredFields() throws {
        let json : [String:Any] =
        [
            "importance" : "important",
            "deadline" : "15 июня 23:59",
            "isDone" : false,
            "creationDate" : "15 июня 23:00",
            "dateOfChange" : "15 июня 23:30"
        ]
        
        guard TodoItem.parse(json: json) != nil else{
            XCTAssert(true,"Некорректный json невозможно преобразовать в объект")
            return
        }
        
        XCTFail("Некорректный json невозможно преобразовать в объект")
    }
    
    
    func testJsonParseWithoutImportance() throws {
        let json : [String:Any] =
        [
            "id" : "testId",
            "text" : "testText",
            "deadline" : "15 июня 23:59",
            "isDone" : false,
            "creationDate" : "15 июня 23:00",
            "dateOfChange" : "15 июня 23:30"
        ]
        
        guard let result = TodoItem.parse(json: json) else{
            XCTFail("Ошибка преобразования json в объект")
            return
        }
        
        XCTAssertEqual(result.id, "testId", "преобразовние id")
        XCTAssertEqual(result.text, "testText", "преобразовние текста задачи")
        XCTAssertEqual(result.importance, Importance.regular, "преобразовние важности задачи")
        XCTAssertEqual(result.deadline, Formatter.date.date(from: "15 июня 23:59"), "преобразовние даты дедлайна задачи")
        XCTAssertEqual(result.creationDate, Formatter.date.date(from: "15 июня 23:00"), "преобразовние даты создания задачи")
        XCTAssertEqual(result.dateOfChange, Formatter.date.date(from: "15 июня 23:30"), "преобразовние даты создания задачи")
        XCTAssertEqual(result.isDone, false, "преобразовние статуса готовности задачи")
    }
    
    func testJsonParseWithoutOptionalFields() throws {
        let json : [String:Any] =
        [
            "id" : "testId",
            "text" : "testText",
            "importance" : "important",
            "isDone" : false,
            "creationDate" : "15 июня 23:00",
        ]
        
        guard let result = TodoItem.parse(json: json) else{
            XCTFail("Ошибка преобразования json в объект")
            return
        }
        
        XCTAssertEqual(result.id, "testId", "преобразовние id")
        XCTAssertEqual(result.text, "testText", "преобразовние текста задачи")
        XCTAssertEqual(result.importance, Importance.important, "преобразовние важности задачи")
        XCTAssertEqual(result.deadline, nil, "преобразовние даты дедлайна задачи")
        XCTAssertEqual(result.creationDate, Formatter.date.date(from: "15 июня 23:00"), "преобразовние даты создания задачи")
        XCTAssertEqual(result.dateOfChange, nil, "преобразовние даты создания задачи")
        XCTAssertEqual(result.isDone, false, "преобразовние статуса готовности задачи")
    }
    
    func testGettingJsonWithAllFields(){
        let todoItem = TodoItem(id: "testId",text: "testText", importance: .important, deadline: Formatter.date.date(from: "15 июня 23:59"), isDone: false, creationDate: Formatter.date.date(from: "15 июня 23:00")!, dateOfChange: Formatter.date.date(from: "15 июня 23:30"))
        
        let result : [String : Any] = todoItem.json as! [String: Any]
        
        XCTAssertEqual(result["id"] as! String, "testId", "преобразовние id")
        XCTAssertEqual(result["text"] as! String, "testText", "преобразовние текста задачи")
        XCTAssertEqual(result["importance"] as! String, "important", "преобразовние важности задачи")
        XCTAssertEqual(result["deadline"] as! String, "15 июня 23:59", "преобразовние даты дедлайна задачи")
        XCTAssertEqual(result["creationDate"] as! String, "15 июня 23:00", "преобразовние даты создания задачи")
        XCTAssertEqual(result["dateOfChange"] as! String, "15 июня 23:30", "преобразовние даты создания задачи")
        XCTAssertEqual(result["isDone"] as! Bool, false, "преобразовние статуса готовности задачи")
    }
    
    func testGettingJsonWithoutImportance(){
        let todoItem = TodoItem(id: "testId",text: "testText", importance: .regular, deadline: Formatter.date.date(from: "15 июня 23:59"), isDone: false, creationDate: Formatter.date.date(from: "15 июня 23:00")!, dateOfChange: Formatter.date.date(from: "15 июня 23:30"))
        
        let result : [String : Any] = todoItem.json as! [String: Any]
        
        XCTAssertEqual(result["id"] as! String, "testId", "преобразовние id")
        XCTAssertEqual(result["text"] as! String, "testText", "преобразовние текста задачи")
        XCTAssertEqual(result["importance"] as? String, nil, "преобразовние важности задачи")
        XCTAssertEqual(result["deadline"] as! String, "15 июня 23:59", "преобразовние даты дедлайна задачи")
        XCTAssertEqual(result["creationDate"] as! String, "15 июня 23:00", "преобразовние даты создания задачи")
        XCTAssertEqual(result["dateOfChange"] as! String, "15 июня 23:30", "преобразовние даты создания задачи")
        XCTAssertEqual(result["isDone"] as! Bool, false, "преобразовние статуса готовности задачи")
    }
    
    func testGettingJsonWithoutOptionalFields(){
        let todoItem = TodoItem(id: "testId",text: "testText", importance: .important, isDone: false, creationDate: Formatter.date.date(from: "15 июня 23:00")!)
        
        let result : [String : Any] = todoItem.json as! [String: Any]
        
        XCTAssertEqual(result["id"] as! String, "testId", "преобразовние id")
        XCTAssertEqual(result["text"] as! String, "testText", "преобразовние текста задачи")
        XCTAssertEqual(result["importance"] as! String, "important", "преобразовние важности задачи")
        XCTAssertEqual(result["deadline"] as? String, nil, "преобразовние даты дедлайна задачи")
        XCTAssertEqual(result["creationDate"] as! String, "15 июня 23:00", "преобразовние даты создания задачи")
        XCTAssertEqual(result["dateOfChange"] as? String, nil, "преобразовние даты создания задачи")
        XCTAssertEqual(result["isDone"] as! Bool, false, "преобразовние статуса готовности задачи")
    }
    
    func testCSVParsingWithAllFields(){
        let todoItem = TodoItem(id: "testId",text: "testText", importance: .important, deadline: Formatter.date.date(from: "15 июня 23:59"), isDone: false, creationDate: Formatter.date.date(from: "15 июня 23:00")!, dateOfChange: Formatter.date.date(from: "15 июня 23:30"))
        
        let inputCSV = "testText;false;15 июня 23:00;testId;important;15 июня 23:59;15 июня 23:30"
        
        guard let result = TodoItem.parse(csv: inputCSV) else{
            XCTFail("Ошибка преобразования csv в объект")
            return
        }
        
        XCTAssertEqual(result.id, todoItem.id, "преобразовние id")
        XCTAssertEqual(result.text, todoItem.text, "преобразовние текста задачи")
        XCTAssertEqual(result.importance, todoItem.importance, "преобразовние важности задачи")
        XCTAssertEqual(result.deadline, todoItem.deadline, "преобразовние даты дедлайна задачи")
        XCTAssertEqual(result.creationDate, todoItem.creationDate, "преобразовние даты создания задачи")
        XCTAssertEqual(result.dateOfChange, todoItem.dateOfChange, "преобразовние даты создания задачи")
        XCTAssertEqual(result.isDone, todoItem.isDone, "преобразовние статуса готовности задачи")
    }
    
    
    func testCSVParsingWithoutImportance(){
        let todoItem = TodoItem(id: "testId",text: "testText", importance: .regular, deadline: Formatter.date.date(from: "15 июня 23:59"), isDone: false, creationDate: Formatter.date.date(from: "15 июня 23:00")!, dateOfChange: Formatter.date.date(from: "15 июня 23:30"))
        
        let inputCSV = "testText;false;15 июня 23:00;testId;;15 июня 23:59;15 июня 23:30"
        
        guard let result = TodoItem.parse(csv: inputCSV) else{
            XCTFail("Ошибка преобразования csv в объект")
            return
        }
        
        XCTAssertEqual(result.id, todoItem.id, "преобразовние id")
        XCTAssertEqual(result.text, todoItem.text, "преобразовние текста задачи")
        XCTAssertEqual(result.importance, todoItem.importance, "преобразовние важности задачи")
        XCTAssertEqual(result.deadline, todoItem.deadline, "преобразовние даты дедлайна задачи")
        XCTAssertEqual(result.creationDate, todoItem.creationDate, "преобразовние даты создания задачи")
        XCTAssertEqual(result.dateOfChange, todoItem.dateOfChange, "преобразовние даты создания задачи")
        XCTAssertEqual(result.isDone, todoItem.isDone, "преобразовние статуса готовности задачи")
    }
    
    func testCSVParsingWithoutOptionalFields(){
        let todoItem = TodoItem(id: "testId",text: "testText", importance: .regular, isDone: false, creationDate: Formatter.date.date(from: "15 июня 23:00")!)
        
        let inputCSV = "testText;false;15 июня 23:00;testId;;;"
        
        guard let result = TodoItem.parse(csv: inputCSV) else{
            XCTFail("Ошибка преобразования csv в объект")
            return
        }
        
        XCTAssertEqual(result.id, todoItem.id, "преобразовние id")
        XCTAssertEqual(result.text, todoItem.text, "преобразовние текста задачи")
        XCTAssertEqual(result.importance, todoItem.importance, "преобразовние важности задачи")
        XCTAssertEqual(result.deadline, todoItem.deadline, "преобразовние даты дедлайна задачи")
        XCTAssertEqual(result.creationDate, todoItem.creationDate, "преобразовние даты создания задачи")
        XCTAssertEqual(result.dateOfChange, todoItem.dateOfChange, "преобразовние даты создания задачи")
        XCTAssertEqual(result.isDone, todoItem.isDone, "преобразовние статуса готовности задачи")
    }
    
    func testGettingCSVWithAllFields(){
        let todoItem = TodoItem(id: "testId",text: "testText", importance: .important, deadline: Formatter.date.date(from: "15 июня 23:59"), isDone: false, creationDate: Formatter.date.date(from: "15 июня 23:00")!, dateOfChange: Formatter.date.date(from: "15 июня 23:30"))
        
        let result = todoItem.csv
        
        let expected = "testText;false;15 июня 23:00;testId;important;15 июня 23:59;15 июня 23:30"
        
        XCTAssertEqual(result, expected, "преобразование объекта в csv")
    }
    
    func testGettingCSVWithoutImportance(){
        let todoItem = TodoItem(id: "testId",text: "testText", importance: .regular, deadline: Formatter.date.date(from: "15 июня 23:59"), isDone: false, creationDate: Formatter.date.date(from: "15 июня 23:00")!, dateOfChange: Formatter.date.date(from: "15 июня 23:30"))
        
        let result = todoItem.csv
        
        let expected = "testText;false;15 июня 23:00;testId;;15 июня 23:59;15 июня 23:30"
        
        XCTAssertEqual(result, expected, "преобразование объекта в csv c обычной сложностью")
    }
    
    func testGettingCSVWithoutOprionalFields(){
        let todoItem = TodoItem(id: "testId",text: "testText", importance: .regular, isDone: false, creationDate: Formatter.date.date(from: "15 июня 23:00")!)
        
        let result = todoItem.csv
        
        let expected = "testText;false;15 июня 23:00;testId;;;"
        
        XCTAssertEqual(result, expected, "преобразование объекта в csv без опциональных полей")
    }
    
}
