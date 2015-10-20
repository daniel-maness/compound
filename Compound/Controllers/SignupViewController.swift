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
    var userService = UserService()
    
    /* Outlets */
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    /* Actions */
    @IBAction func onSignupPressed(sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let displayName = ""
        
        messageLabel.text = ""
        
        if username == "" {
            messageLabel.text = "Username required"
        } else if password == "" {
            messageLabel.text = "Password required"
        } else {
            usernameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            if userSignUp(username!, password: password!, displayName: displayName) {
                self.showHomeViewController()
            }
        }
    }
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        messageLabel.text = ""
    }
    
    func userSignUp(username: String, password: String, displayName: String!) -> Bool {
        if userService.userExists(username) {
            self.messageLabel.text = "User already exists"
        } else {
            userService.createUser(nil, username: username, password: password, displayName: displayName, email: nil)
            userService.loginUser(username, password: password)
            CurrentUser = User(userObject: PFUser.currentUser()!)
            return true
        }
        
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}