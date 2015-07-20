//
//  Challenge.swift
//  Compound
//
//  Created by Daniel Maness on 5/9/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation

class Challenge {
    var challengeId: Int
    var puzzle: Puzzle
    var friend: Friend
    var friendPuzzle: Puzzle!
    private var challengeDa: ChallengeDA
    
    init(challengeId: Int, puzzle: Puzzle, friend: Friend, friendPuzzle: Puzzle!) {
        self.challengeId = challengeId
        self.puzzle = puzzle
        self.friend = friend
        self.friendPuzzle = friendPuzzle
        
        self.challengeDa = ChallengeDA()
    }
    
    var status: Status {
        if self.friendPuzzle == nil || self.friendPuzzle.status == Status.Incomplete {
            return Status.Incomplete
        } else {
            return Status.Complete
        }
    }
    
    func save() {
        challengeDa.saveChallenge(self)
    }
}