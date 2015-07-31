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

class User: NSObject {
    private var userService = UserService()
    private var challengeService = ChallengeService()
    private var facebookService = FacebookService()
    
    var userType: UserType!
    var profilePicture: UIImage!
    var friends: [Friend]!
    var facebookUserId: String!
    var displayName: String!
    
    var userId: String! {
        return PFUser.currentUser()?.objectId
    }
    
    var email: String! {
        return PFUser.currentUser()?.email
    }
    
    override init() {
        super.init()
        
        self.facebookUserId = PFUser.currentUser()?.objectForKey("facebookUserId") == nil ? nil : PFUser.currentUser()?.objectForKey("facebookUserId") as! String
        self.friends = [Friend]()
        self.updateProfilePictureAsync()
    }
    
    init(pfObject: PFObject) {
        super.init()
        
        self.facebookUserId = pfObject["facebookUserId"] as! String
        self.displayName = pfObject["displayName"] as! String
        self.updateProfilePicture()
    }
    
    func updateProfilePictureAsync() {
        facebookService.loadProfilePictureAsync(self.facebookUserId, completion: { (result, error) -> Void in
            if error == nil {
                self.profilePicture = result
                println("Profile picture loaded")
            } else {
                self.profilePicture = UIImage(named: PROFILE_PICTURE)
                println("Error loading facebook profile picture: " + error.description)
            }
        })
    }
    
    func updateProfilePicture() {
        facebookService.loadProfilePicture(self.facebookUserId, completion: { (result, error) -> Void in
            if error == nil {
                self.profilePicture = result
                println("Profile picture loaded")
            } else {
                self.profilePicture = UIImage(named: PROFILE_PICTURE)
                println("Error loading facebook profile picture: " + error.description)
            }
        })
    }
    
    func getVersusStats() {
        
    }
    
    func getBestOfStats() {
        
    }
    
    func getFacebookFriends(friendsWithApp: Bool, completion: (result: [Friend], error: NSError!) -> Void) {
        facebookService.getFriends(friendsWithApp, completion: { (result, error) -> Void in
            var friends = [Friend]()
            
            for i in 0..<result.count {
                let valueDict = result[i] as Dictionary
                let friend = Friend(facebookUserId: valueDict["facebookUserId"] as! String)
                friend.displayName = valueDict["name"] as! String
                friend.profilePictureUrl = valueDict["profilePictureUrl"] as! String
                friend.profilePicture = valueDict["profilePicture"] as! UIImage
                friends.append(friend)
            }
            
            completion(result: friends, error: error)
        })
    }
    
    func getChallengesReceived(completion: (result: [Challenge], error: NSError?) -> Void) {
        challengeService.getChallengesReceived(self.userId, completion: { (results, error) -> Void in
            var challenges = [Challenge]()
            if error == nil {
                for i in 0..<results.count {
                    let challenge = Challenge(pfObject: results[i])
                    challenges.append(challenge)
                    println("Challenge " + challenge.objectId + " added")
                }
            } else {
                println("Error getting challenges received: " + error!.description)
            }
            
            completion(result: challenges, error: error)
        })
    }
    
    func getStats() -> Statistics {
        return userService.getStats(self.userId)
    }
    
    func updateStats(puzzle: Puzzle) {
        userService.updateStats(puzzle)
    }
}