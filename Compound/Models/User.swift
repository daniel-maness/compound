//
//  UserData.swift
//  Compound
//
//  Created by Daniel Maness on 4/18/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation
import Parse

class User {
    let USERNAME: String = "dmaness"
    private var userDA = UserDA()
    private var challengeDA = ChallengeDA()
    var parseUser: PFObject!
    var friends: [PFObject]!
    var facebookUserId: String!
    var parseUserId: String!
    var profilePicture: UIImage!
    
    let userId: Int
    
    init() {
        self.userId = 3
        //loadParseUser()
        //loadFriends()
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
    
    func loadParseUser() {
        let result = PFQuery(className: "User").whereKey("username", equalTo: "dmaness").findObjects()
        let json: AnyObject! = result?.first
        
        if let user = json as? PFObject {
            self.parseUser = user
        }
    }
    
    func loadFriends() {
        let results = PFQuery(className: "UserFriend").whereKey("user", equalTo: self.parseUser).findObjects()
        
        for r in results! {
            let result = PFQuery(className: "User").whereKey("objectId", equalTo: r["objectId"]).findObjects()
            let json: AnyObject? = result?.first
            
            if let friend = json as? PFObject {
                self.friends.append(friend)
            }
        }
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
    
    func savePuzzleStats(puzzle: Puzzle) {
        
    }
}

var currentUser: User!