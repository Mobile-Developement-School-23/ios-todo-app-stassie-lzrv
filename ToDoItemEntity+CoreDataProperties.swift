//
//  ToDoItemEntity+CoreDataProperties.swift
//  ToDoList
//
//  Created by Настя Лазарева on 14.07.2023.
//
//

import Foundation
import CoreData


extension ToDoItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItemEntity> {
        return NSFetchRequest<ToDoItemEntity>(entityName: "ToDoItemEntity")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var dateOfChange: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var id: String?
    @NSManaged public var importance: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var text: String?

}

extension ToDoItemEntity : Identifiable {

}
