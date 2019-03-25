//
//  SongsVC.swift
//  Musification
//
//  Created by Rahil Patel on 3/23/19.
//  Copyright © 2019 RahilPatel. All rights reserved.
//

import Foundation
import UIKit

class SongsVC: UITableViewController {
    var songs:[Song]? = nil
    override func viewDidLoad() {
        layoutSubviews()
    }
    private func layoutSubviews() {
        view.backgroundColor = Colors.bgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = Colors.primaryColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.textColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 35)]
        
    }
}

extension SongsVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let songs = songs {
            return songs.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = Colors.bgColor
        if let songs = songs {
            let song = songs[indexPath.row]
            cell.textLabel?.text = "\"\(song.name)\" by \(song.artist)"
            cell.textLabel?.textColor = Colors.textColor
            print(Colors.textColor)
            cell.textLabel?.font = UIFont(name: cell.textLabel!.font.fontName, size: 15)
        }
        return cell
    }
}
extension SongsVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let songs = songs {
            let song = songs[indexPath.row]
            MusicRequest.getArtist(artistName: song.artist, success: { (artist) in
                artist.openURL(controller: self)
            }) { (error) in
                print(error)
            }
        }
    }
}
