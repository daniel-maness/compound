//
//  LoginViewController.swift
//  compound
//
//  Created by Daniel Maness on 5/15/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation
import Parse

class EmailLoginViewController: LoginViewController {
    /* Outlets */
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    /* Actions */
    @IBAction func onLoginPressed(sender: UIButton) {
        var username = usernameTextField.text
        var password = passwordTextField.text
        
        messageLabel.text = ""
        
        if username == "" {
            messageLabel.text = "Email required"
        } else if password == "" {
            messageLabel.text = "Password required"
        } else {
            usernameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            let result = self.loginParse(username, password: password, facebookUserId: nil, email: nil)
            if result.success {
                self.showHomeViewController()
            } else {
                messageLabel.text = result.error
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}