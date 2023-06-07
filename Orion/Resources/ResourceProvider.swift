//
//  ResourceProvider.swift
//  Orion
//
//  Created by 0x41c on 2023-06-06.
//

import Foundation

/// Provides bundled resources to the application
struct ResourceProvider {
    
    /// Main application resource bundle
    static let defaultBundle = Bundle.main
    
    static func retrieveResourcePath(forFileNamed fileName: String, type: String) -> String? {
        ResourceProvider.defaultBundle.path(forResource: fileName, ofType: type)
    }
    
    static func getJavaScriptResource(named fileName: String) throws -> String {
        guard let resourcePath = retrieveResourcePath(forFileNamed: fileName, type: "js") else {
            Logger.error("Unable to retrieve required javascript file \"\(fileName)\"")
        }
        
        return try String(contentsOfFile: resourcePath)
    }
    
    
}
