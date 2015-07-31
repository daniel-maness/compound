//
//  Challenge.swift
//  Compound
//
//  Created by Daniel Maness on 5/9/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation
import Parse

class Challenge {
    var objectId: String
    var user: User
    var puzzle: Puzzle
    var parentChallenge: Challenge!
    var status: Status
    private var challengeService = ChallengeService()
    
    init(objectId: String, puzzle: Puzzle, user: User, parentChallenge: Challenge!) {
        self.objectId = objectId
        self.user = user
        self.puzzle = puzzle
        self.parentChallenge = parentChallenge!
        self.status = parentChallenge == nil ? Status.Complete : Status.Incomplete
    }
    
    init(pfObject: PFObject) {
        self.objectId = pfObject.objectId!
        
        // Initialize the user
        self.user = User(pfObject: pfObject["userObject"] as! PFObject)
        
        // Initialize the puzzle
        let puzzle = Puzzle()
        puzzle.keyword = pfObject["keyword"] as! String
        puzzle.combinations.append(Combination(keyword: puzzle.keyword, combinedWord: pfObject["word1"] as! String))
        puzzle.combinations.append(Combination(keyword: puzzle.keyword, combinedWord: pfObject["word2"] as! String))
        puzzle.combinations.append(Combination(keyword: puzzle.keyword, combinedWord: pfObject["word3"] as! String))
        self.puzzle = puzzle
        
        // Initialize the parent challenge, if it exists
        if let parentChallengeObject = pfObject["parentChallengeObject"] as? PFObject {
            let parentUserObject = parentChallengeObject["userObject"] as! PFObject
            self.parentChallenge = Challenge(pfObject: parentChallengeObject)
            self.status = Status.Incomplete
        } else {
            self.status = Status.Complete
        }
    }
    
    func save() {
        
    }
}