//
//  TiltShiftOperation.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 13/1/21.
//  Copyright © 2021 Genar Codina Reverter. All rights reserved.
//

import UIKit

final class TiltShiftOperation: Operation {
    
    private let inputImage: UIImage?
    //private let inputImage: UIImage
    private static let context = CIContext()
    var outputImage: UIImage?
    
    /// Clousure which will be run *on the main thread*
    /// when the operation completes.
    var onImageProcessed: ((UIImage?) -> Void)?
  
    // MARK: - Init simple
//    init(image: UIImage) {
//        inputImage = image
//        super.init()
//    }
    
    // MARK: - Init related to dependencies and cancellation (pag. 69)
    init(image: UIImage? = nil) {
        inputImage = image
        super.init()
    }
  
    // MARK: - main method without dependencies and control to cancel the operation
//    override func main() {
//
//        guard let filter = TiltShiftFilter(image: inputImage, radius: 3),
//              let output = filter.outputImage else {
//            print("Failed to generate tilt shift image")
//            return
//        }
//
//        let fromRect = CGRect(origin: .zero, size: inputImage.size)
//        guard let cgImage = TiltShiftOperation.context
//                .createCGImage(output, from: fromRect) else {
//            print("No image generated")
//            return
//        }
//
//        outputImage = UIImage(cgImage: cgImage)
//    }
    
    // MARK: - main method with dependencies and control to cancel the operation
    override func main() {

        let dependencyImage = dependencies
            .compactMap { ($0 as? ImageDataProvider)?.image }
            .first

        guard let inputImage = inputImage ?? dependencyImage else {
            return
        }

        guard let filter = TiltShiftFilter(image: inputImage, radius: 3),
              let output = filter.outputImage else {
            print("Failed to generate tilt shift image")
            return
        }

        guard !isCancelled else { return }

        let fromRect = CGRect(origin: .zero, size: inputImage.size)
        guard let cgImage = TiltShiftOperation.context.createCGImage(output, from: fromRect) else {
            print("No image generated")
            return
        }

        guard !isCancelled else { return }

        outputImage = UIImage(cgImage: cgImage)

        if let onImageProcessed = onImageProcessed {

            DispatchQueue.main.async { [weak self] in
                onImageProcessed(self?.outputImage)

            }
        }
    }
}

extension TiltShiftOperation: ImageDataProvider {
    
    var image: UIImage? {
        
        return outputImage
    }
}
