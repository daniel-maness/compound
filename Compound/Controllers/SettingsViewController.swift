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
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    
    /* Actions */
    @IBAction func onHomePressed(sender: UIButton) {
        self.showHomeViewController()
    }
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        //self.view.addSubview(facebookLoginButton)
        
        let uiView = self.view as UIView
    }
    
    func setupView() {
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        if FBSDKAccessToken.currentAccessToken() == nil {
            var storyboard = UIStoryboard(name: "User", bundle: nil)
            var viewController = storyboard.instantiateViewControllerWithIdentifier("FacebookLoginViewController") as! FacebookLoginViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
}