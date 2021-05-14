//
//  MusicDetailViewController.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 10/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import UIKit
import WebKit
import UserNotifications
import StoreKit

class MusicDetailViewController: UIViewController, SKOverlayDelegate {
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var artistWebView: WKWebView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var remindMeButton: UIButton!
    
    var musicItems: [MusicItem]?
    var musicItem: MusicItem?
    var indexPath: IndexPath?
    
    #if !APPCLIP
    var indexDelegate: KeepIndexDelegate?
    #endif
    
    let userNotificationCenter = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        #if !APPCLIP
        setupMedia()
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        #if APPCLIP
        self.nextButton.isHidden = true
        self.previousButton.isHidden = true
        #else
        self.remindMeButton.isHidden = true
        #endif
    }
    
    // MARK: - Actions
    
    @IBAction func onWhatsAppPressed(_ sender: UIButton) {
        
        if let musicItem = musicItem,
           let trackViewURL = musicItem.trackViewUrl {
            let result = EAWhatsAppManager.shared().sendMessage(message: trackViewURL)
            print("WhatsApp: \(result)")
        }
    }
    
    @IBAction func onMessagePressed(_ sender: UIButton) {
        
        if let musicItem = musicItem,
           let trackViewURL = musicItem.trackViewUrl {
            let result = EAMessageManager.shared().sendMessage(message: trackViewURL)
            print("Message: \(result)")
        }
    }
    
    @IBAction func onLinePressed(_ sender: UIButton) {
        
        if let musicItem = musicItem,
           let trackViewURL = musicItem.trackViewUrl {
            let result = EALineManager.shared().sendMessage(message: trackViewURL)
            print("Line: \(result)")
        }
    }
    
    #if !APPCLIP
    @IBAction func onPreviousPressed(_ sender: UIButton) {
        
        if let indexPath = self.indexPath {
            if (indexPath.row > 0) {
                self.indexPath = IndexPath(item: indexPath.row - 1, section: 0)
                self.setupMedia()
                indexDelegate?.updateIndex(index: self.indexPath)
            } else if (indexPath.row == 0) {
                if let numMusicItems = self.musicItems?.count {
                    self.indexPath = IndexPath(item: numMusicItems - 1, section: 0)
                    self.setupMedia()
                    indexDelegate?.updateIndex(index: self.indexPath)
                }
            }
        }
    }
    
    @IBAction func onNextPressed(_ sender: UIButton) {
        
        if let indexPath = self.indexPath,
           let musicItems = self.musicItems {
            if (indexPath.row < musicItems.count - 1) {
                self.indexPath = IndexPath(row: indexPath.row + 1, section: 0)
                indexDelegate?.updateIndex(index: self.indexPath)
                self.setupMedia()
            } else if (indexPath.row == musicItems.count - 1) {
                self.indexPath = IndexPath(row: 0, section: 0)
                indexDelegate?.updateIndex(index: self.indexPath)
                self.setupMedia()
            }
        }
    }
    
    @IBAction func onRemindMePressed(_ sender: UIButton) {
    }
    #else
    @IBAction func onPreviousPressed(_ sender: UIButton) {
    }
    @IBAction func onNextPressed(_ sender: UIButton) {
    }
    @IBAction func onRemindMePressed(_ sender: UIButton) {
        
        userNotificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .ephemeral {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.sendNotification()
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.showGetFullAppBanner()
        }
        
    }
    #endif
    
    
    // MARK: - Private
    
    public func setupMedia() {

        #if !APPCLIP
        guard let idxPath = self.indexPath else { return }
        self.musicItem = self.musicItems?[idxPath.row]
        #endif
        if let musicItem = self.musicItem {
            songLabel.text = musicItem.trackName
            artistLabel.text = musicItem.artistName
            albumLabel.text = musicItem.collectionName
            dateLabel.text = musicItem.releaseDate
            genreLabel.text = musicItem.primaryGenreName
            if let artworkUrl100 = musicItem.artworkUrl100,
               let urlImage:URL = URL(string: artworkUrl100) {
                EAImageManager.shared().downloadImage(from: urlImage, imageView: self.artistImageView)
            }
            if let previewUrl = musicItem.previewUrl,
               let urlPreview: URL = URL(string: previewUrl) {
                let request: URLRequest = URLRequest(url: urlPreview)
                artistWebView.load(request)
            }
        }
    }
    
    private func sendNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Music Network"
        content.subtitle = "Remember to download the full app"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        userNotificationCenter.add(request)
    }
    
    private func showGetFullAppBanner() {
        
        guard let scene = view.window?.windowScene else { return }
        let config = SKOverlay.AppClipConfiguration(position: .bottom)
        let overlay = SKOverlay(configuration: config)
        overlay.delegate = self
        overlay.present(in: scene)
    }
    
    // MARK: - setupMedia with indexPath for cancellation (pag. 78)
//    public func setupMedia() {
//
//        guard let idxPath = self.indexPath else { return }
//        self.musicItem = self.musicItems?[idxPath.row]
//        if let musicItem = self.musicItem {
//            songLabel.text = musicItem.trackName
//            artistLabel.text = musicItem.artistName
//            albumLabel.text = musicItem.collectionName
//            dateLabel.text = musicItem.releaseDate
//            genreLabel.text = musicItem.primaryGenreName
//            if let artworkUrl100 = musicItem.artworkUrl100,
//               let urlImage:URL = URL(string: artworkUrl100) {
//                EAImageManager.shared().downloadImage(from: urlImage,
//                                                      imageView: self.artistImageView,
//                                                      indexPath: idxPath)
//            }
//            if let previewUrl = musicItem.previewUrl,
//               let urlPreview: URL = URL(string: previewUrl) {
//                let request: URLRequest = URLRequest(url: urlPreview)
//                artistWebView.load(request)
//            }
//        }
//    }
}
