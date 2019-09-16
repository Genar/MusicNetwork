//
//  SendMessage+String.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 16/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import UIKit

extension String {
    
    func sendMessageWithUrlString() -> Bool {
        
        if let url: URL = URL(string: self) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print("Result of open url : \(success)")
                })
                return true
            } else {
                print("Cannot open URL")
                return false
            }
        } else {
            return false
        }
    }
    
}
