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
    var userDA = UserDA()
    
    /* Outlets */
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    /* Actions */
    @IBAction func onSignupPressed(sender: UIButton) {
        var username = usernameTextField.text
        var password = passwordTextField.text
        
        messageLabel.text = ""
        
        if username == "" {
            messageLabel.text = "Username required"
        } else if password == "" {
            messageLabel.text = "Password required"
        } else {
            usernameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            if userSignUp(username, password: password) {
                self.showHomeViewController()
            }
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
    
    func userSignUp(username: String, password: String) -> Bool {
        if userDA.userExists(username) {
            self.messageLabel.text = "User already exists"
        } else {
            userDA.createUser(nil, username: username, password: password, email: nil)
            userDA.loginUser(username, password: password)
            currentUser = User()
            return true
        }
        
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}