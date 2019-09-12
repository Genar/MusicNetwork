//
//  MusicItemTableViewCell.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 09/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import UIKit

class MusicItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(musicItem: MusicItem) -> Void {
        
        songTitleLabel.text =  musicItem.trackName
        artistLabel.text = musicItem.artistName
        releaseDateLabel.text = musicItem.releaseDate
        genreLabel.text = musicItem.primaryGenreName
        albumLabel.text = musicItem.collectionName
        let durationInSeconds: Int = musicItem.trackTimeMillis / 1000
        let minutes: Int = durationInSeconds / 60
        let seconds: Int = durationInSeconds % 60
        let currency: String = musicItem.currency
        durationLabel.text = String(format: "%d' %d''",  minutes, seconds)
        if let formattedAmount = musicItem.trackPrice.formattedAmount {
            priceLabel.text = String(format:"%@ %@", formattedAmount, currency)
        }
        if let urlImage:URL = URL(string:musicItem.artworkUrl100) {
            EAImageManager.shared().downloadImage(from: urlImage, imageView: self.artistImageView)
        }
    }
}
