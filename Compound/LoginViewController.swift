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
    
    func loginParse(username: String, password: String, facebookUserId: String!, email: String!) -> Bool {
        if userDA.userExists(username) {
            userDA.loginUser(username, password: username)
            currentUser = User()
            
            return true
        } else if facebookUserId != nil {
            if signUpParse(username, password: password, facebookUserId: facebookUserId, email: email) {
                userDA.loginUser(username, password: username)
                currentUser = User()
                
                return true
            }
        }
        
        return false
    }
    
    func signUpParse(username: String, password: String, facebookUserId: String!, email: String!) -> Bool {
        if userDA.userExists(username) {
            return false
        } else {
            userDA.createUser(facebookUserId, username: username, email: email, password: password)
        }
        
        self.loginParse(username, password: password, facebookUserId: facebookUserId, email: email)
        
        return true
    }
}