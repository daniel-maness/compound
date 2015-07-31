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

class SettingsViewController: BaseViewController, FBSDKLoginButtonDelegate {
    /* Outlets */
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet var emailLogOutButton: UIButton!
    
    /* Actions */
    @IBAction func onHomePressed(sender: UIButton) {
        self.showHomeViewController()
    }
    
    @IBAction func onLogOutPressed(sender: UIButton) {
        logOut()
    }
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CurrentUser.facebookUserId != nil {
            facebookLoginButton.delegate = self
            facebookLoginButton.readPermissions = FACEBOOK_PERMISSIONS
        }
        
        setupView()
        
        let uiView = self.view as UIView
    }
    
    func setupView() {
        if CurrentUser.facebookUserId == nil {
            facebookLoginButton.hidden = true
            emailLogOutButton.hidden = false
        } else {
            facebookLoginButton.hidden = false
            emailLogOutButton.hidden = true
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        if FBSDKAccessToken.currentAccessToken() == nil {
            logOut()
        }
    }
    
    func logOut() {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            var storyboard = UIStoryboard(name: "User", bundle: nil)
            var viewController = storyboard.instantiateViewControllerWithIdentifier("FacebookLoginViewController") as! FacebookLoginViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
}