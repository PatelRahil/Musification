//
//  CollectionViewCells.swift
//  Musification
//
//  Created by Rahil Patel on 3/22/19.
//  Copyright © 2019 RahilPatel. All rights reserved.
//

import Foundation
import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    let cellTextLbl = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = self.contentView.frame.size
        let pos = CGPoint.zero
        cellTextLbl.frame = CGRect(origin: pos, size: size)
        cellTextLbl.textAlignment = .center
        contentView.addSubview(cellTextLbl)
    }
}
