//
//  LoginRouter.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 12/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation
import UIKit

class RootRouter: Router {
    
    func presentLoginScreen(in window: UIWindow) {
        
        window.makeKeyAndVisible()
        window.rootViewController = LoginRouter.assembleModule()
    }
}

// The router is responsible for the navigation between modules.
class LoginRouter: NSObject, LoginRouterInput {
    
    weak var viewController: UIViewController?
    
    static func assembleModule() -> UIViewController {
        
        if let loginViewCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            
            let interactor = LoginInteractor()
            let presenter = LoginPresenter()
            let router = LoginRouter()
            let navigation = UINavigationController(rootViewController: loginViewCtrl)
            
            loginViewCtrl.presenter = presenter
            presenter.view = loginViewCtrl
            presenter.interactor = interactor
            presenter.router = router
            interactor.output = presenter
            router.viewController = loginViewCtrl
            
            return navigation
        } else {
            return UIViewController()
        }
    }
    
    func pushMusicItemsScreen() {
        
        let musicItemModule = MusicItemsRouter.assembleModule()
        viewController?.navigationController?.pushViewController(musicItemModule, animated: true)
    }
}

