//
//  PhotoSelectorCell.swift
//  InstagramDemo
//
//  Created by MOAMEN on 8/8/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    
    
    let photoImageView: UIImageView = {
        
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = UIColor.lightGray
        
        return image
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
