//
//  UITextField.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import UIKit

extension UITextField {
    
    func SetCornerRadiousWithBorder(cornerRadious: CGFloat,BorderSize: CGFloat,paddingValue: Int,PlaceHolder: String, Color: String) {
        
        self.layer.cornerRadius = cornerRadious
        self.layer.masksToBounds = true
        
        self.layer.borderColor = UIColor().hexStringToUIColor(hex: Color).cgColor
        self.layer.borderWidth = BorderSize
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: paddingValue, height: 20))
        self.rightView = paddingView
        self.rightViewMode = .always
        
        self.attributedPlaceholder = NSAttributedString(string: PlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor().hexStringToUIColor(hex: Color)])
        
    }
    
    func SetPlaceHoler(PlaceHolder: String, Color: String, paddingValue: Int) {
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: paddingValue, height: 20))
        self.rightView = paddingView
        self.rightViewMode = .always
        
        self.attributedPlaceholder = NSAttributedString(string: PlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor().hexStringToUIColor(hex: Color)])
    }
    
    func SetBorder(color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
    }
    
}
