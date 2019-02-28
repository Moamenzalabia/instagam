//  CustomButton.swift
//  InstagramDemo
//  Created by MOAMEN on 12/9/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit

class CustomButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
   
    func setupButtonAnimation(){
        
        let basicAnimation = CABasicAnimation(keyPath: "position")
        basicAnimation.duration = 0.2
        basicAnimation.repeatCount = 1
        basicAnimation.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 8, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 8, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        basicAnimation.fromValue = fromValue
        basicAnimation.toValue = toValue
        
        layer.add(basicAnimation, forKey: "position")
    }

}
