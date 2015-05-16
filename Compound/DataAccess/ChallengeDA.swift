//
//  ChallengeDA.swift
//  Compound
//
//  Created by Daniel Maness on 5/7/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation
import Parse

class ChallengeDA {
    private let userDA = UserDA()
    private let puzzleDA = PuzzleDA()
    
    func sendChallenge(userPuzzleId: Int, friendId: Int, challengeTime: String) {
        let challenge = PFObject(className: "Challange")
        let challenger = currentUser.parseUser
        let friend = PFQuery(className: "User")
        //let db = SQLiteDB.sharedInstance()
        //db.execute("INSERT INTO Challenge (UserPuzzleId, FriendId, ChallengeTime) VALUES(" + String(userPuzzleId) + ", " + String(friendId) + ", '" + challengeTime + "')")
    }
    
    func sendChallenge(userPuzzleId: Int, friendIds: [Int], challengeTime: String) {
        for friendId in friendIds {
            sendChallenge(userPuzzleId, friendId: friendId, challengeTime: challengeTime)
        }
    }
    
    func getChallengesReceived(userId: Int) -> [Challenge]{
        let db = SQLiteDB.sharedInstance()
        let data = db.query("SELECT * FROM viChallenge c WHERE c.FriendId=?", parameters: [userId])
        
        var challengeList = [Challenge]()
        for row in data {
            let puzzle = puzzleDA.getPuzzle(row["PuzzleId"]!.asInt(), userPuzzleId: row["UserPuzzleId"]!.asInt())
            let friend = userDA.getFriend(row["UserId"]!.asInt())
            let friendPuzzle = puzzleDA.getPuzzle(row["PuzzleId"]!.asInt(), userPuzzleId: row["FriendPuzzleId"]!.asInt())
            var challenge = Challenge(challengeId: row["ChallengeId"]!.asInt(), puzzle: puzzle, friend: friend, friendPuzzle: friendPuzzle)
            challengeList.append(challenge)
        }
        
        return challengeList
    }
    
    func getChallengesSent(userId: Int) {
        
    }
    
    func saveChallenge(challenge: Challenge) {
        let db = SQLiteDB.sharedInstance()
        db.execute("UPDATE Challenge SET FriendPuzzleId = " + String(challenge.friendPuzzle.userPuzzleId) + " WHERE ChallengeId = " + String(challenge.challengeId))
    }
}