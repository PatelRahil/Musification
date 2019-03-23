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
        var frame = toolbar!.frame
        frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
        toolbar!.frame = frame
        toolbar?.layer.zPosition = 5
        layoutViews()
    }
    
    override func viewWillLayoutSubviews() {
    }
        
    func layoutViews() {
        self.tableView.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.tableView.backgroundColor = Colors.bgColor
        self.view.tintColor = Colors.tintColor
        
    }
}
