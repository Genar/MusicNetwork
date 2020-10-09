//
//  MusicItem.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 09/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation

public struct MusicItem: Codable {
    
    var wrapperType: String?
    var kind: String?
    var artistId: Int?
    var collectionId: Int?
    var trackId: Int?
    var artistName: String?
    var collectionName: String?
    var trackName: String?
    var collectionCensoredName: String?
    var trackCensoredName: String?
    var collectionArtistName: String?
    var artistViewUrl: String?
    var collectionViewUrl: String?
    var trackViewUrl: String?
    var previewUrl: String?
    var artworkUrl30: String?
    var artworkUrl60: String?
    var artworkUrl100: String?
    var collectionPrice: Decimal?
    var trackPrice: Decimal?
    var trackRentalPrice: Decimal?
    var collectionHdPrice: Decimal?
    var trackHdPrice: Decimal?
    var trackHdRentalPrice: Decimal?
    var releaseDate: String?
    var collectionExplicitness: String?
    var trackExplicitness: String?
    var discCount: Int?
    var discNumber: Int?
    var trackCount: Int?
    var trackNumber: Int?
    var trackTimeMillis: Int?
    var country: String?
    var primaryGenreName: String?
    var currency: String?
    var contentAdvisoryRating: String?
    var isStreamable: Bool?
    var hasITunesExtras: Bool?
    var longDescription: String?
    var collectionArtistViewUrl: String?
    var collectionArtistId: Int?
    var shortDescription: String?
    var artistType: String?
    var artistLinkUrl: String?
    var amgArtistId: Int?
    var primaryGenreId: Int?
    var feedUrl: String?
    var artworkUrl600: String?
    var genreIds: [Int]?
    var genres: [String]?
    var copyright: String?
}
