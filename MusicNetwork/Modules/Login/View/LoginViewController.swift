//
//  LoginViewController.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 12/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    var presenter: LoginPresenterInterface?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        EAGoogleManager.shared().setDelegate(delegate: self)
        EAGoogleManager.shared().setPresentingViewController(viewController: self)
        // Automatically sign in the user for Google
        EAGoogleManager.shared().restorePreviousSignIn()
        
        if let fbAccessToken = EAFacebookManager.shared().getAccessToken() {
            
            print(fbAccessToken.tokenString)
        }
    }
    
    func facebookLoginManagerDidComplete(_ result: LoginResult) {
        
        switch result {
        case .cancelled:
            print("User cancelled login.")
            
        case .failed(let error):
            print("Login failed with error \(error)")
            
        case .success(let grantedPermissions, _, _):
            print("Login succeeded with granted permissions: \(grantedPermissions)")
            presenter?.onLoginSuccess()
        }
    }
    
    @IBAction func onLoginFacebookPressed(_ sender: UIButton) {
        
        EAFacebookManager.shared().logIn(permissions: [.publicProfile],
                                         viewController: self,
                                         completion: { result in
                                            self.facebookLoginManagerDidComplete(result)
        })
    }
    
    @IBAction func onGoogleLoginPressed(_ sender: UIButton) {
        
        EAGoogleManager.shared().signIn()
    }
    
    // Mark: - Google GIDSignInDelegate protocol implementations
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        EAGoogleManager.shared().setUserInfo(userInfo: user)
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        // ...
        print("\(String(describing: userId)) \(String(describing: idToken)) \(String(describing: fullName)) \(String(describing: givenName)) \(String(describing: familyName)) \(String(describing: email))")
        presenter?.onLoginSuccess()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("user disconnects from app")
    }
    
}

extension LoginViewController: LoginViewInterface {
    
}
