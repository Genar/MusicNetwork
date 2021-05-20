//
//  SceneDelegate.swift
//  MusicNetworkClip
//
//  Created by Genar Codina Reverter on 12/5/21.
//  Copyright © 2021 Genar Codina Reverter. All rights reserved.
//

import UIKit
import AppClip
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    ///
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "MusicDetailViewController")
        
        if let userActivity = options.userActivities.filter({ $0.activityType == NSUserActivityTypeBrowsingWeb }).first {
            handleUserActivity(userActivity, viewController: detailViewController)
        }
        
        window?.rootViewController = detailViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    /// If the app or App Clip is suspended in memory and the user launches it, the system calls the following method
    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        
        if let userActivity = userActivity {
            handleUserActivity(userActivity)
        }
    }
    
//    func handleActivity(_ userActivity: NSUserActivity, viewController: UIViewController? = nil) {
//
//        guard let url = userActivity.webpageURL else { return }
//        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
//        guard let queryItems = components.queryItems else { return }
//        if let artist = queryItems.value(for: "artist"),
//           let previewUrl = queryItems.value(for: "previewUrl"),
//           let artworkUrl100 = queryItems.value(for: "artworkUrl100") {
//            let musicItem = setupMusicItem(artistName: artist, previewUrl: previewUrl, artworkUrl100: artworkUrl100)
//            if let viewController = viewController as? MusicDetailViewController {
//                viewController.musicItem = musicItem
//            }
//        }
//    }
    
    func handleUserActivity(_ userActivity: NSUserActivity, viewController: UIViewController? = nil) {
        
        guard let url = userActivity.webpageURL else { return }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        guard let queryItems = components.queryItems else { return }
        if let artist = queryItems.value(for: "artist"),
           let previewUrl = queryItems.value(for: "previewUrl"),
           let artworkUrl100 = queryItems.value(for: "artworkUrl100") {
            let musicItem = setupMusicItem(artistName: artist, previewUrl: previewUrl, artworkUrl100: artworkUrl100)
            
            // Attempt to verify location from the URL payload
            guard let payload = userActivity.appClipActivationPayload,
                  let lat = queryItems.value(for: "latitude"),
                  let lon = queryItems.value(for: "longitude"),
                  let latitude = Double(lat), let longitude = Double(lon) else {
                return
            }
            
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 100, identifier: "location")
            
            payload.confirmAcquired(in: region) { inRegion, error in
                
                self.handleLocationConfirmationResult(inRegion: inRegion, error: error, viewController: viewController, musicItem: musicItem)
            }
        }
    }
    
    private func handleLocationConfirmationResult(inRegion: Bool, error: Error?, viewController: UIViewController?, musicItem: MusicItem) {
        
        if let viewController = viewController as? MusicDetailViewController {
        
            if let error = error as? APActivationPayloadError {
                handleLocationError(error: error)
            } else {
                handleLocationSuccess(inRegion: inRegion, viewController: viewController, musicItem: musicItem)
            }
        }
    }
    
    private func handleLocationError(error: APActivationPayloadError) {
        
        if error.code == APActivationPayloadError.disallowed {
            print("---Not launched via QR code")
        } else if error.code == APActivationPayloadError.doesNotMatch {
            print("---Region does not match location")
        } else {
            print("---\(error.localizedDescription)")
        }

    }
    
    private func handleLocationSuccess(inRegion: Bool, viewController: MusicDetailViewController, musicItem: MusicItem) {
        
        if inRegion {
            // location confirmed – set music item
            DispatchQueue.main.async {
                viewController.musicItem = musicItem
                viewController.setupMedia()
            }
        } else {
            print("---Not in Region")
        }
    }
    
    private func setupMusicItem(artistName: String, previewUrl: String, artworkUrl100: String) -> MusicItem {
        
        let musicItem = MusicItem(wrapperType: nil, kind: nil, artistId: nil, collectionId: nil, trackId: nil, artistName: artistName, collectionName: nil, trackName: nil, collectionCensoredName: nil, trackCensoredName: nil, collectionArtistName: nil, artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: previewUrl, artworkUrl30: nil, artworkUrl60: nil, artworkUrl100: artworkUrl100, collectionPrice: nil, trackPrice: nil, trackRentalPrice: nil, collectionHdPrice: nil, trackHdPrice: nil, trackHdRentalPrice: nil, releaseDate: nil, collectionExplicitness: nil, trackExplicitness: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil, currency: nil, contentAdvisoryRating: nil, isStreamable: nil, hasITunesExtras: nil, longDescription: nil, collectionArtistViewUrl: nil, collectionArtistId: nil, shortDescription: nil, artistType: nil, artistLinkUrl: nil, amgArtistId: nil, primaryGenreId: nil, feedUrl: nil, artworkUrl600: nil, genreIds: nil, genres: nil, copyright: nil)
        
        return musicItem
    }
}
