//
//  NetworkFetcher.swift
//  ToDo
//
//  Created by Настя Лазарева on 7/7/23.
//

import Foundation

protocol NetworkService {
    func getAll() async throws -> [TodoItem]
    func updateAll(toDoItems: [TodoItem]) async throws  -> [TodoItem]
    func getTask(toDoItem: TodoItem) async throws
    func deleteRask(toDoItem: TodoItem) async throws
    func changeTask(toDoItem: TodoItem) async throws
    func addNewTask(toDoItem: TodoItem) async throws
}

final class Service: NetworkService {
    private var revision: Int?
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func getAll() async throws -> [TodoItem] {
        let url = try RequestProcessor.makeURL()
        let (data, _) = try await RequestProcessor.performRequest(with: url)
        let networkListToDoItems = try decoder.decode(ListToDoItems.self, from: data)
        revision = networkListToDoItems.revision
        return networkListToDoItems.list.map { TodoItem.convert(from: $0) }
    }
    
    func updateAll(toDoItems: [TodoItem]) async throws -> [TodoItem] {
        let taskURL = try RequestProcessor.makeURL()
        let taskList = ListToDoItems(list: toDoItems.map(\.networkItem))
        let taskHttpBody = try encoder.encode(taskList)
        let (data, _) = try await RequestProcessor.performRequest(with: taskURL, method: .patch, revision: revision ?? 0, httpBody: taskHttpBody)
        let taskNetwork = try decoder.decode(ListToDoItems.self, from: data)
        revision = taskNetwork.revision
        return taskNetwork.list.map{TodoItem.convert(from: $0)}
    }
    
    func getTask(toDoItem: TodoItem) async throws {
        let url = try RequestProcessor.makeURL(from: toDoItem.id)
        let (data, _) = try await RequestProcessor.performRequest(with: url)
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: data)
        revision = toDoItemNetwork.revision
    }
    
    func deleteRask(toDoItem: TodoItem) async throws {
        let url = try RequestProcessor.makeURL(from: toDoItem.id)
        let (data, _) = try await RequestProcessor.performRequest(with: url, method: .delete, revision: revision)
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: data)
        revision = toDoItemNetwork.revision
    }
    
    func changeTask(toDoItem: TodoItem) async throws {
        let url = try RequestProcessor.makeURL(from: toDoItem.id)
        let elementToDoItem = ElementToDoItem(element: toDoItem.networkItem)
        let httpBody = try encoder.encode(elementToDoItem)
        let (responseData, _) = try await RequestProcessor.performRequest(with: url, method: .put, revision: revision, httpBody: httpBody)
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: responseData)
        revision = toDoItemNetwork.revision
    }
    
    func addNewTask(toDoItem: TodoItem) async throws {
        let elementToDoItem = ElementToDoItem(element: toDoItem.networkItem)
        let url = try RequestProcessor.makeURL()
        let httpBody = try encoder.encode(elementToDoItem)
        let (responseData, _) = try await RequestProcessor.performRequest(with: url, method: .post, revision: revision, httpBody: httpBody)
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: responseData)
        revision = toDoItemNetwork.revision
    }
}
