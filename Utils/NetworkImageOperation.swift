//
//  NetworkImageOperation.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 13/1/21.
//  Copyright © 2021 Genar Codina Reverter. All rights reserved.
//

import UIKit

typealias ImageOperationCompletion = ((Data?, URLResponse?, Error?) -> Void)?

final class NetworkImageOperation: AsyncOperation {
    
    var image: UIImage?
    private let url: URL
    private let completion: ImageOperationCompletion
    
    // MARK: - Used to cancel the operation
    // MARK: - it will hold the network task while it is being running
    private var task: URLSessionDataTask?

    init(url: URL, completion: ImageOperationCompletion = nil) {
        
        self.url = url
        self.completion = completion
        super.init()
    }
    
    convenience init?(string: String, completion: ImageOperationCompletion = nil) {

        guard let url = URL(string: string) else { return nil }
        self.init(url: url, completion: completion)
    }
    
    // MARK: - Use in case we do not need to cancel an operation (pag. 64)
//    override func main() {
//
//        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//
//            guard let self = self else { return }
//            defer { self.state = .finished }
//
//            if let completion = self.completion {
//                completion(data, response, error)
//                return
//            }
//
//            guard error == nil, let data = data else { return }
//            self.image = UIImage(data: data)
//        }.resume()
//    }
    
    // MARK: - Use in case we want to cancel an operation (pag. 75)
    override func main() {

        task = URLSession.shared.dataTask(with: url) { [weak self]
            data, response, error in
            guard let self = self else { return }

            defer { self.state = .finished }

            guard !self.isCancelled else { return }

            if let completion = self.completion {
                completion(data, response, error)
                return
            }

            guard error == nil, let data = data else { return }

            self.image = UIImage(data: data)
        }

        task?.resume()
    }
    
    // MARK: - Use in case we want to cancel an operation (pag. 76)
    override func cancel() {
        
        super.cancel()
        task?.cancel()
    }
}

extension NetworkImageOperation: ImageDataProvider {}
