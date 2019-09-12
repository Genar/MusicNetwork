//
//  EAGoogleManager.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 12/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import GoogleSignIn

class EAGoogleManager {
    
    private var userInfo: GIDGoogleUser?
    
    private static var sharedGoogleManager: EAGoogleManager = {
        
        let googleManager = EAGoogleManager()
        return googleManager
    }()
    
    // MARK: - Accessors
    
    /// The shared instance of the singleton
    /// - Returns: The shared instance of the singleton
    
    class func shared() -> EAGoogleManager {
        
        return sharedGoogleManager
    }
    
    // MARK: - Public Methods
    
    public func setUp(clientId: String) {
        
        GIDSignIn.sharedInstance().clientID = clientId
    }
    
    public func applicationOpenUrl(open url: URL) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    public func setDelegate(delegate: GIDSignInDelegate) {
        
        GIDSignIn.sharedInstance().delegate = delegate
    }
    
    public func setPresentingViewController(viewController: UIViewController) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = viewController
    }
    
    public func restorePreviousSignIn() {
        
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    public func getUserInfo() -> GIDGoogleUser? {
        
        return userInfo
    }
    
    public func setUserInfo(userInfo:GIDGoogleUser) {
        
        return self.userInfo = userInfo
    }
    
    public func signIn() {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func signOut() {
        
        GIDSignIn.sharedInstance()?.signOut()
    }
}
