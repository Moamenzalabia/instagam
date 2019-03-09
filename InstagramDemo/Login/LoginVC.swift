//  LoginVC.swift
//  InstagramDemo
//  Created by MOAMEN on 7/27/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit
import Firebase
//import FBSDKCoreKit
//import FacebookLogin
//import FacebookCore
import FBSDKLoginKit

class LoginVC: UIViewController, UITextFieldDelegate{
    
    let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 247, green: 116, blue: 124)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.clipsToBounds = true
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
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Email",
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
        textField.isSecureTextEntry = true
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.backgroundColor = UIColor.rgb(red: 224, green: 56, blue: 81)
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
            loginButton.backgroundColor = UIColor.white
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 228, green: 198, blue: 207)
        }
        
    }
    
    //Mark: signup button to signup user into app
    let loginButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 207, green: 156, blue: 167)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.rgb(red: 226, green: 34, blue: 56), for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    @objc func handleLogin() {
        loginButton.setupButtonAnimation()
        guard let email = emailTextField.text else {return}
        guard let password = passWordTextField.text else {return}

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let  err = error {
                self.showAlert("Failed to sign in with email : \(err.localizedDescription)", title: "Error")
                return
            } else {
                self.showAlert("Successfully you are logged In : \(Auth.auth().currentUser?.displayName ?? "")", title: "Successfully")
                UserDefaults.standard.set(true, forKey: "isLogedIn")
                DispatchQueue.main.async {
                    let mainTabbar = MainTabBarController()
                    UIApplication.shared.keyWindow?.rootViewController = mainTabbar
                    mainTabbar.setupViewControllers()
                }
            }
       }
    }
    // to go to signup vc
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 228, green: 198, blue: 207)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUP), for: .touchUpInside)
        
        return button
    }()
  
    @objc func handleShowSignUP() {
        let signupVC = SignUpVC()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    // chage UIStatusBarStyle to lightColor
    override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height * 0.22)
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.1294117647, blue: 0.2274509804, alpha: 1)

        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: view.frame.height * 0.05, paddingRight: 0, width: 0, height: 50)
        
        setupInputFields()
    }
    
    fileprivate func setupInputFields () {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passWordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 45, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 150)
        
        emailTextField.delegate = self
        passWordTextField.delegate = self
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
