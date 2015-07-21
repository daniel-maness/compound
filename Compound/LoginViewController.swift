//
//  LoginViewController.swift
//  Compound
//
//  Created by Daniel Maness on 7/19/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation

class LoginViewController: BaseViewController {
    let userDA = UserDA()
    
    func loginParse(username: String, password: String, facebookUserId: String!, email: String!) -> (success: Bool, error: String!) {
        if userDA.userExists(username) {
            let result = userDA.loginUser(username, password: username)
            currentUser = User()
            
            return result
        } else if facebookUserId != nil {
            var result = signUpParse(username, password: password, facebookUserId: facebookUserId, email: email)
            if result.success {
                result = userDA.loginUser(username, password: username)
                currentUser = User()
            }
            
            return result
        }
        
        return (false, "Login failed")
    }
    
    func signUpParse(username: String, password: String, facebookUserId: String!, email: String!) -> (success: Bool, error: String!) {
        if userDA.userExists(username) {
            return (false, "User already exists")
        } else {
            userDA.createUser(facebookUserId, username: username, password: password, email: email)
        }
        
        let result = self.loginParse(username, password: password, facebookUserId: facebookUserId, email: email)
        
        return result
    }
}