//  ViewController.swift
//  InstagramDemo
//  Created by MOAMEN on 7/24/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // change UIStatusBarStyle to light color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Mark: button to select image from iphone libaray
    let SelectProfileImage: CustomRoundedButton = {
        let button = CustomRoundedButton(type: .system)
        button.setImage(UIImage(named: "noProfilePhoto")?.withRenderingMode(.alwaysOriginal) , for: .normal)
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
       
        return button
    }()
    
    //Mark: button action
    @objc func handleSelectPhoto()  {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing =  true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //Mark: display image in button and it's status  and custom desgin
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage]  as? UIImage {
             SelectProfileImage.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }else if let originalImage = info[.originalImage]  as? UIImage {
            SelectProfileImage.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    //Mark: Email text field to aske user email
    let emailTextField: UITextField = {
        
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.backgroundColor = UIColor.rgb(red: 224, green: 56, blue: 81)
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
            signUpButton.backgroundColor = UIColor.white
            
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 228, green: 198, blue: 207)
            
        }
        
    }

    //Mark: username text field to aske user name
    let userNameTextField: UITextField = {
        
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Username",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.backgroundColor = UIColor.rgb(red: 224, green: 56, blue: 81)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    
    }()
    
    //Mark: password text field to aske user password
    let passWordTextField: UITextField = {
    
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.backgroundColor = UIColor.rgb(red: 224, green: 56, blue: 81)
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    
    }()
    
    //Mark: signup button to signup user into app
    let signUpButton: CustomButton = {
      
        let button = CustomButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 207, green: 156, blue: 167)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.rgb(red: 226, green: 34, blue: 56), for: .normal)
        button.addTarget(self, action: #selector(handleSignUP), for: .touchUpInside)
        button.isEnabled = false
        return button
   
    }()
    
    //Mark:  action of signup button if user press on it to save user data into firebase acount
    @objc func handleSignUP() {
        signUpButton.setupButtonAnimation()
        
        guard let email = emailTextField.text, email.count > 0 else {return}
        guard let username = userNameTextField.text, username.count > 0 else {return}
        guard let password = passWordTextField.text, password.count > 0 else {return}
       
        //Mark: to create user into firebase Authentcation
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                self.showAlert("Failed to create user : \(err.localizedDescription)", title: "Error")
            }
            
            guard let image = self.SelectProfileImage.imageView?.image  else {return}
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
                
                guard let fcmToken = Messaging.messaging().fcmToken else { return }
                
                let dictionaryValues = ["username": username, "profileImageUrl": downloadURL, "fcmToken": fcmToken]
                let values = [user?.uid: dictionaryValues]
                
                //Mark: save user name and imagelink into firebase database
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, referrnce) in
                    if let err = error{
                        print("Failed to save info into db:", err.localizedDescription)
                        return
                    }else {
                        print("Successfully to save info into db:")
                        DispatchQueue.main.async {
                            self.showAlert("Successfully  created user : \(user?.uid ?? "")", title: "Successfully")
                            let mainTabbar = MainTabBarController()
                            UIApplication.shared.keyWindow?.rootViewController = mainTabbar
                            mainTabbar.setupViewControllers()
                        }
                    }
                })
            })
        }
    }
    
    let alreadyHaveAccountButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 228, green: 198, blue: 207)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        
        return button
        
    }()
    
    @objc func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.1294117647, blue: 0.2274509804, alpha: 1)

        view.addSubview(alreadyHaveAccountButton)
        
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: view.frame.height * 0.05, paddingRight: 0, width: 0, height: 50)
        plusPhotoButtonConstraint()
        setupInputFields()
        
    }
    
    //Mark: select image button constrain
    fileprivate func plusPhotoButtonConstraint() {
        
        view.addSubview(SelectProfileImage)
        SelectProfileImage.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        SelectProfileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    //Mark: text feild's that aske user information's constrain that's include in stackView
    fileprivate  func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passWordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.anchor(top: SelectProfileImage.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
        
        emailTextField.delegate = self
        passWordTextField.delegate = self
        userNameTextField.delegate = self
        
    }
    
    // handel view keyboard dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // handel textfields  keyboard dismiss
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
