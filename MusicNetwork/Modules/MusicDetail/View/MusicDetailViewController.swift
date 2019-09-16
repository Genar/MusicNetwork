//
//  MusicDetailViewController.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 10/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import UIKit
import WebKit

class MusicDetailViewController: UIViewController {
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var artistWebView: WKWebView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var musicItem: MusicItem?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupMedia()
    }
    
    // MARK: - Actions
    
    @IBAction func onInstagramPressed(_ sender: UIButton) {
        
        var isPosted = false
        if  let artistImage = artistImageView.image,
            let previewUrl = musicItem?.previewUrl,
            let backgroundImgData = UIImage(named: "User")!.jpegData(compressionQuality: 1.0),
            let stickerImgData = artistImage.pngData(),
            let musicItem = self.musicItem {
                let durationInSeconds: Int = musicItem.trackTimeMillis / 1000
                let durationInMinutes: Int = durationInSeconds / 60
                if durationInMinutes <= 4 {
                    isPosted = EAInstagramManager.shared().shareStory(backgroundImageData: backgroundImgData, stickerImageData: stickerImgData, attributionURL: previewUrl, expirationIntervalInSeconds: 300)
                } else if durationInMinutes > 5 && durationInMinutes <= 10 {
                    isPosted = EAInstagramManager.shared().shareStory(backgroundTopColor: "#33FF33", backgroundBottomColor: "#FF00FF", stickerImageData: stickerImgData, attributionURL: previewUrl, expirationIntervalInSeconds: 300)
                } else {
                    do {
                        if  let videoURL = NSURL(string: musicItem.previewUrl) {
                            let videoData = try Data(contentsOf: videoURL as URL)
                                isPosted = EAInstagramManager.shared().shareStory(backgroundVideoData: videoData, stickerImageData: stickerImgData, attributionURL: previewUrl, expirationIntervalInSeconds: 300)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
            }
        }
        print("Is posted in Instagram? \(isPosted)")
    }
    
    @IBAction func onFacebookMessengerPressed(_ sender: UIButton) {
        
        if let musicItem = musicItem {
            let result = EAFacebookManager.shared().sendMessage(message: musicItem.trackViewUrl)
            print("Facebook messenger: \(result)")
        }
    }
    
    @IBAction func onWhatsAppPressed(_ sender: UIButton) {
        
        if let musicItem = musicItem {
            let result = EAWhatsAppManager.shared().sendMessage(message: musicItem.trackViewUrl)
            print("WhatsApp: \(result)")
        }
    }
    
    @IBAction func onMessagePressed(_ sender: UIButton) {
        
        if let musicItem = musicItem {
            let result = EAMessageManager.shared().sendMessage(message: musicItem.trackViewUrl)
            print("Message: \(result)")
        }
    }
    
    @IBAction func onLinePressed(_ sender: UIButton) {
        
        if let musicItem = musicItem {
            let result = EALineManager.shared().sendMessage(message: musicItem.trackViewUrl)
            print("Line: \(result)")
        }
    }
    
    
    // MARK: - Private
    
    private func setupMedia() {
        
        if let musicItem = self.musicItem {
            songLabel.text = musicItem.trackName
            artistLabel.text = musicItem.artistName
            albumLabel.text = musicItem.collectionName
            dateLabel.text = musicItem.releaseDate
            genreLabel.text = musicItem.primaryGenreName
            if let urlImage:URL = URL(string:musicItem.artworkUrl100) {
                EAImageManager.shared().downloadImage(from: urlImage, imageView: self.artistImageView)
            }
            if let urlPreview: URL = URL(string: musicItem.previewUrl) {
                let request: URLRequest = URLRequest(url: urlPreview)
                artistWebView.load(request)
            }
        }
    }
}
