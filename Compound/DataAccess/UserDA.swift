//
//  UserDA.swift
//  Compound
//
//  Created by Daniel Maness on 4/29/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation
import Parse
import FBSDKCoreKit

class UserDA {
    func userExists(username: String) -> Bool {
        let query = PFUser.query()!.whereKey("username", equalTo: username)
        let user = query.findObjects()?.first as! PFObject!
        
        return user != nil && username == user["username"] as! String
    }
    
    func createUser(facebookUserId: String!, username: String, password: String, email: String!) {
        var user = PFUser()
        
        user.username = username
        user.password = password
        user.email = email
        
        if facebookUserId != nil {
            user["facebookUserId"] = facebookUserId
        }
        
        user.signUpInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if error == nil {
                println("User created")
            } else {
                println("Error creating user")
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
    
    func updateStats(puzzle: Puzzle) {
        let puzzleCompleted = puzzle.status == Status.Complete ? 1 : 0
        let puzzleTimeUp = puzzle.status == Status.TimeUp ? 1 : 0
        let puzzleGaveUp = puzzle.status == Status.GaveUp ? 1 : 0
        let hintsUsed = puzzle.hintsUsed
        let secondsPlayed = MAX_TIME - puzzle.time
        let fourStar = puzzle.currentStars == 4 ? 1 : 0
        let threeStar = puzzle.currentStars == 3 ? 1 : 0
        let twoStar = puzzle.currentStars == 2 ? 1 : 0
        let oneStar = puzzle.currentStars == 1 ? 1 : 0
        
        let stats = self.getStats(currentUser.userId)
        var user = PFUser.currentUser()!
        
        user["totalPuzzlesCompleted"] = stats.totalPuzzlesCompleted + puzzleCompleted
        user["totalPuzzlesTimeUp"] = stats.totalPuzzlesTimeUp + puzzleTimeUp
        user["totalPuzzlesGaveUp"] = stats.totalPuzzlesGaveUp + puzzleGaveUp
        user["totalHintsUsed"] = stats.totalHintsUsed + hintsUsed
        user["totalSecondsPlayed"] = stats.totalSecondsPlayed + secondsPlayed
        user["fourStarsEarned"] = stats.fourStarsEarned + fourStar
        user["threeStarsEarned"] = stats.threeStarsEarned + threeStar
        user["twoStarsEarned"] = stats.twoStarsEarned + twoStar
        user["oneStarsEarned"] = stats.oneStarsEarned + oneStar
        
        user.saveEventually()
    }
    
    func getStats(userId: String) -> Statistics {
        var user = PFUser.currentUser()!
        var stats = Statistics()
        
        stats.totalPuzzlesCompleted = user["totalPuzzlesCompleted"] == nil ? 0 : user["totalPuzzlesCompleted"] as! Int
        stats.totalPuzzlesTimeUp = user["totalPuzzlesTimeUp"] == nil ? 0 : user["totalPuzzlesTimeUp"] as! Int
        stats.totalPuzzlesGaveUp = user["totalPuzzlesGaveUp"] == nil ? 0 : user["totalPuzzlesGaveUp"] as! Int
        stats.totalHintsUsed = user["totalHintsUsed"] == nil ? 0 : user["totalHintsUsed"] as! Int
        stats.totalSecondsPlayed = user["totalSecondsPlayed"] == nil ? 0 : user["totalSecondsPlayed"] as! Int
        stats.fourStarsEarned = user["fourStarsEarned"] == nil ? 0 : user["fourStarsEarned"] as! Int
        stats.threeStarsEarned = user["threeStarsEarned"] == nil ? 0 : user["threeStarsEarned"] as! Int
        stats.twoStarsEarned = user["twoStarsEarned"] == nil ? 0 : user["twoStarsEarned"] as! Int
        stats.oneStarsEarned = user["oneStarsEarned"] == nil ? 0 : user["oneStarsEarned"] as! Int
        
        return stats
    }
}