//
//  Logger.swift
//  ToDoList
//
//  Created by Настя Лазарева on 30.06.2023.
//

import Foundation

import CocoaLumberjackSwift
import CocoaLumberjack

class Logger {
    
    
    init() {
        
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    func logError(_ log: String) {
        DDLogError(log)
    }
    
}
