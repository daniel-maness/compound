//
//  LoginViewController.swift
//  Compound
//
//  Created by Daniel Maness on 7/19/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation

class LoginViewController: BaseViewController {
    let userService = UserService()
    
    func loginParse(username: String, password: String, facebookUserId: String!, displayName: String!, email: String!) -> (success: Bool, error: String!) {
        if userService.userExists(username) {
            let result = userService.loginUser(username, password: username)
            currentUser = User()
            
            return result
        } else if facebookUserId != nil {
            var result = signUpParse(username, password: password, facebookUserId: facebookUserId, displayName: displayName, email: email)
            if result.success {
                result = userService.loginUser(username, password: username)
                currentUser = User()
            }
            
            return result
        }
        
        return (false, "Login failed")
    }
    
    func signUpParse(username: String, password: String, facebookUserId: String!, displayName: String!, email: String!) -> (success: Bool, error: String!) {
        if userService.userExists(username) {
            return (false, "User already exists")
        } else {
            userService.createUser(facebookUserId, username: username, password: password, displayName: displayName, email: email)
        }
        
        let result = self.loginParse(username, password: password, facebookUserId: facebookUserId, displayName: displayName, email: email)
        
        return result
    }
}