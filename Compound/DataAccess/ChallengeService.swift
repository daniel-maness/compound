//
//  ChallengeService.swift
//  Compound
//
//  Created by Daniel Maness on 5/7/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation
import Parse

class ChallengeService {
    private let userService = UserService()
    private let puzzleService = PuzzleService()
    
    private func createUserChallenge(puzzle: Puzzle, facebookUserId: String, completion: (result: String!, error: NSError!) -> Void) {
        let challenge = PFObject(className: CHALLENGE_CLASSNAME)
        PFUser.query()?.whereKey("facebookUserId", equalTo: facebookUserId).getFirstObjectInBackgroundWithBlock { (userObject: PFObject?, error: NSError?) -> Void in
            if error == nil && userObject != nil {
                println("1a. User exists")
                challenge.setObject(userObject!, forKey: "userObject")
                
                challenge["hintsUsed"] = puzzle.hintsUsed
                challenge["totalSeconds"] = puzzle.time
                challenge["keyword"] = puzzle.keyword
                challenge["word1"] = puzzle.combinations[0].combinedWord
                challenge["word2"] = puzzle.combinations[1].combinedWord
                challenge["word3"] = puzzle.combinations[2].combinedWord
                challenge["isActive"] = true
                
                challenge.saveInBackgroundWithBlock { (success, error) -> Void in
                    if error == nil {
                        println("1b. User challenge saved")
                        completion(result: challenge.objectId!, error: nil)
                    } else {
                        println("Error saving user challenge: " + error!.description)
                        completion(result: nil, error: error)
                    }
                }
            } else {
                println("Error retrieving user for challenge: " + error!.description)
            }
        }
    }

    private func createFriendChallenge(puzzle: Puzzle, facebookUserId: String, challengeObjectId: String, completion: (result: String!, error: NSError!) -> Void) {
        let challenge = PFObject(className: CHALLENGE_CLASSNAME)
        PFUser.query()?.whereKey("facebookUserId", equalTo: facebookUserId).getFirstObjectInBackgroundWithBlock { (userObject: PFObject?, error: NSError?) -> Void in
            if error == nil && userObject != nil {
                println("2a. Friend exists")
                challenge.setObject(userObject!, forKey: "userObject")
                PFQuery(className: CHALLENGE_CLASSNAME).whereKey("objectId", equalTo: challengeObjectId).getFirstObjectInBackgroundWithBlock { (challengeObject: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        println("2b. Challenge exists")
                        challenge.setObject(challengeObject!, forKey: "parentChallengeObject")
                        
                        challenge["keyword"] = puzzle.keyword
                        challenge["word1"] = puzzle.combinations[0].combinedWord
                        challenge["word2"] = puzzle.combinations[1].combinedWord
                        challenge["word3"] = puzzle.combinations[2].combinedWord
                        challenge["isActive"] = true
                        
                        challenge.saveInBackgroundWithBlock { (success, error) -> Void in
                            if error == nil {
                                println("2c. Challenge saved")
                                completion(result: challenge.objectId!, error: nil)
                            } else {
                                completion(result: nil, error: error)
                            }
                        }
                    } else {
                        println("Error saving challenge: " + error!.description)
                    }
                }
            }
        }
    }
    
    func sendChallenges(puzzle: Puzzle, friendIds: [String], challengeTime: String) {
        self.createUserChallenge(puzzle, facebookUserId: currentUser.facebookUserId, completion: { (result: String!, error: NSError!) -> Void in
            if error == nil {
                for id in friendIds {
                    self.createFriendChallenge(puzzle, facebookUserId: id, challengeObjectId: result, completion: { (result: String!, error: NSError!) -> Void in
                        if error == nil {
                            println("3. Challenge sent to: " + id + " with objectId of: " + result)
                        } else {
                            println("Error sending challenge: " + error.description)
                        }
                    })
                }
            } else {
                println("Error saving challenge: " + error.description)
            }
        })
    }
    
    func getChallengesReceived(userId: String, completion: (result: [PFObject], error: NSError?) -> Void) {
        let query = PFQuery(className: CHALLENGE_CLASSNAME)
        query.whereKey("userObject", equalTo: PFUser.currentUser()!)
        query.whereKey("parentChallengeObject", notEqualTo: NSNull())
        query.includeKey("userObject")
        query.includeKey("parentChallengeObject")
        query.includeKey("parentChallengeObject.userObject")
        
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            var challenges = [PFObject]()
            if error == nil {
                for i in 0..<results!.count {
                    let challenge = results?[i] as! PFObject
                    challenges.append(challenge)
                    println("Challenge " + challenge.objectId! + " fetched")
                }
            } else {
                println("Error fetching Parse Challenge objects: " + error!.description)
            }
            
            completion(result: challenges, error: error)
        }
    }
    
    func getChallengesSent(userId: String) {
        
    }
}