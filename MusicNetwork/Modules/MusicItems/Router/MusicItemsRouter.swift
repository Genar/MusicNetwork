//
//  MusicItemsRouter.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 09/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation
import UIKit

// The router is responsible for the navigation between modules.
class MusicItemsRouter: NSObject, MusicItemsRouterInput {
    
    weak var viewController: UIViewController?
    
    func presentDetails(for musicItem: MusicItem) {
        // Assemble the Router for the upcoming module with music items data to present to the next View.
//        let detailViewController = MusicItemDetailRouter.assembleModule(musicItems)
//        viewController?.navigationController?.pushViewController(detailViewController, animated:true)
    }
    
    static func assembleModule() -> UIViewController {
        
        if let musicItemsViewCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicItemsViewController") as? MusicItemsViewController {
            
            let interactor = MusicItemsInteractor()
            let presenter = MusicItemsPresenter()
            let router = MusicItemsRouter()
            //let navigation = UINavigationController(rootViewController: musicItemsViewCtrl)
            
            musicItemsViewCtrl.presenter = presenter
            presenter.view = musicItemsViewCtrl
            presenter.interactor = interactor
            presenter.router = router
            interactor.output = presenter
            router.viewController = musicItemsViewCtrl
            
            //return navigation
            return musicItemsViewCtrl
        } else {
            return UIViewController()
        }
    }
    
    func pushMusicItemsScreen() {

        let musicItemsModule = MusicItemsRouter.assembleModule()
        viewController?.navigationController?.pushViewController(musicItemsModule, animated: true)
    }
}
