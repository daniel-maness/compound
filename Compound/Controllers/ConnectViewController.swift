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

class ConnectViewController: BaseViewController, FBSDKLoginButtonDelegate {
    /* Outlets */
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        //self.view.addSubview(facebookLoginButton)
        
        let uiView = self.view as UIView
    }
    
    override func viewDidAppear(animated: Bool) {
        let accessToken = FBSDKAccessToken.currentAccessToken()
        if accessToken != nil {
            currentUser = User()
            currentUser.facebookUserId = FBSDKAccessToken.currentAccessToken().userID
            
            let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token=" + accessToken.tokenString)
            let urlRequest = NSURLRequest(URL: url!)
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                let image = UIImage(data: data)
                currentUser.profilePicture = image
            }
            
            self.showHomeViewController()
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        let accessToken = FBSDKAccessToken.currentAccessToken()
        if accessToken != nil {
            currentUser = User()
            currentUser.facebookUserId = FBSDKAccessToken.currentAccessToken().userID
            
            let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token=" + accessToken.tokenString)
            let urlRequest = NSURLRequest(URL: url!)
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                let image = UIImage(data: data)
                currentUser.profilePicture = image
            }
            
            self.showHomeViewController()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
}