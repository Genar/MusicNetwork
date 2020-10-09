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
    
    var musicItems = [MusicItem]()
    
    init() {
        
        basePathURL = "https://itunes.apple.com/"
        basePathSearchURL = basePathURL + "search?term=%@&limit=%ld"
    }
    
    func fetchMusicItems(toSearch: String, limit: Int) {

        let fullUrlString: String = String(format: self.basePathSearchURL, toSearch, limit)
        guard let urlEncodedString:String = fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        print(fullUrlString)
        guard let url = URL(string: urlEncodedString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse)
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(SearchResponse.self, from:
                        dataResponse) //Decode JSON Response Data
                    DispatchQueue.main.async { [weak self] in
                        self?.output?.musicItemsDidFetch(musicItems: model.results)
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}
