//
//  EALineManager.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 16/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation

///
/// A singleton class to send messages or links
/// via **Line**.
/// Important: Add the entry *line*
/// in the *LSApplicationQueriesSchemes* of the *Info.plist*
///
class EALineManager {
    
    private static var sharedLinepManager: EALineManager = {
        
        let lineManager = EALineManager()
        return lineManager
    }()
    
    // MARK: - Accessors
    
    /// The shared instance of the singleton
    /// - Returns: The shared instance of the singleton
    class func shared() -> EALineManager {
        
        return sharedLinepManager
    }
    
    /// Send the message via WhatsApp
    /// - Parameters:
    ///     - message: A string or URL to be sent
    /// - Returns: *true* if the message could be sent, *false* otherwhise
    public func sendMessage(message: String) -> Bool {
        
        let messageString: String = String(format:"line://msg/text/%@", message)
        return messageString.openUrlString()
    }
    
}
