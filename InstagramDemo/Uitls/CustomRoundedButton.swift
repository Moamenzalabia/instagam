//  ProfileButton.swift
//  InstagramDemo
//  Created by MOAMEN on 12/9/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit

class CustomRoundedButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        layer.masksToBounds = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 3

    }


}
