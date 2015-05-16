//
//  LoginViewController.swift
//  compound
//
//  Created by Daniel Maness on 5/15/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation
import Parse

class SignupViewController: BaseViewController {
    /* Outlets */
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    /* Actions */
    @IBAction func onSignupPressed(sender: UIButton) {
        var username = usernameTextField.text
        var password = passwordTextField.text
        var email = emailTextField.text
        
        if username == "" {
            messageLabel.text = "Username required"
        } else if password == "" {
            messageLabel.text = "Password required"
        } else if email == "" {
            messageLabel.text = "E-mail address required"
        } else {
            messageLabel.text = ""
            userSignUp(username, password: password, email: email)
        }
    }
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uiView = self.view as UIView
        setupView()
    }
    
    func setupView() {
        messageLabel.text = ""
    }
    
    func userSignUp(username: String, password: String, email: String) {
        var user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        user.signUpInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                self.showHomeViewController()
            } else {
                self.messageLabel.text = "User already exists"
            }
        }
    }
    
    func userSignIn() {
        
    }
}