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
    private let userManager = UserManager()
    
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
            CurrentUser = User(userObject: PFUser.currentUser()!)
            self.showHomeViewController()
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            EventService.logError(error!, description: "Could not log into Facebook", object: "FacebookLoginViewController", function: "loginButton")
        } else if result.isCancelled {
            EventService.logEvent("Cancelled login")
        } else {
            EventService.logSuccess("Granted permissions: \(result.grantedPermissions)")
            loginFacebook()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginFacebook() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if error == nil {
                let id = result.valueForKey("id") as! String
                let displayName = result.valueForKey("name") as! String
                let username = id
                let password = id
                
                self.loginParse(username, password: password, facebookUserId: id, displayName: displayName, email: nil)
                
                CurrentUser = self.userManager.getCurrentUser()
                
                self.showHomeViewController()
            } else {
                EventService.logError(error!, description: "Could not log into Facebook", object: "FacebookLoginViewController", function: "loginFacebook")
            }
        })
    }
}