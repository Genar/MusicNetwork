//
//  TiltShiftOperation.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 13/1/21.
//  Copyright © 2021 Genar Codina Reverter. All rights reserved.
//

import UIKit

final class TiltShiftOperation: Operation {
    
    private let inputImage: UIImage
    private static let context = CIContext()
    var outputImage: UIImage?
  
    init(image: UIImage) {
        inputImage = image
        super.init()
    }
  
    override func main() {
        
        guard let filter = TiltShiftFilter(image: inputImage, radius: 3),
              let output = filter.outputImage else {
            print("Failed to generate tilt shift image")
            return
        }
        
        let fromRect = CGRect(origin: .zero, size: inputImage.size)
        guard let cgImage = TiltShiftOperation.context.createCGImage(output, from: fromRect) else {
            print("No image generated")
            return
        }
        outputImage = UIImage(cgImage: cgImage)
    }
}


