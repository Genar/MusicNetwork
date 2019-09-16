//
//  EAWhatsAppManager.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 16/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation

class EAWhatsAppManager {
    
    private static var sharedWhatsAppManager: EAWhatsAppManager = {
        
        let whatsAppManager = EAWhatsAppManager()
        return whatsAppManager
    }()
    
    // MARK: - Accessors
    
    /// The shared instance of the singleton
    /// - Returns: The shared instance of the singleton
    class func shared() -> EAWhatsAppManager {
        
        return sharedWhatsAppManager
    }
    
    /// Send the message via WhatsApp
    /// - Parameters:
    ///     - message: A string or URL to be sent
    /// - Returns: *true* if the message could be sent, *false* otherwhise
    public func sendMessage(message: String) -> Bool {
        
        let messageString: String = String(format:"whatsapp://send?text=%@", message)
        return messageString.sendMessageWithUrlString()
    }
    
}

