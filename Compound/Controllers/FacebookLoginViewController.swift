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
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  FBSDKAccessToken.currentAccessToken() == nil {
            facebookLoginButton.readPermissions = FACEBOOK_PERMISSIONS
            facebookLoginButton.delegate = self
        }
        
        let uiView = self.view as UIView
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            //loginFacebook()
        } else {
            currentUser = User()
            self.showHomeViewController()
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            println("Error: \(error)")
        } else if result.isCancelled {
            println("Cancelled login")
        } else {
            println("Granted permissions: \(result.grantedPermissions)")
            loginFacebook()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginFacebook() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if error != nil {
                println("Error: \(error)")
            } else {
                let id = result.valueForKey("id") as! String
                let displayName = result.valueForKey("name") as! String
                let username = id
                let password = id
                //let email = result.valueForKey("contact_email") as! String
                
//                if !self.userService.userExists(username) {
//                    self.userService.createUser(id, username: username, password: password, email: nil)
//                }
                
                self.loginParse(username, password: password, facebookUserId: id, displayName: displayName, email: nil)
                
                currentUser = User()
                self.showHomeViewController()
            }
        })
    }
}