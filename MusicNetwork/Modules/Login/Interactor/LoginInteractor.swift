//
//  LoginInteractor.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 12/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation

// The interactor responsible for implementing the business logic of the module.
class LoginInteractor: LoginInteractorInput {
    
    // Reference to the presenter's output interface
    weak var output: LoginInteractorOutput?
    
    init() {
    }
}
