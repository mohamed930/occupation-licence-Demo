//
//  UIImageView.swift
//  DARDESH
//
//  Created by Mohamed Ali on 04/07/2021.
//

import UIKit

extension UIImageView {
    
    func MakeImageCircle() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true

        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
    }
    
    func MakeImageCornerRadious(CornderRadious: CGFloat) {
        self.layer.cornerRadius = CornderRadious
        self.clipsToBounds = true

        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
    }
    
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 17
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}


extension UIImage {
    
    func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {
           UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
           self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
           let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
           return newImage
       }
    
}
