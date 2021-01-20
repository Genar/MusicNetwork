//
//  MusicItemsInteractor.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 09/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation

// The interactor responsible for implementing the business logic of the module.
class MusicItemsInteractor: MusicItemsInteractorInput {

    // Reference to the presenter's output interface
    weak var output: MusicItemsInteractorOutput?
    
    let basePathURL: String
    let basePathSearchURL: String
    
    private var dataResponse: Data?
    
    var musicItems = [MusicItem]()
    
    init() {
        
        basePathURL = "https://itunes.apple.com/"
        basePathSearchURL = basePathURL + "search?term=%@&limit=%ld"
    }
    
    func fetchMusicItems(toSearch: String, limit: Int) {

        let fullUrlString: String = String(format: self.basePathSearchURL, toSearch, limit)
        guard let urlEncodedString: String = fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlEncodedString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            self.parseAndNotifyResponse(dataResponse: dataResponse)
        }
        task.resume()
    }
    
    func fetchMusicItemsGlobalQueue(toSearch: String, limit: Int) {
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            
            guard let self = self else { return }
            
            let fullUrlString: String = String(format: self.basePathSearchURL, toSearch, limit)
            guard let urlEncodedString:String = fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            guard let url = URL(string: urlEncodedString) else { return }
            guard let dataResponse = try? Data(contentsOf: url) else { return }
            self.parseAndNotifyResponse(dataResponse: dataResponse)
        }
    }
    
    func fetchMusicItemsDispatchWorkItem(toSearch: String, limit: Int) {
        
        let workItem = DispatchWorkItem { [weak self] in
            
            guard let self = self else { return }
            
            let fullUrlString: String = String(format: self.basePathSearchURL, toSearch, limit)
            guard let urlEncodedString:String = fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            guard let url = URL(string: urlEncodedString) else { return }
            guard let dataResponse = try? Data(contentsOf: url) else { return }
            self.parseAndNotifyResponse(dataResponse: dataResponse)
        }
        
        DispatchQueue.global(qos: .utility).async(execute: workItem)
    }
    
    func fetchMusicItemsDispatchWorkItemWithDependency(toSearch: String, limit: Int) {
        
        let queue = DispatchQueue.global(qos: .utility)
        
        let workItem = DispatchWorkItem { [weak self] in
            
            guard let self = self else { return }
            let fullUrlString: String = String(format: self.basePathSearchURL, toSearch, limit)
            guard let urlEncodedString:String = fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            guard let url = URL(string: urlEncodedString) else { return }
            guard let dataResponse = try? Data(contentsOf: url) else { return }
            self.dataResponse = dataResponse
        }
        
        let workItemUpdateUI = DispatchWorkItem { [weak self] in
            
            guard let self = self else { return }
            guard let dataResponse = self.dataResponse else { return }
            self.parseAndNotifyResponse(dataResponse: dataResponse)
        }
        
        workItem.notify(queue: queue, execute: workItemUpdateUI)
        
        queue.async(execute: workItem)
        
    }
    
    func cancelOperations(indexPath: IndexPath) {
        
        EAImageManager.shared().cancelOperations(indexPath: indexPath)
    }
    
    private func parseAndNotifyResponse(dataResponse: Data) {
        
        do {
            _ = try JSONSerialization.jsonObject(with: dataResponse, options: [])
            let decoder = JSONDecoder()
            let model = try decoder.decode(SearchResponse.self, from: dataResponse)
            self.output?.musicItemsDidFetch(musicItems: model.results)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error.localizedDescription)
        }
    }
}
