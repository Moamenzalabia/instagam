//
//  LoginVC.swift
//  InstagramDemo
//
//  Created by MOAMEN on 7/27/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    
    let logoContainerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        
        let logoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
        
    }()
    
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
    
    //Mark: to ask user to enter all text field before signup to app
    @objc func handleTextInputChange() {
        
        let isFormVaild = emailTextField.text?.count ?? 0 > 0  && passWordTextField.text?.count ?? 0 > 0
        if isFormVaild {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            
        }
        
    }
    
    //Mark: signup button to signup user into app
    let loginButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
        
    }()
    
    @objc func handleLogin() {
        
        guard let email = emailTextField.text else {return}
        guard let password = passWordTextField.text else {return}

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let  err = error {
                print("Failed to sign in with email: ", err.localizedDescription)
                return
            } else {
                print("Successfully logged back in with user: ", Auth.auth().currentUser?.displayName)
                
                DispatchQueue.main.async {
                    let mainTabbar = MainTabBarController()
                    UIApplication.shared.keyWindow?.rootViewController = mainTabbar
                    mainTabbar.setupViewControllers()
                }
            }
       }
    }
    
    
    let dontHaveAccountButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
      
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUP), for: .touchUpInside)
        
        return button
        
    }()
  
    @objc func handleShowSignUP() {
        
        let signupVC = SignUpVC()
        navigationController?.pushViewController(signupVC, animated: true)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        if let user = Auth.auth().currentUser {
//            print(user.email)
//        }
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 180 )
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        view.addSubview(dontHaveAccountButton)
        
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        setupInputFields()
        
    }
    
    fileprivate func setupInputFields () {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passWordTextField, loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 45, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 150)
        
        
    }
}
