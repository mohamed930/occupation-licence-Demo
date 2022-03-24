//
//  UIButton.swift
//  Cheif Cooking
//
//  Created by Mohamed Ali on 18/09/2021.
//

import UIKit

extension UIButton {
    
    func SetCornerRadious(BackgroundColor: String , CornerRadious: CGFloat) {
        self.layer.cornerRadius = CornerRadious
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.clear.cgColor
        
        self.layer.backgroundColor = UIColor().hexStringToUIColor(hex: BackgroundColor).cgColor
    }
    
}
