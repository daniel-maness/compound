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
    
    private func createUserChallenge(userObjectId: String, puzzle: Puzzle, completion: (result: String!, error: NSError!) -> Void) {
        PFUser.query()?.whereKey("objectId", equalTo: userObjectId).getFirstObjectInBackgroundWithBlock { (userObject: PFObject?, error: NSError?) -> Void in
            if error == nil && userObject != nil {
                let challengeObject = PFObject(className: CHALLENGE_CLASSNAME)
                
                challengeObject.setObject(userObject!, forKey: "userObject")
                challengeObject["hintsUsed"] = puzzle.hintsUsed
                challengeObject["totalSeconds"] = puzzle.time
                challengeObject["keyword"] = puzzle.keyword
                challengeObject["word1"] = puzzle.combinations[0].combinedWord
                challengeObject["word2"] = puzzle.combinations[1].combinedWord
                challengeObject["word3"] = puzzle.combinations[2].combinedWord
                challengeObject["isActive"] = true
                
                challengeObject.saveInBackgroundWithBlock { (success, error) -> Void in
                    if error == nil {
                        completion(result: challengeObject.objectId!, error: nil)
                    } else {
                        EventService.logError(error!, description: "Error saving user challenge", object: "ChallengeService", function: "createUserChallenge")
                        completion(result: nil, error: error)
                    }
                }
            } else {
                EventService.logError(error!, description: "Error retrieving user for challenge", object: "ChallengeService", function: "createUserChallenge")
            }
        }
    }

    private func createFriendChallenge( facebookUserId: String, puzzle: Puzzle, challengeObjectId: String, completion: (result: String!, error: NSError!) -> Void) {
        let challenge = PFObject(className: CHALLENGE_CLASSNAME)
        PFUser.query()?.whereKey("facebookUserId", equalTo: facebookUserId).getFirstObjectInBackgroundWithBlock { (userObject: PFObject?, error: NSError?) -> Void in
            if error == nil && userObject != nil {
                challenge.setObject(userObject!, forKey: "userObject")
                PFQuery(className: CHALLENGE_CLASSNAME).whereKey("objectId", equalTo: challengeObjectId).getFirstObjectInBackgroundWithBlock { (challengeObject: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        challenge.setObject(challengeObject!, forKey: "parentChallengeObject")
                        
                        challenge["keyword"] = puzzle.keyword
                        challenge["word1"] = puzzle.combinations[0].combinedWord
                        challenge["word2"] = puzzle.combinations[1].combinedWord
                        challenge["word3"] = puzzle.combinations[2].combinedWord
                        challenge["isActive"] = true
                        
                        challenge.saveInBackgroundWithBlock { (success, error) -> Void in
                            if error == nil {
                                completion(result: challenge.objectId!, error: nil)
                            } else {
                                EventService.logError(error!, description: "Challenge failed to save for friend " + facebookUserId, object: "ChallengeService", function: "createFriendChallenge")
                                completion(result: nil, error: error)
                            }
                        }
                    } else {
                        EventService.logError(error!, description: "Could not fetch Challenge " + challengeObjectId, object: "ChallengeService", function: "createFriendChallenge")
                        completion(result: nil, error: error)
                    }
                }
            } else {
                EventService.logError(error!, description: "Could not fetch PFUser " + facebookUserId, object: "ChallengeService", function: "createFriendChallenge")
                completion(result: nil, error: error)
            }
        }
    }
    
    func sendChallenges(userObjectId: String, puzzle: Puzzle, friendIds: [String]) {
        self.createUserChallenge(userObjectId, puzzle: puzzle, completion: { (result: String!, error: NSError!) -> Void in
            if error == nil {
                for id in friendIds {
                    self.createFriendChallenge(id, puzzle: puzzle, challengeObjectId: result, completion: { (result: String!, error: NSError!) -> Void in
                        if error == nil {
                            EventService.logSuccess("Challenge sent to " + id)
                        } else {
                            EventService.logError(error!, description: "Challenge not created for friend " + id, object: "ChallengeService", function: "sendChallenge")
                        }
                    })
                }
            } else {
                EventService.logError(error!, description: "Challenge not created for user " + userObjectId, object: "ChallengeService", function: "sendChallenge")
            }
        })
    }
    
    func getChallengesReceived(userObjectId: String, completion: (result: [PFObject], error: NSError?) -> Void) {
        let userObjectQuery = PFQuery(className: USER_CLASSNAME)
        userObjectQuery.whereKey("objectId", equalTo: userObjectId)
        
        let query = PFQuery(className: CHALLENGE_CLASSNAME)
        query.includeKey("userObject")
        query.includeKey("parentChallengeObject")
        query.includeKey("parentChallengeObject.userObject")
        query.whereKey("userObject", matchesQuery: userObjectQuery)
        query.whereKey("parentChallengeObject", notEqualTo: NSNull())
        
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            var challenges = [PFObject]()
            if error == nil {
                for i in 0..<results!.count {
                    let challenge = results?[i] as! PFObject
                    challenges.append(challenge)
                }
            } else {
                EventService.logError(error!, description: "Challenges could not be fetched", object: "ChallengeService", function: "getChallengesRecieved")
            }
            
            completion(result: challenges, error: error)
        }
    }
    
    func getChallengesSent(userId: String) {
        
    }
}