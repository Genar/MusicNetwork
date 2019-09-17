//
//  EAInstagramManager.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 10/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation
import UIKit

///
/// Singleton class to post **Instagram stories**.
/// Important: Add the entry *instagram-stories*
/// in the *LSApplicationQueriesSchemes* of the *Info.plist*
///
class EAInstagramManager {
    
    private let instagramStoriesScheme: String = "instagram-stories://share"
    
    enum InstagramStoriesKeys: String {
        
        case stickerImage = "com.instagram.sharedSticker.stickerImage"
        case backgroundImage = "com.instagram.sharedSticker.backgroundImage"
        case backgroundVideo = "com.instagram.sharedSticker.backgroundVideo"
        case backgroundTopColor = "com.instagram.sharedSticker.backgroundTopColor"
        case backgroundBottomColor = "com.instagram.sharedSticker.backgroundBottomColor"
        case contentUrl = "com.instagram.sharedSticker.contentURL"
    }
    
    private static var sharedInstagramManager: EAInstagramManager = {
        
        let instagramManager = EAInstagramManager()
        
        return instagramManager
    }()
    
    // MARK: - Accessors
    class func shared() -> EAInstagramManager {
        
        return sharedInstagramManager
    }
    
    // MARK: - Public methods
    
    ///
    /// Shares a story with the specified background image
    /// and sticker image and the corresponding attribution URL
    ///
    /// - Parameters:
    ///     - backgroundImageData: The *backgroundImageData* corresponding to the bakgroound image
    ///     - stickerImageData: The *stickerImageData* corresponding to the sticker image
    ///     - attributionURL: The *attributionURL* corresponding to a deep link
    ///     - expirationIntervalInSeconds: The expiration interval in seconds.
    ///         If it is 0.0 then there is no expiration time.
    ///
    public func shareStory(backgroundImageData: Data?,
                           stickerImageData: Data?,
                           attributionURL: String?,
                           expirationIntervalInSeconds: Double = 0.0) -> Bool {
        
        if  let url = URL(string: instagramStoriesScheme) {
            let application = UIApplication.shared
            if UIApplication.shared.canOpenURL(url) {
                
                let pasteBoardItems: [[String:Any]] = [
                    [InstagramStoriesKeys.backgroundImage.rawValue : backgroundImageData as Any,
                     InstagramStoriesKeys.stickerImage.rawValue : stickerImageData as Any,
                     InstagramStoriesKeys.contentUrl.rawValue : attributionURL as Any]
                ]
                if #available(iOS 10.0, *) {
                    if expirationIntervalInSeconds == 0.0 {
                        UIPasteboard.general.setItems(pasteBoardItems)
                    } else {
                        UIPasteboard.general.setItems(pasteBoardItems, options: [.expirationDate: Date().addingTimeInterval(TimeInterval(expirationIntervalInSeconds))])
                    }
                } else {
                    UIPasteboard.general.items = pasteBoardItems
                    
                }
                application.open(url, options: [:], completionHandler: nil)
            } else {
                print("Ensure you have set \(instagramStoriesScheme) in info.plist")
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    ///
    /// Shares a story with the specified background video,
    /// whose maximum duration is 20 seconds,
    /// and sticker image and the corresponding attribution URL.
    ///
    /// - Parameters:
    ///     - backgroundVideoData: The *backgroundVideoData* corresponding to the bakgroound video
    ///     - stickerImageData: The *stickerImageData* corresponding to the sticker image
    ///     - attributionURL: The *attributionURL* corresponding to a deep link
    ///     - expirationIntervalInSeconds: The expiration interval in seconds.
    ///         If it is 0.0 then there is no expiration time.
    ///
    public func shareStory(backgroundVideoData: Data?,
                           stickerImageData: Data?,
                           attributionURL: String?,
                           expirationIntervalInSeconds: Double = 0.0) -> Bool {
        
        if  let url = URL(string: instagramStoriesScheme) {
            let application = UIApplication.shared
            if UIApplication.shared.canOpenURL(url) {
                
                let pasteBoardItems: [[String:Any]] = [
                    [InstagramStoriesKeys.backgroundVideo.rawValue : backgroundVideoData as Any,
                     InstagramStoriesKeys.stickerImage.rawValue : stickerImageData as Any,
                     InstagramStoriesKeys.contentUrl.rawValue : attributionURL as Any]
                ]
                if #available(iOS 10.0, *) {
                    if expirationIntervalInSeconds == 0.0 {
                        UIPasteboard.general.setItems(pasteBoardItems)
                    } else {
                        UIPasteboard.general.setItems(pasteBoardItems, options: [.expirationDate: Date().addingTimeInterval(TimeInterval(expirationIntervalInSeconds))])
                    }
                } else {
                    UIPasteboard.general.items = pasteBoardItems
                    
                }
                application.open(url, options: [:], completionHandler: nil)
            } else {
                print("Ensure you have set \(instagramStoriesScheme) in info.plist")
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    ///
    /// Shares a story with the specified top color and bottom color
    /// as a background color (a gradient is built if the colors are different),
    /// and sticker image and the corresponding attribution URL.
    ///
    /// - Parameters:
    ///     - backgroundTopColor: The *backgroundTopColor* corresponding top color
    ///         of the background color.
    ///     - backgroundBottomColor: The *backgroundBottomColor* corresponding bottom color
    ///         of the background color.
    ///     - stickerImageData: The *stickerImageData* corresponding to the sticker image
    ///     - attributionURL: The *attributionURL* corresponding to a deep link
    ///     - expirationIntervalInSeconds: The expiration interval in seconds.
    ///         If it is 0.0 then there is no expiration time.
    ///
    public func shareStory(backgroundTopColor: String?,
                           backgroundBottomColor: String?,
                           stickerImageData: Data?,
                           attributionURL: String?,
                           expirationIntervalInSeconds: Double = 0.0) -> Bool {
        
        if  let url = URL(string: instagramStoriesScheme) {
            let application = UIApplication.shared
            if UIApplication.shared.canOpenURL(url) {
                
                let pasteBoardItems: [[String:Any]] = [
                    [InstagramStoriesKeys.stickerImage.rawValue : stickerImageData as Any,
                     InstagramStoriesKeys.backgroundTopColor.rawValue : backgroundTopColor as Any,
                     InstagramStoriesKeys.backgroundBottomColor.rawValue : backgroundBottomColor as Any,
                     InstagramStoriesKeys.contentUrl.rawValue : attributionURL as Any]
                ]
                if #available(iOS 10.0, *) {
                    if expirationIntervalInSeconds == 0.0 {
                        UIPasteboard.general.setItems(pasteBoardItems)
                    } else {
                        UIPasteboard.general.setItems(pasteBoardItems, options: [.expirationDate: Date().addingTimeInterval(TimeInterval(expirationIntervalInSeconds))])
                    }
                } else {
                    UIPasteboard.general.items = pasteBoardItems
                    
                }
                print("This is run on the main queue, after the previous code in outer block")
                application.open(url, options: [:], completionHandler: nil)
            } else {
                print("Ensure you have set \(instagramStoriesScheme) in info.plist")
                return false
            }
            return true
        } else {
            return false
        }
    }
    
}
