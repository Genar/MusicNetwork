//
//  ViewController.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 09/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import UIKit

class MusicItemsViewController: UIViewController {
    
    @IBOutlet weak var musicItemsTableView: UITableView!
    
    let kMusicItemCellIdentifier: String = "MusicItemTableViewCell"
    let kDetailMusicSegue = "DetailMusicSegue"
    var musicItems: [MusicItem] = []
    var presenter:MusicItemsPresenterInterface?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        presenter?.fetchMusicItems()
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
