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

class Puzzle {
    let maxHints: Int = 3
    let maxStars: Int = 4
    let minStars: Int = 1
    let maxTime = 60
    
    private var puzzleDA: PuzzleDA
    
    var puzzleId: Int
    var keyword: Word
    var combinations: [Combination]
    var guesses: [String]
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
        self.puzzleId = 0
        self.combinations = [Combination]()
        self.keyword = Word(id: 0, name: "")
        self.guesses = [String]()
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
    
//    init(puzzleId: String) {
//        self.puzzleDA = PuzzleDA()
//        
//        self.new
//        
//        self.guesses = [String]()
//        self.currentHint = ""
//        self.hintsUsed = 0
//        self.points = 0
//        self.ended = false
//        self.time = maxTime
//        self.status = Status.Incomplete
//    }
    
    func resetPuzzle() {
        self.guesses = [String]()
        self.hintsUsed = 0
        self.currentHint = ""
        self.points = 0
        self.ended = false
        self.time = maxTime
        self.status = Status.Incomplete
    }
    
    func save() {
        puzzleDA.savePuzzle(self)
    }
    
    func newPuzzle() {
//        puzzleDA.populateWordTable()
//        puzzleDA.populateCombinationTable()
//        puzzleDA.generatePuzzles()
        let newPuzzle = puzzleDA.getNewPuzzle()
        
        self.puzzleId = newPuzzle.puzzleId
        self.keyword = newPuzzle.keyword
        self.combinations = newPuzzle.combinations
        
        resetPuzzle()
    }
    
    func loadPuzzle(id: Int) {
        let puzzle = puzzleDA.getPuzzle(id)
        
        self.puzzleId = puzzle.puzzleId
        self.keyword = puzzle.keyword
        self.combinations = puzzle.combinations
        
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
        self.guesses.append(answer)
        
        if answer.uppercaseString == self.keyword.Name.uppercaseString {
            return true
        } else {
            return false
        }
    }
}