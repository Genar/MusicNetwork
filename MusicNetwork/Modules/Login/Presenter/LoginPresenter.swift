//
//  LoginPresenter.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 12/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation

class LoginPresenter: LoginPresenterInterface {
    
    // Reference to the view (weak to avoid retain cycle).
    weak var view: LoginViewInterface?
    // Reference to the interactor interface.
    var interactor: LoginInteractorInput?
    // Reference to the router.
    var router: LoginRouter?
    
    func onLoginSuccess() {
        
        router?.pushMusicItemsScreen()
    }
}

// Interactor sends command to the Presenter once task completes.
// Presenter sends command to the View
extension LoginPresenter: LoginInteractorOutput {
    
}

