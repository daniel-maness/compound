//
//  UserManager.swift
//  Compound
//
//  Created by Daniel Maness on 7/31/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation
import Parse

class UserManager {
    let userService = UserService()
    let facebookService = FacebookService()
    
    init() {
        
    }
    
    func getCurrentUser() -> User {
        return User(userObject: PFUser.currentUser()!)
    }
    
    func userExists(username: String) -> Bool {
        return userService.userExists(username)
    }
    
    func loginUser(username: String, password: String) -> (success: Bool, error: String!) {
        return userService.loginUser(username, password: password)
    }
    
    func createUser(facebookUserId: String!, username: String, password: String, displayName: String!, email: String!) {
        userService.createUser(facebookUserId, username: username, password: password, displayName: displayName, email: email)
    }
    
    func loadProfilePictureAsync(facebookUserId: String, completion: (result: UIImage!, error: NSError!) -> Void) {
        facebookService.loadProfilePictureAsync(facebookUserId, completion: { (result, error) -> Void in
            if error == nil {
                completion(result: UIImage(data: result), error: nil)
            } else {
                EventService.logError(error!, description: "Facebook profile picture could not be loaded", object: "User", function: "updateProfilePictureAsync")
                completion(result: UIImage(named: PROFILE_PICTURE), error: error)
            }
        })
    }
    
    func loadProfilePicture(facebookUserId: String) -> UIImage {
        let result = facebookService.loadProfilePicture(facebookUserId)
        
        if result.error == nil {
            return UIImage(data: result.data)!
        } else {
            return UIImage(named: PROFILE_PICTURE)!
        }
    }
    
    func getStats() -> Statistics {
        return userService.getStats(PFUser.currentUser()!)
    }
    
    func updateStats(puzzle: Puzzle) {
        userService.updateStats(PFUser.currentUser()!, puzzle: puzzle)
    }
    
    func getVersusStats() {
        
    }
    
    func getBestOfStats() {
        
    }
}