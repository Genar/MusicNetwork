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
            handleUserActivityWithLocationControl(userActivity, viewController: detailViewController)
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
    
    func handleUserActivity(_ userActivity: NSUserActivity, viewController: UIViewController? = nil) {

        guard let url = userActivity.webpageURL else { return }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        guard let queryItems = components.queryItems else { return }
        if let artistIdx = queryItems.value(for: "artistindex") {
            var artistIndex = Int(artistIdx) ?? 0
            if artistIndex > 1 { artistIndex = 0 }
            let musicItem = getHardCodeMusicItem()[artistIndex]
            if let viewController = viewController as? MusicDetailViewController {
                showDetailViewController(viewController: viewController, musicItem: musicItem)
            }
        }
    }
    
    func handleUserActivityWithLocationControl(_ userActivity: NSUserActivity, viewController: UIViewController? = nil) {

        guard let url = userActivity.webpageURL else { return }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        guard let queryItems = components.queryItems else { return }
        if let artistIdx = queryItems.value(for: "artistindex") {
            var artistIndex = Int(artistIdx) ?? 0
            if artistIndex > 1 { artistIndex = 0 }
            let musicItem = getHardCodeMusicItem()[artistIndex]
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
    
    // MARK: - Private
    
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
            showDetailViewController(viewController: viewController, musicItem: musicItem)
        } else {
            print("---Not in Region")
        }
    }
    
    private func showDetailViewController(viewController: MusicDetailViewController, musicItem: MusicItem) {
        
        DispatchQueue.main.async {
            viewController.musicItem = musicItem
            viewController.setupMedia()
        }
    }
    
    private func getHardCodeMusicItem() -> [MusicItem] {
        
        let firstArtist = "artist=Toto, Steve Lukather, David Paic and Steve Porcaro"
        let firstTrackName = "Hold the line"
        let firstCollectionName = "Poland live"
        let firstReleaseDate = "2010"
        let firstPreviewUrl = "https://video-ssl.itunes.apple.com/itunes-assets/Video122/v4/49/0d/36/490d3640-d47e-fa45-635c-67d8853185f3/mzvf_5380544436584296202.640x476.h264lc.U.p.m4v"
        let firstArtworkUrl100 = "https://is5-ssl.mzstatic.com/image/thumb/Video3/v4/ff/7f/87/ff7f87de-81d4-2d34-bcdb-30a0ef93439d/source/100x100bb.jpg"
        let firstTrackViewUrl = "https://itunes.apple.com/us/movie/toto-35th-anniversary-tour-live-in-poland/id853512405?uo=4"
        let firstMusicItem = setupMusicItem(artistName: firstArtist,
                                            trackName: firstTrackName,
                                            collectionName: firstCollectionName,
                                            releaseDate: firstReleaseDate,
                                            primaryGenreName: "Rock",
                                            previewUrl: firstPreviewUrl,
                                            artworkUrl100: firstArtworkUrl100,
                                            trackViewUrl: firstTrackViewUrl)
        
        let secondArtist = "Michael Jackson"
        let secondTrackName = "Remember the Time"
        let secondCollectionName = "Michael Jackson's Vision (Music Video Collection)"
        let secondReleaseDate = "Jan 14, 1992"
        let secondPreviewUrl = "https://video-ssl.itunes.apple.com/itunes-assets/Video124/v4/47/c9/75/47c975a0-00c9-8f12-f303-955a02e6aec9/mzvf_14580757575164842771.640x360.h264lc.U.p.m4v"
        let secondArtworkUrl100 = "https://is1-ssl.mzstatic.com/image/thumb/Video118/v4/48/c0/87/48c08774-665b-e907-b1fe-401d4b4de63b/source/100x100bb.jpg"
        let secondTrackViewUrl = "https://music.apple.com/us/music-video/remember-the-time-michael-jacksons-vision/405410829?uo=4"
        let secondMusicItem = setupMusicItem(artistName: secondArtist,
                                             trackName: secondTrackName,
                                             collectionName: secondCollectionName,
                                             releaseDate: secondReleaseDate,
                                             primaryGenreName: "Pop",
                                             previewUrl: secondPreviewUrl,
                                             artworkUrl100: secondArtworkUrl100,
                                             trackViewUrl: secondTrackViewUrl)
        
        let musicItems: [MusicItem] = [firstMusicItem, secondMusicItem]
        
        return musicItems
    }
    
    private func setupMusicItem(artistName: String,
                                trackName: String,
                                collectionName: String,
                                releaseDate: String,
                                primaryGenreName: String,
                                previewUrl: String,
                                artworkUrl100: String,
                                trackViewUrl: String) -> MusicItem {
        
        let musicItem = MusicItem(wrapperType: nil, kind: nil, artistId: nil, collectionId: nil, trackId: nil, artistName: artistName, collectionName: collectionName, trackName: trackName, collectionCensoredName: nil, trackCensoredName: nil, collectionArtistName: nil, artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: trackViewUrl, previewUrl: previewUrl, artworkUrl30: nil, artworkUrl60: nil, artworkUrl100: artworkUrl100, collectionPrice: nil, trackPrice: nil, trackRentalPrice: nil, collectionHdPrice: nil, trackHdPrice: nil, trackHdRentalPrice: nil, releaseDate: releaseDate, collectionExplicitness: nil, trackExplicitness: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: primaryGenreName, currency: nil, contentAdvisoryRating: nil, isStreamable: nil, hasITunesExtras: nil, longDescription: nil, collectionArtistViewUrl: nil, collectionArtistId: nil, shortDescription: nil, artistType: nil, artistLinkUrl: nil, amgArtistId: nil, primaryGenreId: nil, feedUrl: nil, artworkUrl600: nil, genreIds: nil, genres: nil, copyright: nil)
        
        return musicItem
    }
}
