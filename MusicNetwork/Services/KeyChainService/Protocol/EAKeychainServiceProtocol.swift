//
//  EAKeychainServiceProtocol.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 12/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

public protocol KeychainServiceProtocol {
    
    // MARK: - Methods
    
    func getValue(key: String) throws -> String
    func setValue(key: String, value: String) throws
    func deleteItem(key: String) throws
    func getAllValues() throws -> [String: AnyObject]
}
