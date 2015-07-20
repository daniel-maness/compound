//
//  UserData.swift
//  Compound
//
//  Created by Daniel Maness on 4/18/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

var currentUser: User!

enum UserType: Int {
    case Email = 0, Facebook
}

class Statistics {
    var totalPuzzlesCompleted: Int!
    var totalPuzzlesTimeUp: Int!
    var totalPuzzlesGaveUp: Int!
    var totalHintsUsed: Int!
    var totalSecondsPlayed: Int!
    var fourStarsEarned: Int!
    var threeStarsEarned: Int!
    var twoStarsEarned: Int!
    var oneStarsEarned: Int!
    
    var totalPuzzlesPlayed: Int {
        return totalPuzzlesCompleted + totalPuzzlesGaveUp + totalPuzzlesTimeUp
    }
    
    var totalStarsEarned: Int {
        return fourStarsEarned * 4 + threeStarsEarned * 3 + twoStarsEarned * 2 + oneStarsEarned
    }
    
    var averageStars: Double {
        return totalPuzzlesPlayed == 0 ? 0.0 : Double(totalStarsEarned) / 4.0 / Double(totalPuzzlesPlayed)
    }
    
    var averageTime: Int {
        return totalPuzzlesPlayed == 0 ? 0 : totalSecondsPlayed / totalPuzzlesPlayed
    }
    
    init() {
        
    }
}

class User: NSObject {
    private var userDA = UserDA()
    private var challengeDA = ChallengeDA()
    
    var userType: UserType!
    var profilePicture: UIImage!
    var friends: [PFObject]!
    
    var userId: String! {
        return PFUser.currentUser()?.objectId
    }
    
    var facebookUserId: String! {
        return PFUser.currentUser()?.objectForKey("facebookUserId") as! String
    }
    
    var email: String! {
        return PFUser.currentUser()?.email
    }
    
    override init() {
        super.init()
        
        userDA.loadFacebookProfilePicture(self.facebookUserId)
    }
    
    func getPersonalStats() -> (totalStars: Int, totalPuzzles: Int, totalWon: Int, averageStars: Double, totalHints: Int, averageTime: Int) {
        let totalStars = getTotalStars()
        let totalPuzzles = getPuzzleCount(nil)
        let totalWon = getPuzzleCount(Status.Complete)
        let averageStars = getAverageStars()
        let totalHints = getHintCount()
        let averageTime = getAverageTime()
        
        return (totalStars, totalPuzzles, totalWon, averageStars, totalHints, averageTime)
    }
    
    func getVersusStats() {
        
    }
    
    func getBestOfStats() {
        
    }
    
    func getTotalStars() -> Int {
        return userDA.getTotalStars(self.userId)
    }
    
    func getPuzzleCount(status: Status!) -> Int {
        return userDA.getPuzzleCount(self.userId, status: status)
    }
    
    func getAverageStars() -> Double {
        return userDA.getAverageStars(self.userId)
    }
    
    func getHintCount() -> Int {
        return userDA.getHintCount(self.userId)
    }
    
    func getAverageTime() -> Int {
        return userDA.getAverageTime(self.userId)
    }
    
    func getFriendsList() -> [Friend] {
        return userDA.getFriendsList(self.userId)
    }
    
    func getChallengesReceived() -> [Challenge] {
        return challengeDA.getChallengesReceived(self.userId)
    }
    
    func getStats() -> Statistics {
        return userDA.getStats(self.userId)
    }
    
    func updateStats(puzzle: Puzzle) {
        userDA.updateStats(puzzle)
    }
}