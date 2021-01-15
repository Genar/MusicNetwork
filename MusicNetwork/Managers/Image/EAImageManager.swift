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
    
    private let queue = OperationQueue()
    
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
    
//    func downloadImage(from url: URL, imageView: UIImageView) {
//
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            DispatchQueue.main.async() {
//                if let img = UIImage(data: data) {
//                    imageView.image = img
//                }
//            }
//        }
//    }
    
//    func downloadImage(from url: URL, imageView: UIImageView) {
//
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            if let img = UIImage(data: data) {
//                let op = TiltShiftOperation(image: img)
//                op.start()
//                DispatchQueue.main.async() {
//                    imageView.image = op.outputImage
//                }
//            }
//        }
//    }
    
    func downloadImage(from url: URL, imageView: UIImageView) {
        
        let operation = NetworkImageOperation(url: url)
        operation.completionBlock = {
            DispatchQueue.main.async {
                imageView.image = operation.image
            }
        }
        queue.addOperation(operation)
    }
    
//    func downloadImage(from url: URL, imageView: UIImageView) {
//
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            if let img = UIImage(data: data) {
//                let op = TiltShiftOperation(image: img)
//                op.completionBlock = {
//                    DispatchQueue.main.async() {
//                        imageView.image = op.outputImage
//                    }
//                }
//                self.queue.addOperation(op)
//            }
//        }
//    }
}
