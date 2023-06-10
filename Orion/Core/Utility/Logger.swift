//
//  Logger.swift
//  Orion
//
//  Created by 0x41c on 2023-06-06.
//

import Foundation

/// A basic logging namespace to hold the most redundant code known to man.
struct Logger {
    /// Logs a formatted message given the message, logging level, and the calling function.
    private static func log(_ message: String, level: String, callingFunction: String) {
        print("[\(callingFunction): \(level)]: \(message)")
    }
    /// Logs a message
    static func log(_ message: String, function: String = #function) {
        log(message, level: "INFO", callingFunction: function)
    }
    /// Logs a message with a warning tag
    static func warn(_ message: String, function: String = #function) {
        log(message, level: "WARN", callingFunction: function)
    }
    /// Logs a message and then calls `fatalError` as this is supposed to be an error message :)
    static func error(_ message: String, function: String = #function) -> Never {
        log(message, level: "ERROR", callingFunction: function)
        fatalError("Uh oh, stinky...")
    }
}
