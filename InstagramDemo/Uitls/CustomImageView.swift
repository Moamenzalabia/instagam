//
//  CustomImageView.swift
//  InstagramDemo
//
//  Created by MOAMEN on 8/27/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.
//

import UIKit

var imageCashe = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        
        lastURLUsedToLoadImage = urlString
        self.image = nil
        
        if let cachedImage = imageCashe[urlString] {
            self.image = cachedImage
            return
        }
        
        guard  let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // check for the error , then construct the image using data
            if let error = error {
                print("Failed to fetch post image", error)
                return
            }
            
            //to download image by it's creation's order
           if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            // perhaps check for response status of 200 (HTTP OK)
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCashe[url.absoluteString] = photoImage
            
            // need to get back onto  the main UI thread
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
  
      }
    
}

