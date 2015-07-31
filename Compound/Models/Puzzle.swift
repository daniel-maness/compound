//
//  Puzzle.swift
//  Compound
//
//  Created by Daniel Maness on 11/13/14.
//  Copyright (c) 2014 Daniel Maness. All rights reserved.
//

import Foundation
import UIKit

enum Status: Int {
    case Incomplete = 0, Complete, TimeUp, GaveUp
}

class Guess {
    var guessId: Int
    var userPuzzleId: Int
    var description: String
    var submitTime: String
    
    init(description: String, submitTime: String) {
        self.guessId = 0
        self.userPuzzleId = 0
        self.description = description
        self.submitTime = submitTime
    }
}

class Puzzle {
    let maxHints: Int = 3
    let maxStars: Int = 4
    let minStars: Int = 1
    
    private var puzzleService: PuzzleService
    private var challengeService: ChallengeService
    
    var puzzleId: Int
    var userPuzzleId: Int!
    var keyword: String
    var combinations: [Combination]
    var guesses: [Guess]
    var hintTime1: String
    var hintTime2: String
    var hintTime3: String
    var startTime: String
    var endTime: String
    var status: Status
    
    var hintsUsed: Int
    var currentHint: String
    var points: Int
    var ended: Bool
    var time: Int
    
    var currentStars: Int {
        return self.maxStars - self.hintsUsed
    }
    
    init() {
        self.puzzleService = PuzzleService()
        self.challengeService = ChallengeService()
        self.puzzleId = 0
        self.combinations = [Combination]()
        self.keyword = ""
        self.guesses = [Guess]()
        self.hintTime1 = ""
        self.hintTime2 = ""
        self.hintTime3 = ""
        self.startTime = ""
        self.endTime = ""
        self.status = Status.Incomplete
        
        self.currentHint = ""
        self.hintsUsed = 0
        self.points = 0
        self.ended = false
        self.time = MAX_TIME
    }
    
    func resetPuzzle() {
        self.guesses = [Guess]()
        self.hintsUsed = 0
        self.currentHint = ""
        self.points = 0
        self.ended = false
        self.time = MAX_TIME
        self.status = Status.Incomplete
    }
    
    func newPuzzle() {
//        let adminService = AdminService()
//        adminService.populateWordTable()
//        adminService.populateCombinationTable()
//        adminService.generatePuzzles()
        let newPuzzle = puzzleService.getPuzzle(nil)
        
        self.puzzleId = newPuzzle.puzzleId
        self.keyword = newPuzzle.keyword
        self.combinations = newPuzzle.combinations
        
        resetPuzzle()
    }
    
    func useHint() {
        if self.hintsUsed < maxHints {
            self.hintsUsed++
        }
        
        var hint = ""

        if self.hintsUsed == 1 {
            hint = "____"
        } else if self.hintsUsed == 2 {
            for i in 0..<count(self.keyword) {
                hint += " _"
            }
        } else if self.hintsUsed == 3 {
            hint = self.keyword.subStringTo(1)
            for i in 1..<count(self.keyword) {
                hint += " _"
            }
        }
        
        self.currentHint = hint
    }
    
    func checkAnswer(answer: String) -> Bool {
        let newGuess = Guess(description: answer, submitTime: DateTime.now())
        self.guesses.append(newGuess)
        
        if answer.uppercaseString == self.keyword.uppercaseString {
            return true
        } else {
            return false
        }
    }
}