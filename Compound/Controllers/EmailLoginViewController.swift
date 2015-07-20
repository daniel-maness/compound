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
        
        if username == "" {
            messageLabel.text = "Email required"
        } else if password == "" {
            messageLabel.text = "Password required"
        } else {
            messageLabel.text = ""
            if self.loginParse(username, password: password, facebookUserId: nil, email: nil) {
                self.showHomeViewController()
            } else {
                messageLabel.text = "Invalid email/password combination"
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
}