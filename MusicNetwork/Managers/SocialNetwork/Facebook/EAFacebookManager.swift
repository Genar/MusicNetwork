//
//  EAFacebookManager.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 12/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import FacebookLogin
import FacebookCore

class EAFacebookManager {
    
    private let loginManager = LoginManager()
    
    private static var sharedFacebookManager: EAFacebookManager = {
        
        let instagramManager = EAFacebookManager()
        
        return instagramManager
    }()
    
    // MARK: - Accessors
    
    /// The shared instance of the singleton
    /// - Returns: The shared instance of the singleton
    
    class func shared() -> EAFacebookManager {
        
        return sharedFacebookManager
    }
    
    // MARK: - Public Methods
    
    /// Setup Facebook SDK. This method has to be called in the AppDelegate, inside the method:
    /// func application(_ application: UIApplication,
    ///                  didFinishLaunchingWithOptions
    ///                  launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    ///
    ///
    /// - Parameters:
    ///     - application: The UIApplication instance in the AppDelegate
    ///     - launchOptions: The launch options in the AppDelegate
    ///     - stringFormatterTarget: The *stringFormatterTarget* component used as a patter for the returned formatted string. i.e.:"MMM dd,yyyy"
    /// - Returns:
    ///     - *true*: if the url was intended for the Facebook SDK
    ///     - *false* if not.
    
    public func setUp(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /// Gets the current access token
    /// - Returns:
    ///     - AccessToken: Which contains the current access token with properties like appID,
    ///                    tokenString, expiration date, etc.
    public func getAccessToken() -> AccessToken? {
        
        return AccessToken.current
    }
    
    /// Performs a log in againts Facebook
    /// - Parameters:
    ///     - permissions: Facebook permissions. Defaults to *.publicProfile*
    ///     - viewController: The view controller involved in the process
    ///     - completion: A clousure to handle the results
    
    public func logIn(permissions: [Permission] = [.publicProfile],
                      viewController: UIViewController? = nil,
                      completion: LoginResultBlock? = nil) {
        
        loginManager.logIn(permissions: [.publicProfile],
                           viewController: viewController,
                           completion: completion)
    }
    
    /// Perfroms a log out.
    /// However, to call this method is not enough because
    /// once log in those credentials are set in the Safari
    /// so it is also necessary to remove those credentials
    /// from Safari. The solucion is to perform the logout
    /// from Facebook also in Safari (we have to investigate
    /// how to perform that task usin Swift of Javasctipy code).
    public func logOut() {
        
        loginManager.logOut()
        AccessToken.current = nil
        Profile.current = nil
        
        let cookies = HTTPCookieStorage.shared
        let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
        for cookie in facebookCookies! {
            cookies.deleteCookie(cookie )
        }
    }
    
    /// let Facebook know when a user has launched your app.
    /// This is useful if you plan to advertise your app through Facebook
    /// or if you want to use their analytics to track your app’s metrics.
    /// It has to be called on func applicationDidBecomeActive(_ application: UIApplication)
    
    public func activateAppEvents() {
        
        AppEvents.activateApp()
    }
    
    
     /// Call this method from the [UIApplicationDelegate application:openURL:options:] method
     /// of the AppDelegate for your app. It should be invoked for the proper processing of
     /// responses during interaction
     /// with the native Facebook app or Safari as part of SSO authorization flow or Facebook dialogs.
     /// - Parameters:
     ///    - application: The application as passed to [UIApplicationDelegate application:openURL:options:].
     ///    - url: The URL as passed to [UIApplicationDelegate application:openURL:options:].
     ///    - options: The options dictionary as passed to [UIApplicationDelegate application:openURL:options:].
     /// - Returns: *true* if the url was intended for the Facebook SDK, *false* if not.
    
    public func applicationOpenUrl(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let appId: String = Settings.appID
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return false
    }
    
    /// Send the message via Facebook Messenger
    /// - Parameters:
    ///     - message: A string or URL to be sent
    /// - Returns: *true* if the message could be sent, *false* otherwhise
    public func sendMessage(message: String) -> Bool {
        
        let messageString: String = String(format:"fb-messenger://share?link=%@", message)
        return messageString.sendMessageWithUrlString()
    }
    
}
