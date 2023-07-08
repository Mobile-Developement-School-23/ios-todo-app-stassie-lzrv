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
    
    private var retryCount = 0
    private let maxRetryCount = 5
    private var fetchRequestStart = false
    
    private let minDelay: Double = 2
    private let maxDelay: Double = 120
    private let factor: Double = 1.5
    private let jitter: Double = 0.05
    private var currentDelay: Double = 2
    
    
    private var revision: Int?
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func getAll() async throws -> [TodoItem] {
        let url = try RequestProcessor.makeURL()
        let (data, response) = try await RequestProcessor.performRequest(with: url)
        if response.isSuccessful{
            self.retryCount = 0
            self.resetDelay()
        }else{
            self.retryCount += 1
            self.retryRequest {}
        }
        let networkListToDoItems = try decoder.decode(ListToDoItems.self, from: data)
        revision = networkListToDoItems.revision
        return networkListToDoItems.list.map { TodoItem.convert(from: $0) }
    }
    
    func updateAll(toDoItems: [TodoItem]) async throws -> [TodoItem] {
        let taskURL = try RequestProcessor.makeURL()
        let taskList = ListToDoItems(list: toDoItems.map(\.networkItem))
        let taskHttpBody = try encoder.encode(taskList)
        let (data, response) = try await RequestProcessor.performRequest(with: taskURL, method: .patch, revision: revision ?? 0, httpBody: taskHttpBody)
        if response.isSuccessful{
            self.retryCount = 0
            self.resetDelay()
        }else{
            self.retryCount += 1
            self.retryRequest {}
        }
        let taskNetwork = try decoder.decode(ListToDoItems.self, from: data)
        revision = taskNetwork.revision
        return taskNetwork.list.map{TodoItem.convert(from: $0)}
    }
    
    func getTask(toDoItem: TodoItem) async throws {
        let url = try RequestProcessor.makeURL(from: toDoItem.id)
        let (data, response) = try await RequestProcessor.performRequest(with: url)
        if response.isSuccessful{
            self.retryCount = 0
            self.resetDelay()
        }else{
            self.retryCount += 1
            self.retryRequest {}
        }
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: data)
        revision = toDoItemNetwork.revision
    }
    
    func deleteRask(toDoItem: TodoItem) async throws {
        let url = try RequestProcessor.makeURL(from: toDoItem.id)
        let (data, response) = try await RequestProcessor.performRequest(with: url, method: .delete, revision: revision)
        if response.isSuccessful{
            self.retryCount = 0
            self.resetDelay()
        }else{
            self.retryCount += 1
            self.retryRequest {}
        }
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: data)
        revision = toDoItemNetwork.revision
    }
    
    func changeTask(toDoItem: TodoItem) async throws {
        let url = try RequestProcessor.makeURL(from: toDoItem.id)
        let elementToDoItem = ElementToDoItem(element: toDoItem.networkItem)
        let httpBody = try encoder.encode(elementToDoItem)
        let (responseData, response) = try await RequestProcessor.performRequest(with: url, method: .put, revision: revision, httpBody: httpBody)
        if response.isSuccessful{
            self.retryCount = 0
            self.resetDelay()
        }else{
            self.retryCount += 1
            self.retryRequest {}
        }
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: responseData)
        revision = toDoItemNetwork.revision
    }
    
    func addNewTask(toDoItem: TodoItem) async throws {
        let elementToDoItem = ElementToDoItem(element: toDoItem.networkItem)
        let url = try RequestProcessor.makeURL()
        let httpBody = try encoder.encode(elementToDoItem)
        let (responseData, response) = try await RequestProcessor.performRequest(with: url, method: .post, revision: revision, httpBody: httpBody)
        if response.isSuccessful{
            self.retryCount = 0
            self.resetDelay()
        }else{
            self.retryCount += 1
            self.retryRequest {}
        }
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: responseData)
        revision = toDoItemNetwork.revision
    }
}

extension Service {
    
    private func retryRequest(_ request: @escaping @Sendable () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + currentDelay) {
            request()
        }
        updateDelay()
    }
    
    private func updateDelay() {
        let retryValue = Double.random(in: 0...(jitter * currentDelay))
        currentDelay = min(maxDelay, factor * currentDelay) + retryValue
    }
    
    private func resetDelay() {
        currentDelay = minDelay
    }
}
