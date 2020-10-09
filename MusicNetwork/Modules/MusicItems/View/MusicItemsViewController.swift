//
//  ViewController.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 09/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import UIKit

class MusicItemsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var musicItemsTableView: UITableView!
    
    let kMusicItemCellIdentifier: String = "MusicItemTableViewCell"
    let kDetailMusicSegue = "DetailMusicSegue"
    var musicItems: [MusicItem] = []
    var presenter:MusicItemsPresenterInterface?
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupSearchBar()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == kDetailMusicSegue) {
            // pass data to next view
            if let viewController: MusicDetailViewController = segue.destination as? MusicDetailViewController,
               let indexPath = musicItemsTableView.indexPathForSelectedRow {
                viewController.indexPath = indexPath
                viewController.musicItems = musicItems
            }
        }
    }
    
    private func sortItems() {
        
        if (self.searchBar.selectedScopeButtonIndex == 0) {
            self.musicItems.sort { (first, second) -> Bool in
                if let firstTrackTimeMillis = first.trackTimeMillis,
                   let secondTrackTimeMillis = second.trackTimeMillis {
                    return firstTrackTimeMillis < secondTrackTimeMillis
                } else {
                    return false
                }
            }
        } else if (self.searchBar.selectedScopeButtonIndex == 1) {
            self.musicItems.sort { (first, second) -> Bool in
                if let firstGenreName = first.primaryGenreName,
                   let secondGenreName = second.primaryGenreName {
                    return firstGenreName < secondGenreName
                } else {
                    return false
                }
            }
        }
    }
    
    private func setupSearchBar() {
        
        let durationText: String = "music_items_duration_title".localized()
        let genreText: String = "music_items_genre_title".localized()
        let searchPlaceholderText = "music_items_search_placeholder".localized()
        
        self.searchBar.scopeButtonTitles = [durationText, genreText]
        self.searchBar.placeholder = searchPlaceholderText
        
        self.searchBar.delegate = self
    }
}

// Mark - Table View Data source
extension MusicItemsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if musicItems.count > 0 {
            return musicItems.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: kMusicItemCellIdentifier, for: indexPath) as? MusicItemTableViewCell {
            let musicItem: MusicItem = musicItems[indexPath.row]
            cell.render(musicItem: musicItem)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// Mark - Table View delegate
extension MusicItemsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: kDetailMusicSegue, sender: self)
    }
}

extension MusicItemsViewController: MusicItemsViewInterface {
    
    func showMusicItems(for musicItems: [MusicItem]) {
        
        self.musicItems = musicItems
        self.sortItems()
        musicItemsTableView.reloadData()
    }
}

extension MusicItemsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            self.view.endEditing(true)
            self.musicItems = []
            self.musicItemsTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if var inputText: String = searchBar.text {
            let isTextEmpty: Bool = inputText.count == 0
            let isTextAllWhiteSpaces: Bool = inputText.trimmingCharacters(in: CharacterSet.whitespaces).count == 0
            
                if ( !isTextEmpty || !isTextAllWhiteSpaces) {
                    inputText = inputText.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
                    self.view.endEditing(true)
                    
                    presenter?.fetchMusicItems(toSearch: inputText, limit: 200)
                }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        self.sortItems()
        musicItemsTableView.reloadData()
    }
}
