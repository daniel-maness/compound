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
    case Incomplete = -1, Complete, TimeUp, GaveUp
}

class Puzzle {
    let maxHints: Int = 3
    let maxStars: Int = 4
    let minStars: Int = 1
    let maxTime = 60
    
    private var puzzleDA: PuzzleDA
    
    var combinations: [Combination]
    var keyword: Word
    var guesses: [String]
    var hintsUsed: Int
    var currentHint: String
    var points: Int
    var ended: Bool
    var time: Int
    var status: Status
    
    var currentStars: Int {
        return self.maxStars - self.hintsUsed
    }
    
    init() {
        self.puzzleDA = PuzzleDA()
        self.combinations = [Combination]()
        self.keyword = Word(id: 0, name: "")
        self.guesses = [String]()
        self.currentHint = ""
        self.hintsUsed = 0
        self.points = 0
        self.ended = false
        self.time = maxTime
        self.status = Status.Incomplete
    }
    
    func resetPuzzle() {
        self.guesses = [String]()
        self.hintsUsed = 0
        self.currentHint = ""
        self.points = 0
        self.ended = false
        self.time = maxTime
        self.status = Status.Incomplete
    }
    
    func newPuzzle() {
        //puzzleDA.populateWordTable()
        //puzzleDA.populateWordPairTable()
        //puzzleDA.generatePuzzles()
        var keywords = puzzleDA.getAllWordsUppercase()
        var keyword: Word
        var allCombinations = [Combination]()
        
        do {
            let randomIndex = Int(arc4random_uniform(UInt32(keywords.count)))
            keyword = keywords[randomIndex]
            
            allCombinations = puzzleDA.getAllCombinations(keyword)
        } while allCombinations.count < 3
        
        var combinations = [Combination]()
        for i in 0..<3 {
            let randomIndex = Int(arc4random_uniform(UInt32(allCombinations.count)))
            combinations.append(allCombinations[randomIndex])
            allCombinations.removeAtIndex(randomIndex)
        }
        
        self.keyword = keyword
        self.combinations = combinations
        
        resetPuzzle()
    }
    
    func loadPuzzle(id: Int) {
        
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
        
        if answer == self.keyword.Name {
            return true
        } else {
            return false
        }
    }
}