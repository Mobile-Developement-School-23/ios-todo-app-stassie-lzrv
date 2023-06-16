//
//  ViewController.swift
//  ToDoList
//
//  Created by Настя Лазарева on 15.06.2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
        
        let item = TodoItem(text: "texttext", importance: .regular, deadline: Date(timeIntervalSinceNow: 10), isDone: false, creationDate:  Date(timeIntervalSinceNow: 0))
        let item2 = TodoItem(text: "text2", importance: .regular, deadline: Date(timeIntervalSinceNow: 10), isDone: false, creationDate:  Date(timeIntervalSinceNow: 0))
      
        let manager = FileCache()
//        print(manager.todoItemCollection.count)
//        manager.addNewTask(item)
//        manager.saveJSON(filename: "v1")
        
        print(manager.todoItemCollection.count)
        manager.loadJSON(filename: "v1")
        print(manager.todoItemCollection.count)
        
        
       // let item2 = TodoItem(id: "123",text: "texttext", importance: .important, deadline: Date(timeIntervalSinceNow: 10), isDone: false, creationDate:  Date(timeIntervalSinceNow: 0))
        //        print(item2.csv)
        //
        //    let str1 = "texttext;false;15 июня 14:11;DC3F9261-0AEB-4E89-8D90-868291C38BC0;15 июня 14:11;"
        //     let str2 = "texttext;false;15 июня 13:55;123;important;;15 июня 13:58"
        //
        //        let item_copy = TodoItem.parse(csv: str2)
        //        print(item_copy == nil)
        //        print(item_copy?.id)
        //        print(item_copy?.dateOfChange)
        //        print(item_copy?.importance)
        //        print(item.csv)
        //
        //
        //
        //
        //
        //        let val = item.json
        //
               
        //       var manager = FileCache()
        //        manager.addNewTask(item)
        //        manager.addNewTask(item2)
        //        print(manager.todoItemCollection.count)
        //        manager.save(filename: "version2")
        //        print(manager.todoItemCollection.count)
        //        manager.load(filename: "version2")
        //        print(manager.todoItemCollection.count)
        
    }
    
    
}

