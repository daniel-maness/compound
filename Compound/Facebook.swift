//
//  Facebook.swift
//  Compound
//
//  Created by Daniel Maness on 7/21/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class Facebook {
    class func getFriends(friendsWithApp: Bool, completion: (result: [Friend], error: NSError!) -> Void) {
        var friends = [Friend]()
        let friendType = friendsWithApp ? "friends" : "taggable_friends"
        let urlPath = "/me/\(friendType)?fields=id,name,picture"
        var totalFriends = 0
        
        var friendCount: Int = 0 {
            didSet {
                if friendCount == totalFriends {
                    completion(result: friends, error: nil)
                }
            }
        }
        
        var fbRequest = FBSDKGraphRequest(graphPath:"/me/\(friendType)?fields=id,name,picture", parameters: nil);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                var resultDict = result as! NSDictionary
                var data: NSArray = resultDict.objectForKey("data") as! NSArray
                totalFriends = data.count
                
                if data.count == 0 {
                    println("No friends found")
                } else {
                    for i in 0..<data.count {
                        let valueDict = data[i] as! NSDictionary
                        let id = valueDict.objectForKey("id") as! String
                        let name = valueDict.objectForKey("name") as! String
                        let pictureDict = valueDict.objectForKey("picture") as! NSDictionary
                        let pictureData = pictureDict.objectForKey("data") as! NSDictionary
                        let pictureUrl = pictureData.objectForKey("url") as! String
                        
                        var friend = Friend()
                        friend.id = id
                        friend.displayName = name
                        friend.profilePictureUrl = pictureUrl
                        
                        self.loadFriendPicture(pictureUrl, completion: { (result: UIImage, error: NSError!) -> Void in
                            if error == nil {
                                friend.profilePicture = result
                                friends.append(friend)
                                friendCount++
                            } else {
                                println("Error getting friend picture \(error)");
                            }
                        })
                    }
                }
            } else {
                println("Error getting friends \(error)");
            }
        }
    }
    
    class func loadFriendPicture(url: String, completion: (result: UIImage, error: NSError!) -> Void) {
        let urlRequest = NSURLRequest(URL: NSURL(string: url)!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error == nil {
                completion(result: UIImage(data: data)!, error: error)
            } else {
                completion(result: UIImage(named: PROFILE_PICTURE)!, error: error)
            }
        }
    }
    
    class func loadProfilePicture(facebookUserId: String) {
        let url = NSURL(string: "https://graph.facebook.com/\(facebookUserId)/picture?type=normal")
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            // Display the image
            if error == nil {
                let image = UIImage(data: data)
                currentUser.profilePicture = image
            } else {
                currentUser.profilePicture = UIImage(named: PROFILE_PICTURE)
            }
        }
    }
}