//
//  LoginProtocols.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 12/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation
import UIKit

// Protocol that defines the view input methods.
protocol LoginViewInterface : class {
    
}

protocol LoginPresenterInterface : class {
    
    var router: LoginRouter? {get set}
    var interactor: LoginInteractorInput? {get set}
    var view: LoginViewInterface? {get set}
    
    func onLoginSuccess()
}

// Protocol that defines the interactor's use case.
protocol LoginInteractorInput : class {
    
    var output: LoginInteractorOutput? {get set}
}

// Protocol that defines the commands sent from the interactor to the presenter.
protocol LoginInteractorOutput : class {
    
}

protocol LoginRouterInput : class {
    
    // Protocol that defines the possible routes from the Login module.
    var viewController : UIViewController? {get set}
    static func assembleModule() -> UIViewController
}

protocol Router: class {

    func presentLoginScreen(in window:UIWindow)
}
