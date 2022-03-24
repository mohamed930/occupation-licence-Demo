//
//  UIView.swift
//  Cheif Cooking
//
//  Created by Mohamed Ali on 20/09/2021.
//

import UIKit

extension UIView {
    
    func MakeCircle(BackgroundColor: String, BorderColor: String , BorderWidth: CGFloat) {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
        self.layer.backgroundColor = UIColor().hexStringToUIColor(hex: BackgroundColor).cgColor
        self.layer.borderColor = UIColor().hexStringToUIColor(hex: BorderColor).cgColor
        self.layer.borderWidth = BorderWidth
    }
    
    public func MakeRound(cornerRadious: CGFloat,v:CACornerMask) {
        
        /*
            top-right:    layerMaxXMinYCorner
            top-left:     layerMinXMinYCorner
            button-right: layerMaxXMaxYCorner
            button-left:  layerMinXMaxYCorner
         */
        
        self.layer.cornerRadius = cornerRadious
        self.layer.maskedCorners = v
    }
    
    
    func addDashedBorder(cornerRadious: CGFloat, color: String) {
        let color = UIColor().hexStringToUIColor(hex: color).cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadious).cgPath

//        shapeLayer.cornerRadius = cornerRadious
//        shapeLayer.masksToBounds = true
        
        shapeLayer.frame = self.bounds
//        shapeLayer.aut
        self.layer.addSublayer(shapeLayer)
    }
}
