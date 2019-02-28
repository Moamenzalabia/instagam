//  PhotoSelectorController-.swift
//  InstagramDemo
//  Created by MOAMEN on 8/3/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        setupNavigationButtons()
        
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId) // this to setup collectionView header
        
        fetchPhotos()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        self.collectionView.reloadData() // this to reaload data after display selected image in header
        
        let indexPath = IndexPath(item: 0, section: 0) // to alwase select image at index 0
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    var selectedImage: UIImage?
    var images = [UIImage]()
    var assets = [PHAsset]()
    
    // this func to acess user image -to get last 20 user image ordered by creationDate at first run of app
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 20
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
        
    }
    
    // this func to desplay how to fetch photoslibrary assests
    fileprivate func  fetchPhotos(){

        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                
                let imageManager = PHImageManager.default() // to access phon image
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions() // ---->|
                options.isSynchronous = true         // ----->| this two line to make fetched image good an large with targetSize than deualt size
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        if self.selectedImage == nil { /// this to automatically dispaly firs cell image in header
                            self.selectedImage = image
                        }
                    }
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                })
                
            }
            
      }
 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0) // to leave space between header and cell = 1 pixel
    }
    
    // size of header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width) // to make header size equal to view width size
        
    }
    
    var header: PhotoSelectorHeader?
    
    // this func to display selected image in collectionview header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        
        self.header = header
        
        // this to requset selected image fro photolibrary
        if let selectedImage = selectedImage{
            if let index = self.images.index(of: selectedImage) {
                let selectedAsset =  self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    
                    header.photoImageView.image = image
                }
                
            }
        }
        
        return header
        
    }
    
    // number of cell in row is 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4 // sub 3 from width beacuse minimum space between cell in row
        
        return CGSize(width: width, height: width)
    }
    
    // this delegate func to make an 1 pixel bettwen each cell in collom
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    // this delegate func to make an 1 pixel bettwen each cell in row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }

    // images  collectionView cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {return true} // to hidden StatusBar from top
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    //  take selected image and got to sharePhotoVc to make your post
    @objc func handleNext()  {
        let sharePhotoVC =  SharePhotoVC()
        sharePhotoVC.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(sharePhotoVC, animated: true)
    }
    
    // cancel select process
    @objc func handleCancel()  {
        dismiss(animated: true, completion: nil)
        
    }
    
}

