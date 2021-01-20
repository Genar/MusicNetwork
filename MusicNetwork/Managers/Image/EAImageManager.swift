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
        
        return imageManager
    }()
    
    // Used for cancelling the operations
    //private var operations: [IndexPath: [Operation]] = [:]
    private let threadSafeOperationsQueue = DispatchQueue(label: "org.image.download.queue", attributes: .concurrent)
    private var _operations: [IndexPath: [Operation]] = [:]
    public var operations: [IndexPath: [Operation]] {
        get {
            return threadSafeOperationsQueue.sync {
                return _operations
            }
        }
        set {
            threadSafeOperationsQueue.async(flags: .barrier) { [unowned self] in
                self._operations = newValue
                
            }
        }
    }
    
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
    
      // MARK: - Download image and perform tilt shift (pag. 56)
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
    
    // MARK: - Download image with async operation and perform a tilt shift operation with a dependency and added cancel functionality (pag. 78)
//    func downloadImage(from url: URL, imageView: UIImageView, indexPath: IndexPath) {
//
//        let networkOperation = NetworkImageOperation(url: url)
//        let tiltShiftOperation = TiltShiftOperation()
//        tiltShiftOperation.addDependency(networkOperation)
//
//        tiltShiftOperation.completionBlock = {
//            DispatchQueue.main.async {
//                imageView.image = tiltShiftOperation.image
//            }
//        }
//
//        queue.addOperation(networkOperation)
//        queue.addOperation(tiltShiftOperation)
//
//        addOperations(indexPath: indexPath,
//                      tiltOperation: tiltShiftOperation,
//                      downloadOperation: networkOperation)
//    }
    
    // MARK: - Download image with an async operation and perform a tilt shift operation with a dependency (pag. 69)
//    func downloadImage(from url: URL, imageView: UIImageView) {
//
//        let networkOperation = NetworkImageOperation(url: url)
//        let tiltShiftOperation = TiltShiftOperation()
//        tiltShiftOperation.addDependency(networkOperation)
//
////        tiltShiftOperation.completionBlock = {
////            DispatchQueue.main.async {
////                imageView.image = tiltShiftOperation.image
////            }
////        }
//
//        // Use a custom completion handle instead of
//        // the built-in *completionBlock* (pag. 71)
//        tiltShiftOperation.onImageProcessed = { image in
//                imageView.image = tiltShiftOperation.image
//        }
//
//        queue.addOperation(networkOperation)
//        queue.addOperation(tiltShiftOperation)
//    }
    
    // MARK: - Download image with async operation (pag. 66)
//    func downloadImage(from url: URL, imageView: UIImageView) {
//
//        let operation = NetworkImageOperation(url: url)
//        operation.completionBlock = {
//            DispatchQueue.main.async {
//                imageView.image = operation.image
//            }
//        }
//        queue.addOperation(operation)
//    }
    
    // MARK: - Add operation in a queue operation
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
//                self.queue.addOperation(op) // Remark: op.start() is not needed
//            }
//        }
//    }
    
    private func addOperations(indexPath: IndexPath, tiltOperation: Operation, downloadOperation: Operation) {
        
        if let existingOperations = operations[indexPath] {
            
            for operation in existingOperations {
                operation.cancel()
            }
        }

        operations[indexPath] = [tiltOperation, downloadOperation]
    }
    
    public func cancelOperations(indexPath: IndexPath) {
        
        if let operations = operations[indexPath] {
            for operation in operations {
                operation.cancel()
            }
        }
    }
}
