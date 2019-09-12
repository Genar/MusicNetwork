//
//  EAImageManager.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 10/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation
import UIKit

class EAImageManager {
    
    private static var sharedImageManager: EAImageManager = {
        
        let imageManager = EAImageManager()
        // Configuration
        // ...
        
        return imageManager
    }()
    
    // MARK: - Properties
    
    // Initialization
    private init() {
        
    }
    
    // MARK: - Accessors
    class func shared() -> EAImageManager {
        
        return sharedImageManager
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, imageView: UIImageView) {
        
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                if let img = UIImage(data: data) {
                    imageView.image = img
                }
            }
        }
    }
}
