//
//  LoginViewController.swift
//  compound
//
//  Created by Daniel Maness on 5/15/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookLoginViewController: LoginViewController, FBSDKLoginButtonDelegate {
    /* Outlets */
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    let permissions = ["public_profile", "email", "user_friends"]
    var userName: String!
    var userEmail: String!
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.readPermissions = self.permissions
        facebookLoginButton.delegate = self
        
        let uiView = self.view as UIView
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            loginFacebook()
        } else {
            currentUser = User()
            self.showHomeViewController()
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        loginFacebook()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginFacebook() {
        if let accessToken = FBSDKAccessToken.currentAccessToken() {
            self.loginParse(accessToken.userID, password: accessToken.userID, facebookUserId: accessToken.userID, email: nil)
            
            currentUser = User()
            self.showHomeViewController()
        }
    }
}