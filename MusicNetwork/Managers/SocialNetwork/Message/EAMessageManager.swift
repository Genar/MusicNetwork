//
//  EAMessageManager.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 16/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation

///
/// A singleton class to send a message/link via
/// the **Message** app (included, by default, in every iOS mobile).
///
class EAMessageManager {
    
    private static var sharedMessageManager: EAMessageManager = {
        
        let messageManager = EAMessageManager()
        return messageManager
    }()
    
    // MARK: - Accessors
    
    /// The shared instance of the singleton
    /// - Returns: The shared instance of the singleton
    class func shared() -> EAMessageManager {
        
        return sharedMessageManager
    }
    
    /// Send the message via WhatsApp
    /// - Parameters:
    ///     - message: A message or URL to be sent
    /// - Returns: *true* if the message could be sent, *false* otherwhise
    public func sendMessage(message: String) -> Bool {
        
        let messageString: String = String(format:"sms:&body=%@", message)
        return messageString.openUrlString()
    }
    
}
