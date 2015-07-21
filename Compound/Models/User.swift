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
    private var userDA = UserDA()
    private var challengeDA = ChallengeDA()
    
    var userType: UserType!
    var profilePicture: UIImage!
    //var friends: [PFObject]!
    var friends: [Friend]!
    var facebookUserId: String!
    
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
        self.updateProfilePicture()
    }
    
    func updateProfilePicture() {
        if self.facebookUserId != nil {
            Facebook.loadProfilePicture(self.facebookUserId)
        } else {
            self.profilePicture = UIImage(named: PROFILE_PICTURE)
        }
    }
    
    func getVersusStats() {
        
    }
    
    func getBestOfStats() {
        
    }
    
//    func getFriendsList(completionClosure: (success: Bool, error: NSError!) -> ()) -> [Friend] {
//        self.friends = [Friend]()
//        let results = userDA.getFriend
//        
//        return currentUser.friends
//    }
    
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