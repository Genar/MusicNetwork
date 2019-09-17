//
//  EAGoogleManager.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 12/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import GoogleSignIn

/// Singleton class in order to perfrom
/// the log in using the user's Google account
/// ## Important:
///     1. Add pod 'GoogleSignIn' to your Podfile
///     2. Select your targer, go to *Info* section,
///         go to *URL types* and then add a new type.
///         In order to add this type identifier is necessary
///         to register your app in Google.
///         - seealso:
///             [Google Sign In] [ref]
///             [ref]: https://developers.google.com/identity/sign-in/ios/
///     3. Your view controller must injerit from *GIDSignInDelegate*
///         and implement the method:
///         func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
///             withError error: Error!)
///
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
    
    ///
    /// Set the client Id.
    /// - Parameters:
    ///     - clientId: The *clientId* got from a *credentials.plist*
    ///         file which is given by Google once you have register your app
    ///         in Google Sign In.
    /// # See also:
    ///     This method has to be called by the method:
    ///     func application(_ application: UIApplication,
    ///         didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?) -> Bool
    ///
    public func setUp(clientId: String) {
        
        GIDSignIn.sharedInstance().clientID = clientId
    }
    
    ///
    /// This method should be called from your:
    /// func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool.
    ///
    /// - Parameters:
    ///     - url: The url to be opened
    /// - Returns: *true* if GIDSiginIn handled this *url*
    ///
    public func applicationOpenUrl(open url: URL) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    ///
    /// Sets the delegate to handle the login
    ///
    /// - Parameters:
    ///     - delegate: The *delegate*
    /// # See also:
    /// This method can be called from the viewDidLoad of your
    /// loginViewController and set it as your delegate
    ///
    public func setDelegate(delegate: GIDSignInDelegate) {
        
        GIDSignIn.sharedInstance().delegate = delegate
    }
    
    ///
    /// Sets the presenting view controller
    ///
    /// - Parameters:
    ///     - viewController: The *viewController* to be the presenting view controller.
    /// # See also:
    /// This method can be called from the viewDidLoad of your
    /// loginViewController and set it as your delegate
    ///
    public func setPresentingViewController(viewController: UIViewController) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = viewController
    }
    
    ///
    /// This method tries to log in in case a valid previous log in
    /// was performed. The main idea is to log in directly if the
    /// previous log in was successful.
    ///
    /// This method can be called from the viewDidLoad of your
    /// loginViewController and after the following #methods:
    /// # Methods:
    ///     1. public func setDelegate(delegate: GIDSignInDelegate)
    ///     2. public func setPresentingViewController(viewController: UIViewController)
    ///
    public func restorePreviousSignIn() {
        
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    ///
    /// The following method returns information about the user
    /// and its access token, expiration, etc.
    ///
    /// - Returns:
    ///     - GIDGoogleUser information
    public func getUserInfo() -> GIDGoogleUser? {
        
        return userInfo
    }
    
    ///
    /// The following method returns information about the user
    /// and its access token, expiration, etc.
    /// func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
    /// withError error: Error!)
    ///
    /// Consequently we can call inside the previous method
    /// the method setUserInfo in order to store that information
    /// in this singleton class.
    ///
    /// - Parameters:
    ///     - userInfo: The *GIDGoogleUser* information
    ///
    public func setUserInfo(userInfo:GIDGoogleUser) {
        
        return self.userInfo = userInfo
    }
    
    ///
    /// The method to be called in order to perform the sign in
    ///
    public func signIn() {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    ///
    /// The method to be called in order to perform the sign out.
    /// However, the log in process is performed via the browser
    /// which store cookies and so on; consequently, at the moment
    /// of this writing the log out has to be performed also from
    /// the browser.
    /// We have to investigate to perform the log out process from
    /// the browser and executing Swift/Javascript code.
    ///
    public func signOut() {
        
        GIDSignIn.sharedInstance()?.signOut()
    }
}
