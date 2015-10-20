//
//  UserService.swift
//  Compound
//
//  Created by Daniel Maness on 4/29/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation
import Parse
import FBSDKCoreKit

class UserService {
    func userExists(username: String) -> Bool {
        let query = PFUser.query()!.whereKey("username", equalTo: username)
        let user = query.findObjects()?.first as! PFObject!
        
        return user != nil && username == user["username"] as! String
    }
    
    func createUser(facebookUserId: String!, username: String, password: String, displayName: String!, email: String!) {
        let user = PFUser()
        
        user.username = username
        user.password = password
        user.email = email
        
        if facebookUserId != nil {
            user["facebookUserId"] = facebookUserId
        }
        
        if displayName != nil {
            user["displayName"] = displayName
        }
        
        user.signUpInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                EventService.logSuccess("User created")
            } else {
                EventService.logError(error!, description: "User could not be created", object: "UserService", function: "createUser")
            }
        }
    }
    
    func loginUser(username: String, password: String) -> (success: Bool, error: String!) {
        PFUser.logInWithUsername(username, password: password)
        
        if PFUser.currentUser() == nil {
            return (false, "Login failed")
        }
        
        return (true, nil)
    }
    
    func updateStats(userObject: PFUser, puzzle: Puzzle) {
        let puzzleCompleted = puzzle.status == Status.Complete ? 1 : 0
        let puzzleTimeUp = puzzle.status == Status.TimeUp ? 1 : 0
        let puzzleGaveUp = puzzle.status == Status.GaveUp ? 1 : 0
        let hintsUsed = puzzle.hintsUsed
        let secondsPlayed = MAX_TIME - puzzle.time
        let fourStar = puzzle.currentStars == 4 ? 1 : 0
        let threeStar = puzzle.currentStars == 3 ? 1 : 0
        let twoStar = puzzle.currentStars == 2 ? 1 : 0
        let oneStar = puzzle.currentStars == 1 ? 1 : 0
        
        let stats = self.getStats(userObject)
        
        userObject["totalPuzzlesCompleted"] = stats.totalPuzzlesCompleted + puzzleCompleted
        userObject["totalPuzzlesTimeUp"] = stats.totalPuzzlesTimeUp + puzzleTimeUp
        userObject["totalPuzzlesGaveUp"] = stats.totalPuzzlesGaveUp + puzzleGaveUp
        userObject["totalHintsUsed"] = stats.totalHintsUsed + hintsUsed
        userObject["totalSecondsPlayed"] = stats.totalSecondsPlayed + secondsPlayed
        userObject["fourStarsEarned"] = stats.fourStarsEarned + fourStar
        userObject["threeStarsEarned"] = stats.threeStarsEarned + threeStar
        userObject["twoStarsEarned"] = stats.twoStarsEarned + twoStar
        userObject["oneStarsEarned"] = stats.oneStarsEarned + oneStar
        
        userObject.saveEventually()
    }
    
    func getStats(userObject: PFUser) -> Statistics {
        let stats = Statistics()
        
        stats.totalPuzzlesCompleted = userObject["totalPuzzlesCompleted"] == nil ? 0 : userObject["totalPuzzlesCompleted"] as! Int
        stats.totalPuzzlesTimeUp = userObject["totalPuzzlesTimeUp"] == nil ? 0 : userObject["totalPuzzlesTimeUp"] as! Int
        stats.totalPuzzlesGaveUp = userObject["totalPuzzlesGaveUp"] == nil ? 0 : userObject["totalPuzzlesGaveUp"] as! Int
        stats.totalHintsUsed = userObject["totalHintsUsed"] == nil ? 0 : userObject["totalHintsUsed"] as! Int
        stats.totalSecondsPlayed = userObject["totalSecondsPlayed"] == nil ? 0 : userObject["totalSecondsPlayed"] as! Int
        stats.fourStarsEarned = userObject["fourStarsEarned"] == nil ? 0 : userObject["fourStarsEarned"] as! Int
        stats.threeStarsEarned = userObject["threeStarsEarned"] == nil ? 0 : userObject["threeStarsEarned"] as! Int
        stats.twoStarsEarned = userObject["twoStarsEarned"] == nil ? 0 : userObject["twoStarsEarned"] as! Int
        stats.oneStarsEarned = userObject["oneStarsEarned"] == nil ? 0 : userObject["oneStarsEarned"] as! Int
        
        return stats
    }
}