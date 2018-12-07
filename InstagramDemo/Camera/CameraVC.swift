//  CameraVC.swift
//  InstagramDemo
//  Created by MOAMEN on 9/1/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit
import AVFoundation

class CameraVC: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {

    let dismissButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
        
    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let capturePhotoButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
        
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        setupCaptureSession()
        setupHUD()
    }
    
    let customeAnimationPresentor = CustomeAnimationPresentor()
    let customeAnimationDismisser = CustomeAnimationDismisser()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customeAnimationPresentor
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customeAnimationDismisser
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    fileprivate func setupHUD() {
        
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 50, height: 50)
    }
    
    @objc func handleCapturePhoto() {
        let settings = AVCapturePhotoSettings()
        
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewFormatType]
        
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard error == nil else {
            print("Fail to capture photo: \(String(describing: error))")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        let previewImage = UIImage(data: imageData)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    let output = AVCapturePhotoOutput()

    fileprivate func setupCaptureSession() {
        
        let captureSession = AVCaptureSession()
        
        // 1.setup inputs
        guard  let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice )
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
        } catch let error {
             print("Could not setup camera input",error.localizedDescription)
        }
        //2. setup outputs
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.frame
            view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
       
    }

}
