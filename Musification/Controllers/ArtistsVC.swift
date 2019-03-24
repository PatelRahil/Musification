//
//  ArtistsVC.swift
//  Musification
//
//  Created by Rahil Patel on 1/5/19.
//  Copyright © 2019 RahilPatel. All rights reserved.
//

import UIKit

class ArtistsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var toolbar: UIView?
    var toolbarWrapper: CustomToolbar?
    
    var artists:[Artist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        toolbarWrapper = CustomToolbar(navigationController: self.navigationController!)
        toolbar = toolbarWrapper!.toolbarView
        view.addSubview(toolbar!)
        toolbar?.layer.zPosition = 5
        layoutViews()
    }
    func layoutViews() {
        definesPresentationContext = true
        navigationController?.isNavigationBarHidden = false
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = "Artists"
        view.tintColor = Colors.tintColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tableView.backgroundColor = Colors.bgColor
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search artists"
        searchController.searchBar.tintColor = Colors.textColor
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        toolbarWrapper?.toolbarView.translatesAutoresizingMaskIntoConstraints = false
        toolbarWrapper?.setupConstraints(on: view)
    }
}

extension ArtistsVC: UITableViewDelegate {
    
}

extension ArtistsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let artist = artists[indexPath.row]
        cell.textLabel!.text = artist.name
        cell.textLabel?.textColor = Colors.textColor
        cell.backgroundColor = Colors.bgColor
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        artists[indexPath.row].openURL(controller: self)
    }
}

extension ArtistsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        MusicRequest.getArtistsStarting(with: text, limit: 20, success: { (artists) in
            self.artists = artists
            print(artists)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print("Getting Artists failture: \n\(error)")
        }
        print(text)
    }
}
