//  ViewController.swift
//  InstagramDemo
//  Created by MOAMEN on 7/24/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Mark: button to select image from iphone libaray
    let plusPhotoButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal) , for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
        
    }()
    
    //Mark: button action
    @objc func handlePlusPhoto()  {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing =  true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //Mark: display image in button and it's status  and custom desgin
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage]  as? UIImage {
             plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }else if let originalImage = info[.originalImage]  as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.lightGray.cgColor
        plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
        
    }
    
    //Mark: Email text field to aske user email
    let emailTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
        
    }()
    
    //Mark: to ask user to enter all text field before signup to app
    @objc func handleTextInputChange() {
        
        let isFormVaild = emailTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0 && passWordTextField.text?.count ?? 0 > 0
        if isFormVaild {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            
        }
        
    }

    //Mark: username text field to aske user name
    let userNameTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    
    }()
    
    //Mark: password text field to aske user password
    let passWordTextField: UITextField = {
    
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    
    }()
    
    //Mark: signup button to signup user into app
    let signUpButton: UIButton = {
      
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
       // button.addTarget(self, action: #selector(handleSignUP), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleSignUP), for: .touchUpInside)
        button.isEnabled = false
        return button
   
    }()
    
    //Mark:  action of signup button if user press on it to save user data into firebase acount
    @objc func handleSignUP() {
    
        guard let email = emailTextField.text, email.count > 0 else {return}
        guard let username = userNameTextField.text, username.count > 0 else {return}
        guard let password = passWordTextField.text, password.count > 0 else {return}
        guard let uid = Auth.auth().currentUser?.uid else{return}
       
        //Mark: to create user into firebase Authentcation
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                        print("Failed to create user:", err.localizedDescription)
            }else {
                print("Successfully  created user", uid)
            }
          
            guard let image = self.plusPhotoButton.imageView?.image  else {return}
            guard let uploadData = image.jpegData(compressionQuality: 0.1) else {return}
            let filename = NSUUID().uuidString
            
            //Mark: to save user image into firebase Storage
            let storageRef = Storage.storage().reference().child("Profile_images")
            _ = storageRef.child(filename).putData(uploadData, metadata: nil, completion: { (metadata,error ) in
                guard let metadata = metadata else{
                    print("Failed to upload profile image:",error!.localizedDescription)
                    return
                }
                
                let downloadURL = metadata.downloadURL()!.absoluteString
                print("Successfully uploaded profile image :", downloadURL)
                let dictionaryValues = ["username": username, "profileImageUrl": downloadURL]
                let values = [uid: dictionaryValues]
                
                //Mark: save user name and imagelink into firebase database
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, referrnce) in
                    if let err = error{
                        print("Failed to save info into db:", err.localizedDescription)
                        return
                    }else {
                        print("Successfully to save info into db:")
    
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                        mainTabBarController.setupViewControllers()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            })
  
        }
        
    }
    
    let alreadyHaveAccountButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        
        return button
        
    }()
    
    @objc func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(alreadyHaveAccountButton)
        
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        plusPhotoButtonConstraint()
        setupInputFields()
        
    }
    
    //Mark: select image button constrain
    fileprivate func plusPhotoButtonConstraint() {
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    //Mark: text feild's that aske user information's constrain that's include in stackView
    fileprivate  func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passWordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
        
    }
    
}

//Mark: custtom  cnstrain's function to apply autolayout concept in any thing in my app
extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat,paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height:CGFloat)  {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
}
