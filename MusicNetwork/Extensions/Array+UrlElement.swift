//
//  Array+UrlElement.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 12/5/21.
//  Copyright © 2021 Genar Codina Reverter. All rights reserved.
//

import Foundation

extension Array where Element == URLQueryItem {
    
    func value(for name: String) -> String? {
        
        first(where: {$0.name == name})?.value
    }
}
