//
//  LoginViewController.swift
//  Compound
//
//  Created by Daniel Maness on 7/19/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation

class LoginViewController: BaseViewController {
    private let userManager = UserManager()
    
    func loginParse(username: String, password: String, facebookUserId: String!, displayName: String!, email: String!) -> (success: Bool, error: String!) {
        if userManager.userExists(username) {
            let result = userManager.loginUser(username, password: username)
            CurrentUser = userManager.getCurrentUser()
            
            return result
        } else if facebookUserId != nil {
            var result = signUpParse(username, password: password, facebookUserId: facebookUserId, displayName: displayName, email: email)
            if result.success {
                result = userManager.loginUser(username, password: username)
                CurrentUser = userManager.getCurrentUser()
            }
            
            return result
        }
        
        return (false, "Login failed")
    }
    
    func signUpParse(username: String, password: String, facebookUserId: String!, displayName: String!, email: String!) -> (success: Bool, error: String!) {
        if userManager.userExists(username) {
            return (false, "User already exists")
        } else {
            userManager.createUser(facebookUserId, username: username, password: password, displayName: displayName, email: email)
        }
        
        let result = self.loginParse(username, password: password, facebookUserId: facebookUserId, displayName: displayName, email: email)
        
        return result
    }
}