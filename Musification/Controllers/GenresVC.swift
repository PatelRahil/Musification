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
    let selectedSongsLimit = 20
    let sectionInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    var genres: [Genre] = []
    var selectedSongs: [Song] = []
    var selectedGenre: Genre = Genre()
    
    var toolbar: UIView?
    var toolbarWrapper: CustomToolbar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        toolbarWrapper = CustomToolbar(navigationController: self.navigationController!)
        toolbar = toolbarWrapper!.toolbarView
        view.addSubview(toolbar!)
        layoutSubviews()
        showSpinner(onView: view)
        MusicRequest.getGenres(success: { (genres) in
            self.genres = genres
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            self.removeSpinner()
        }) { (error) in
            print("Genre Failure:")
            print(error)
        }
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        toolbarWrapper?.toolbarView.translatesAutoresizingMaskIntoConstraints = false
        toolbarWrapper?.setupConstraints(on: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SongsVC {
            dest.songs = selectedSongs
            let barButton = UIBarButtonItem(title: selectedGenre.name, style: .done, target: dest, action: nil)
            let heightConstraint = barButton.customView?.heightAnchor.constraint(equalToConstant: 35)
            heightConstraint?.isActive = true
            dest.navigationItem.setRightBarButton(barButton, animated: true)
        }
    }
    
    func layoutSubviews() {
        navigationController?.navigationBar.barTintColor = Colors.navBarColor.lighter(by: 10)
        navigationController?.navigationBar.tintColor = Colors.textColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.textColor]
        navigationItem.title = "Genres"
        self.collectionView.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - toolbar!.frame.height)
        self.collectionView.backgroundColor = Colors.bgColor
        
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
        cell.backgroundColor = Colors.primaryColor
        cell.layer.cornerRadius = 5
        if cellForItemAt.section * 2 + cellForItemAt.row  >= genres.count {
            cell.backgroundColor = Colors.bgColor
            cell.tag = -1
        } else {
            cell.cellTextLbl.text = genres[cellForItemAt.section * 2 + cellForItemAt.row].name
            cell.cellTextLbl.textColor = Colors.textColorOnPrimaryColor
        }
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = genres[indexPath.section * 2 + indexPath.row]
        let genreName = genre.name
        let genreId = genre.id
        MusicRequest.getSongs(genreID: genreId, limit: selectedSongsLimit, success: { (songs) in
            print("Top \(self.selectedSongsLimit) songs for the \(genreName) genre:")
            for song in songs {
                print("\"\(song.name)\" by \(song.artist)")
            }
            self.selectedSongs = songs
            self.selectedGenre = genre
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "GenresToSongs", sender: nil)
            }
        }) { (error) in
            print("Song Failure")
            print(error)
        }
        print()
    }
}

// MARK: UIView extension for testing
extension UIView {
    func showTestingBorder(color: CGColor) {
        self.layer.borderColor = color
        self.layer.borderWidth = 4
    }
}
