//
//  SearchResponse.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 09/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation

public struct SearchResponse: Codable {
    
    let resultCount: Int
    let results: [MusicItem]
}
