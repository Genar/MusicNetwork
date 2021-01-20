//
//  MusicItemsProtocols.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 09/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation
import UIKit

// Protocol that defines the view input methods.
protocol MusicItemsViewInterface : class {
    
    func showMusicItems(for musicItems: [MusicItem])
}

protocol MusicItemsPresenterInterface : class {
    
    var router: MusicItemsRouter? { get set }
    var interactor: MusicItemsInteractorInput? { get set }
    var view: MusicItemsViewInterface? { get set }
    
    func fetchMusicItems(toSearch: String, limit: Int)
    func showDetails(for musicItems: MusicItem)
    
    func cancelOperations(indexPath: IndexPath)
}

// Protocol that defines the interactor's use case.
protocol MusicItemsInteractorInput: class {
    
    var output: MusicItemsInteractorOutput? { get set }
    
    func fetchMusicItems(toSearch: String, limit: Int)
    func fetchMusicItemsGlobalQueue(toSearch: String, limit: Int)
    func fetchMusicItemsDispatchWorkItem(toSearch: String, limit: Int)
    func fetchMusicItemsDispatchWorkItemWithDependency(toSearch: String, limit: Int)
    
    func cancelOperations(indexPath: IndexPath)
}

// Protocol that defines the commands sent from the interactor to the presenter.
protocol MusicItemsInteractorOutput : class {
    
    func musicItemsDidFetch(musicItems:[MusicItem])
}

protocol MusicItemsRouterInput : class {
    
    // Protocol that defines the possible routes from the MusicItems module.
    var viewController : UIViewController? { get set }
    func presentDetails(for: MusicItem)
    func pushMusicItemsScreen()
    static func assembleModule() -> UIViewController
}

