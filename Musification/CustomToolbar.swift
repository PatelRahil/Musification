//
//  CustomToolbar.swift
//  Musification
//
//  Created by Rahil Patel on 12/29/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import Foundation
import UIKit

class CustomToolbar {
    static let items: [ToolbarItem] = [
        ToolbarItem(content: "Screen 1", type: .text, storyboardID: "GenresVC"),
        ToolbarItem(content: "Screen 2", type: .text, storyboardID: "ArtistsVC")
    ]
    static var state = 0
    static var currentItem = CustomToolbar.items[CustomToolbar.state]
    
    let toolbarView: UIView
    let navController: UINavigationController
    
    init(navigationController: UINavigationController) {
        let parent = UIScreen.main
        print("BOUNDS:")
        print(parent.bounds.maxY)
        navController = navigationController
        let height: CGFloat = 80
        toolbarView = UIView(frame: CGRect(x: 0, y: parent.bounds.maxY - height, width: parent.bounds.width, height: height))
        toolbarView.backgroundColor = Colors.cinnabar
        let itemWidth = toolbarView.frame.width / CGFloat(CustomToolbar.items.count)
        for (index,item) in CustomToolbar.items.enumerated() {
            print(item)
            let frame = CGRect(x: CGFloat(index) * itemWidth, y: 0, width: itemWidth, height: height)
            switch item.type {
            case .text:
                let button = UIButton()
                button.setTitle(item.content, for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.frame = frame
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                button.tag = index

                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                toolbarView.addSubview(button)
            case .image:
                let image = UIImage(named: item.content)
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: imageView.frame.width / 2, y: imageView.frame.height / 2, width: imageView.frame.width, height: imageView.frame.height)
                let button = UIButton()
                button.frame = imageView.frame
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                toolbarView.addSubview(imageView)
                toolbarView.addSubview(button)
            }
        }
        toolbarView.frame = CGRect(x: 0, y: parent.bounds.height - height, width: parent.bounds.width, height: height)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        print("Button Tapped.")
        let destVCIdentifier = CustomToolbar.items[sender.tag].storyboardID
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var destVC = storyboard.instantiateViewController(withIdentifier: destVCIdentifier)
        if let currentVC = navController.topViewController {
            print("\n\n\nTYPES\n\n")
            print(type(of: currentVC))
            print(type(of: destVC))
            print("\n\n\n")
            if type(of: currentVC) != type(of: destVC) {
                print("nav controller vc's")
                for c in navController.viewControllers {
                    print(type(of: c))
                }
                if navController.viewControllers.contains(where: { (vc) -> Bool in
                    let same = type(of: vc) == type(of: destVC)
                    if same  { destVC = vc }
                    return same
                }) {
                    print("POP")
                    UIView.animate(withDuration: 0.75, animations: {() -> Void in
                        UIView.setAnimationCurve(.easeInOut)
                        UIView.setAnimationTransition(.flipFromLeft, for: (self.navController.view)!, cache: false)
                    })
                    navController.popToViewController(destVC, animated: false)
                } else {
                    print("PUSH")
                    UIView.animate(withDuration: 0.75, animations: {() -> Void in
                        UIView.setAnimationCurve(.easeInOut)
                        UIView.setAnimationTransition(.flipFromRight, for: (self.navController.view)!, cache: false)
                    })
                    navController.pushViewController(destVC, animated: false)
                    print("Go from \(currentVC) to \(destVC)\n\n\n")
                }
            }
        } else {
            print("CurrentVC is nil")
        }
        
    }
}

struct ToolbarItem {
    var content = ""
    var type = ToolbarItemType.text
    var storyboardID: String = ""
}

enum ToolbarItemType {
    case text
    case image
}
