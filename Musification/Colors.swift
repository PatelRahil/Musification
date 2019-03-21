//
//  Colors.swift
//  Musification
//
//  Created by Rahil Patel on 12/28/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    /// A flat burnt red color.
    /// The current app theme.
    static let cinnabar = UIColor.init(r: 231, g: 76, b: 60, a: 1)
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
