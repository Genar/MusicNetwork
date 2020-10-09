//
//  MusicItemsPresenter.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 09/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation

class MusicItemsPresenter: MusicItemsPresenterInterface {

    // Reference to the view (weak to avoid retain cycle).
    weak var view: MusicItemsViewInterface?
    // Reference to the interactor interface.
    var interactor: MusicItemsInteractorInput?
    // Reference to the router.
    var router: MusicItemsRouter?
    // Array to hold music items feeds
    var musicItems = [MusicItem]()
    
    func fetchMusicItems(toSearch: String, limit: Int) {
        
        interactor?.fetchMusicItems(toSearch: toSearch, limit: limit)
    }
    
    func showDetails(for musicItem:MusicItem) {
        
        router?.presentDetails(for: musicItem)
    }
}

// Interactor sends command to the Presenter once task completes.
// Presenter sends command to the View
extension MusicItemsPresenter: MusicItemsInteractorOutput {
    
    func musicItemsDidFetch(musicItems: [MusicItem]) {
        
        // Format dates
        let musicItemsFormatted = formatDates(musicItems: musicItems)
        view?.showMusicItems(for: musicItemsFormatted)
    }
    
    // We will format some fields like releaseDate
    // and we will continue using the same struct
    // 'MusicItem' to hold that information formatted.
    //
    // In other cases, it will be necessary to transform
    // the structure given by the interactor (and which
    // holds the data) into another structure more suitable
    // to be used by the presenter.
    private func formatDates(musicItems: [MusicItem]) -> [MusicItem] {
        
        var musicItemsFormatted = [MusicItem]()
        for item in musicItems {
            var itemFormatted = item
            if let releaseDate = item.releaseDate {
                itemFormatted.releaseDate = Date.getFormattedDate(stringDate: releaseDate,
                                                                  stringFormatterOrigin: "yyyy-MM-dd'T'HH:mm:ssZ",
                                                              stringFormatterTarget: "MMM dd, yyyy")
                musicItemsFormatted.append(itemFormatted)
            }
        }
        
        return musicItemsFormatted
    }
}
