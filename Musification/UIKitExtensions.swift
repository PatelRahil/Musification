//
//  UIKitExtensions.swift
//  Musification
//
//  Created by Rahil Patel on 3/23/19.
//  Copyright © 2019 RahilPatel. All rights reserved.
//

import Foundation
import UIKit


var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

fileprivate class BorderView: UIView {} // dummy class to help us differentiate among border views and other views
// to enable us to remove existing borders and place new ones

extension UIView {
    
    func setBorders(toEdges edges: [UIRectEdge], withColor color: UIColor, inset: CGFloat = 0, thickness: CGFloat) {
        // Remove existing edges
        for view in subviews {
            if view is BorderView {
                view.removeFromSuperview()
            }
        }
        // Add new edges
        if edges.contains(.all) {
            addSidedBorder(toEdge: [.left,.right, .top, .bottom], withColor: color, inset: inset, thickness: thickness)
        }
        if edges.contains(.left) {
            addSidedBorder(toEdge: [.left], withColor: color, inset: inset, thickness: thickness)
        }
        if edges.contains(.right) {
            addSidedBorder(toEdge: [.right], withColor: color, inset: inset, thickness: thickness)
        }
        if edges.contains(.top) {
            addSidedBorder(toEdge: [.top], withColor: color, inset: inset, thickness: thickness)
        }
        if edges.contains(.bottom) {
            addSidedBorder(toEdge: [.bottom], withColor: color, inset: inset, thickness: thickness)
        }
    }
    
    private func addSidedBorder(toEdge edges: [RectangularEdges], withColor color: UIColor, inset: CGFloat = 0, thickness: CGFloat) {
        for edge in edges {
            let border = BorderView(frame: .zero)
            border.backgroundColor = color
            addSubview(border)
            border.translatesAutoresizingMaskIntoConstraints = false
            switch edge {
            case .left:
                NSLayoutConstraint.activate([
                    border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: inset),
                    border.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
                    border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset),
                    NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: thickness) ])
            case .right:
                NSLayoutConstraint.activate([
                    border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -inset),
                    border.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
                    border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset),
                    NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: thickness) ])
            case .top:
                NSLayoutConstraint.activate([
                    border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: inset),
                    border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -inset),
                    border.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
                    NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: thickness) ])
            case .bottom:
                NSLayoutConstraint.activate([
                    border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: inset),
                    border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -inset),
                    border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset),
                    NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: thickness) ])
            }
        }
    }
    
    private enum RectangularEdges {
        case left
        case right
        case top
        case bottom
    }
}
