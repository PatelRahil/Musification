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
    var genres: [String] = []
    
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
        print("\n\n\n\n")
        MusicRequest.getGenres(success: { (genres) in
            print("Genres:")
            for genre in genres {
                print(genre)
            }
            self.genres = genres
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }) { (error) in
            print("Failure:")
            print(error)
        }
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
        print("\n\n\nCount:")
        print(genres.count)
        if genres.count % 2 == 1 {
            return genres.count / 2 + 1
        } else {
            return genres.count / 2
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsPerRow
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt: IndexPath) -> UICollectionViewCell {
        print(genres.count)
        print("Section: \(cellForItemAt.section) Row: \(cellForItemAt.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Default", for: cellForItemAt) as! GenreCollectionViewCell
        cell.backgroundColor = Colors.cinnabar
        cell.layer.cornerRadius = 5
        let index = cell
        if cellForItemAt.section * 2 + cellForItemAt.row  >= genres.count {
            cell.backgroundColor = UIColor.black
            cell.tag = -1
        } else {
            cell.cellTextLbl.text = genres[cellForItemAt.section * 2 + cellForItemAt.row]
        }
        
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
