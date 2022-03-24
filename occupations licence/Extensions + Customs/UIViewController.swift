//
//  UIViewController.swift
//  occupation
//
//  Created by Mohamed Ali on 10/10/2021.
//

import UIKit
import RappleProgressHUD
import ProgressHUD

extension UIViewController {
    func ShowAnimation() {
        RappleActivityIndicatorView.startAnimatingWithLabel("Waiting".localized, attributes: RappleModernAttributes)
    }
    
    func DismissAnimation() {
        RappleActivityIndicatorView.stopAnimation()
    }
    
    func ShowSuccess(mess: String) {
        ProgressHUD.showSuccess(mess)
    }
    
    func ShowError(mess: String) {
        ProgressHUD.showError(mess)
    }
}
