//
//  FacebookService.swift
//  Compound
//
//  Created by Daniel Maness on 7/21/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class FacebookService {
    func getFriends(friendsWithApp: Bool, completion: (result: [Dictionary<String,NSObject>], error: NSError!) -> Void) {
        var friends = [Dictionary<String,NSObject>]()
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
                    EventService.logEvent("No Facebook friends found")
                } else {
                    for i in 0..<data.count {
                        let valueDict = data[i] as! NSDictionary
                        let id = valueDict.objectForKey("id") as! String
                        let name = valueDict.objectForKey("name") as! String
                        let pictureDict = valueDict.objectForKey("picture") as! NSDictionary
                        let pictureData = pictureDict.objectForKey("data") as! NSDictionary
                        let pictureUrl = pictureData.objectForKey("url") as! String
                        
                        self.loadProfilePictureFromUrl(pictureUrl, completion: { (result: UIImage!, error: NSError!) -> Void in
                            if error == nil {
                                let friend = ["facebookUserId": id,
                                            "name": name,
                                            "profilePictureUrl": pictureUrl,
                                            "profilePicture": result]
                                
                                friends.append(friend)
                                friendCount++
                            } else {
                                EventService.logError(error!, description: "Facebook picture could not be fetched for " + id, object: "FacebookService", function: "getFriends")
                            }
                        })
                    }
                }
            } else {
                EventService.logError(error!, description: "Facebook friends could not be fetched", object: "FacebookService", function: "getFriends")
            }
        }
    }
    
    func getUserInfoAsync(facebookUserId: String, completion: (result: Dictionary<String, NSObject>!, error: NSError!) -> Void) {
        FBSDKGraphRequest(graphPath: facebookUserId, parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
            if error == nil {
                EventService.logSuccess("Facebook user info fetched for " + facebookUserId)
                let userInfo = ["facebookUserId": result.valueForKey("id") as! String,
                                "name": result.valueForKey("name") as! String]
                
                completion(result: userInfo, error: nil)
            } else {
                EventService.logError(error!, description: "Facebook user info could not be fetched for " + facebookUserId, object: "FacebookService", function: "getUseInfoAsync")
                completion(result: nil, error: error)
            }
        })
    }
    
    func getUserInfo(facebookUserId: String) -> Dictionary<String, String>! {
        var userInfo = Dictionary<String, String>()
        var isFinished = false {
            didSet {
                if isFinished {
                    dispatch_async(dispatch_get_main_queue(), {
                        return userInfo
                    })
                }
            }
        }
        
        FBSDKGraphRequest(graphPath: facebookUserId, parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
            if error == nil {
                EventService.logSuccess("Facebook user info fetched for " + facebookUserId)
                userInfo = ["facebookUserId": result.valueForKey("id") as! String,
                            "name": result.valueForKey("name") as! String]
            } else {
                EventService.logError(error!, description: "Facebook user info could not be fetched for " + facebookUserId, object: "FacebookService", function: "getUseInfo")
            }
            
            isFinished = true
        })
        
        return nil
    }
    
    func loadProfilePictureFromUrl(url: String, completion: (result: UIImage!, error: NSError!) -> Void) {
        let urlRequest = NSURLRequest(URL: NSURL(string: url)!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error == nil {
                completion(result: UIImage(data: data)!, error: nil)
            } else {
                completion(result: nil, error: error)
            }
        }
    }
    
    func loadProfilePictureAsync(facebookUserId: String, completion: (result: NSData!, error: NSError!) -> Void) {
        let url = NSURL(string: "https://graph.facebook.com/\(facebookUserId)/picture?type=normal")
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error == nil {
                completion(result: data, error: nil)
            } else {
                completion(result: nil, error: error)
            }
        }
    }
    
    func loadProfilePicture(facebookUserId: String) -> (data: NSData!, error: NSError!) {
        let url = NSURL(string: "http://graph.facebook.com/\(facebookUserId)/picture?type=normal")
        let urlRequest = NSURLRequest(URL: url!)
        var response: NSURLResponse?
        var error: NSError?
        
        let result = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response, error: &error)
        
        if error == nil {
            return (result, nil)
        } else {
            EventService.logError(NSError(), description: "Could not load Facebook profile picture synchronously for \(facebookUserId)", object: "FacebookService", function: "loadProfilePicture")
            return (nil, NSError())
        }
    }
}