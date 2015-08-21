//
//  ChallengeManager.swift
//  Compound
//
//  Created by Daniel Maness on 7/31/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation

class ChallengeManager {
    private let challengeService = ChallengeService()
    
    init() {
        
    }
    
    func getChallengesReceived(completion: (result: [Challenge], error: NSError?) -> Void) {
        challengeService.getChallengesReceived(CurrentUser.objectId, completion: { (results, error) -> Void in
            var challenges = [Challenge]()
            if error == nil {
                for i in 0..<results.count {
                    let challenge = Challenge(pfObject: results[i])
                    challenges.append(challenge)
                }
            } else {
                EventService.logError(error!, description: "Challenges Received could not be fetched", object: "User", function: "getChallengesRecieved")
            }
            
            completion(result: challenges, error: error)
        })
    }
    
    func getChallengesSent(completion: (result: [Challenge], error: NSError?) -> Void) {
        challengeService.getChallengesSent(CurrentUser.objectId, completion: { (results, error) -> Void in
            var challenges = [Challenge]()
            if error == nil {
                for i in 0..<results.count {
                    let challenge = Challenge(pfObject: results[i])
                    challenges.append(challenge)
                }
            } else {
                EventService.logError(error!, description: "Challenges Sent could not be fetched", object: "User", function: "getChallengesRecieved")
            }
            
            completion(result: challenges, error: error)
        })
    }
    
    func sendChallenges(puzzle: Puzzle, friendIds: [String]) {
        challengeService.sendChallenges(CurrentUser.objectId, puzzle: puzzle, friendIds: friendIds)
    }
    
    func completeChallenge(challenge: Challenge) {
        challengeService.completeChallenge(challenge.objectId, hintsUsed: challenge.puzzle.hintsUsed, time: challenge.puzzle.time)
    }
    
    func markChallengeInactive(challenge: Challenge) {
        challengeService.markChallengeInactive(challenge.objectId)
    }
}