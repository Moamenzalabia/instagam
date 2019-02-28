//  SharePhotoVC.swift
//  InstagramDemo
//  Created by MOAMEN on 8/25/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit
import Firebase
import FirebaseStorage

class SharePhotoVC: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        setupImageAndTextViews()
    }
    
    // post image
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
       
        return image
    }()
    
    // post description
    let textView: UITextView = {
         let textvivew = UITextView()
         textvivew.font = UIFont.systemFont(ofSize: 14)
        
        return textvivew
    }()
    
    fileprivate func setupImageAndTextViews (){
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 120)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 104, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
    }
    
    @objc func handleShare() {
     
        guard let caption = textView.text, caption.count > 0 else { return }
        guard let image = selectedImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false // to stop share post's again untell current post sharing
        
        let filename = NSUUID().uuidString
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // if there's error happened
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image", error!.localizedDescription)
                return
            }
            // if post Successfully store into firebase storage get post image url to save it into firebase database
            guard let imageUrl = metadata.downloadURL()?.absoluteString else { return }
            print("Successfully upload post image ", imageUrl)
            self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
        }
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UdateFeed")
    
    fileprivate func saveToDatabaseWithImageUrl (imageUrl: String) {
        
        guard let postImage = selectedImage else { return }
        guard let caption   = textView.text else { return}
       
        guard  let uid = Auth.auth().currentUser?.uid else {return}
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to Database", error.localizedDescription)
                
                return
            }else{
                 print("Successfully saved post to Database")
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: SharePhotoVC.updateFeedNotificationName, object: nil)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
        
    }
    
}
