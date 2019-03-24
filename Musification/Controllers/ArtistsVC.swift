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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        toolbarWrapper = CustomToolbar(navigationController: self.navigationController!)
        toolbar = toolbarWrapper!.toolbarView
        view.addSubview(toolbar!)
        toolbar?.layer.zPosition = 5
        layoutViews()
    }
    override func viewDidLayoutSubviews() {
        print(tableView.frame)
        print(tableView.bounds)
        print()
    }
    func layoutViews() {
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
        navigationItem.searchController = searchController
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ArtistsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
    }
}
