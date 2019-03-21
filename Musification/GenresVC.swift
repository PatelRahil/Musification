//
//  ViewController.swift
//  Musification
//
//  Created by Rahil Patel on 12/28/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import UIKit

class GenresVC: UICollectionViewController {

    let itemsPerRow = 2
    let sectionInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    let genres: [Int] = [1,2,3,4,5,6]
    
    var toolbar: UIView?
    var toolbarWrapper: CustomToolbar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        toolbarWrapper = CustomToolbar(navigationController: self.navigationController!)
        toolbar = toolbarWrapper!.toolbarView
        view.addSubview(toolbar!)
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        layoutSubviews()
        print("TOOLBAR FRAME:")
        print(toolbar!.frame)
    }
    
    override func viewDidLayoutSubviews() {
        print("TOOLBAR FRAME:")
        print(toolbar!.bounds)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func layoutSubviews() {
        print(collectionView.frame)
        self.collectionView.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - toolbar!.frame.height)
        print(collectionView.frame)
        self.collectionView.backgroundColor = UIColor.black
        self.view.tintColor = UIColor.white
    }
    

}

// MARK: CollectionView FlowLayout methods
extension GenresVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: CollectionView DataSource methods
extension GenresVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return genres.count
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsPerRow
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Default", for: cellForItemAt)
        cell.backgroundColor = Colors.cinnabar
        cell.layer.cornerRadius = 5
        return cell
    }
}

// MARK: UIView extension for testing
extension UIView {
    func showTestingBorder(color: CGColor) {
        self.layer.borderColor = color
        self.layer.borderWidth = 4
    }
}
