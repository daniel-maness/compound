//
//  FacebookManager.swift
//  Compound
//
//  Created by Daniel Maness on 7/31/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation
import SpriteKit

class FacebookManager {
    private let facebookService = FacebookService()
    
    init() {
        
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
}