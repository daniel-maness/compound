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
    let maxTime = 60
    
    private var puzzleDA: PuzzleDA
    private var challengeDA: ChallengeDA
    
    var puzzleId: Int
    var userPuzzleId: Int!
    var keyword: Word
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
        self.puzzleDA = PuzzleDA()
        self.challengeDA = ChallengeDA()
        self.puzzleId = 0
        self.combinations = [Combination]()
        self.keyword = Word(id: 0, name: "")
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
        self.time = maxTime
    }
    
    func resetPuzzle() {
        self.guesses = [Guess]()
        self.hintsUsed = 0
        self.currentHint = ""
        self.points = 0
        self.ended = false
        self.time = maxTime
        self.status = Status.Incomplete
    }
    
    func save() {
        if let userPuzzleId = puzzleDA.savePuzzle(self) {
            self.userPuzzleId = userPuzzleId
        }
    }
    
    func newPuzzle() {
//        let adminDA = AdminDA()
//        adminDA.populateWordTable()
//        syncHelper.syncPuzzleData()
//        adminDA.populateCombinationTable()
//        adminDA.generatePuzzles()
        let newPuzzle = puzzleDA.getNewPuzzle()
        
        self.puzzleId = newPuzzle.puzzleId
        self.keyword = newPuzzle.keyword
        self.combinations = newPuzzle.combinations
        
        resetPuzzle()
    }
    
//    func loadPuzzle(puzzleId: Int) {
//        let puzzle = puzzleDA.getPuzzle(puzzleId, userPuzzleId: nil)
//        
//        self.puzzleId = puzzle.puzzleId
//        self.keyword = puzzle.keyword
//        self.combinations = puzzle.combinations
//        
//        resetPuzzle()
//    }
    
    func useHint() {
        if self.hintsUsed < maxHints {
            self.hintsUsed++
        }
        
        var hint = ""

        if self.hintsUsed == 1 {
            hint = "____"
        } else if self.hintsUsed == 2 {
            for i in 0..<count(self.keyword.Name) {
                hint += " _"
            }
        } else if self.hintsUsed == 3 {
            hint = self.keyword.Name.subStringTo(1)
            for i in 1..<count(self.keyword.Name) {
                hint += " _"
            }
        }
        
        self.currentHint = hint
    }
    
    func checkAnswer(answer: String) -> Bool {
        let newGuess = Guess(description: answer, submitTime: DateTime.now())
        self.guesses.append(newGuess)
        
        if answer.uppercaseString == self.keyword.Name.uppercaseString {
            return true
        } else {
            return false
        }
    }
}