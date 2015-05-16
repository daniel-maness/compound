//
//  LoginViewController.swift
//  compound
//
//  Created by Daniel Maness on 5/15/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation
import Parse

class LoginViewController: BaseViewController {
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
            messageLabel.text = "Username required"
        } else if password == "" {
            messageLabel.text = "Password required"
        } else {
            messageLabel.text = ""
            userLogin(username, password: password)
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
    
    func userLogin(username: String, password: String) {
        
    }
}