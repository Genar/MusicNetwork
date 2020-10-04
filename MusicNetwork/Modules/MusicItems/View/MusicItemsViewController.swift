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
    
    static let kTrackTimeMillis: String = "trackTimeMillis"
    static let kPrimaryGenreName: String = "primaryGenreName"
    static let kTrackPrice: String = "trackPrice"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        presenter?.fetchMusicItems()
        self.searchBar.delegate = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == kDetailMusicSegue) {
            // pass data to next view
            if let viewController:MusicDetailViewController = segue.destination as? MusicDetailViewController,
               let indexPath = musicItemsTableView.indexPathForSelectedRow {
                    viewController.musicItem = musicItems[indexPath.row]
            }
        }
    }
    
    private func sortItems() {
        
        if (self.searchBar.selectedScopeButtonIndex == 0) {
            self.musicItems.sort { (first, second) -> Bool in
                return first.trackTimeMillis < second.trackTimeMillis
            }
        } else if (self.searchBar.selectedScopeButtonIndex == 1) {
            self.musicItems.sort { (first, second) -> Bool in
                return first.primaryGenreName < second.primaryGenreName
            }
        } else if (self.searchBar.selectedScopeButtonIndex == 2) {
//            NSSortDescriptor *valueDescriptor = [NSSortDescriptor sortDescriptorWithKey:kTrackPrice ascending:YES];
//            musicItems = [musicItems sortedArrayUsingDescriptors:@[valueDescriptor]];
        }
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
                    //NSError *error = nil;
                    //NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
            
                    //NSString* trimmedString = [regex stringByReplacingMatchesInString:inputText options:0 range:NSMakeRange(0, [inputText length]) withTemplate:@" "];
                    //NSString* stringWithPlus = [trimmedString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
                    self.view.endEditing(true)
                    //ConnectionManager.sharedInstance.searchWithString:stringWithPlus withLimit:kNumberOfSongs
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
