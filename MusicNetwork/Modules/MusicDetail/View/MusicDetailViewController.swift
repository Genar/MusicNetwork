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
    
    var musicItems: [MusicItem]?
    var musicItem: MusicItem?
    var indexPath: IndexPath?
    var indexDelegate: KeepIndexDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupMedia()
    }
    
    // MARK: - Actions
    
//    @IBAction func onInstagramPressed(_ sender: UIButton) {
//        
//        var isPosted = false
//        if  let artistImage = artistImageView.image,
//            let previewUrl = musicItem?.previewUrl,
//            let backgroundImgData = UIImage(named: "User")!.jpegData(compressionQuality: 1.0),
//            let stickerImgData = artistImage.pngData(),
//            let musicItem = self.musicItem {
//            if let trackTimeMillis = musicItem.trackTimeMillis {
//                let durationInSeconds: Int = trackTimeMillis / 1000
//                let durationInMinutes: Int = durationInSeconds / 60
//                if durationInMinutes <= 4 {
//                    isPosted = EAInstagramManager.shared().shareStory(backgroundImageData: backgroundImgData, stickerImageData: stickerImgData, attributionURL: previewUrl, expirationIntervalInSeconds: 300)
//                } else if durationInMinutes > 5 && durationInMinutes <= 10 {
//                    isPosted = EAInstagramManager.shared().shareStory(backgroundTopColor: "#33FF33", backgroundBottomColor: "#FF00FF", stickerImageData: stickerImgData, attributionURL: previewUrl, expirationIntervalInSeconds: 300)
//                } else {
//                    do {
//                        if let previewURL = musicItem.previewUrl,
//                           let videoURL = NSURL(string: previewURL) {
//                            let videoData = try Data(contentsOf: videoURL as URL)
//                                isPosted = EAInstagramManager.shared().shareStory(backgroundVideoData: videoData, stickerImageData: stickerImgData, attributionURL: previewUrl, expirationIntervalInSeconds: 300)
//                        }
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//        print("Is posted in Instagram? \(isPosted)")
//    }
    
//    @IBAction func onFacebookMessengerPressed(_ sender: UIButton) {
//        
//        if let musicItem = musicItem,
//           let trackViewURL = musicItem.trackViewUrl {
//            let result = EAFacebookManager.shared().sendMessage(message: trackViewURL)
//            print("Facebook messenger: \(result)")
//        }
//    }
    
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
    
    
    // MARK: - Private
    
    private func setupMedia() {

        guard let idxPath = self.indexPath else { return }
        self.musicItem = self.musicItems?[idxPath.row]
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
    
    // MARK: - setupMedia with indexPath for cancellation (pag. 78)
//    private func setupMedia() {
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
