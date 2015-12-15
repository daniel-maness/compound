//
//  PuzzleManager.swift
//  Compound
//
//  Created by Daniel Maness on 7/31/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation

class PuzzleManager {
    private let puzzleService: PuzzleService
    
    init() {
        puzzleService = PuzzleService()
    }
    
    func newPuzzle() -> Puzzle {
        return puzzleService.getPuzzle(nil)
    }
    
    func checkAnswer(guess: String, answer: String) -> Bool {
        if guess.uppercaseString == answer.uppercaseString {
            return true
        } else {
            return false
        }
    }
    
    func useHint(keyword: String, hintsUsed: Int) -> String {
        var hint = ""
        if hintsUsed == 1 {
            hint = "____"
        } else if hintsUsed == 2 {
            for _ in 0..<keyword.characters.count {
                hint += " _"
            }
        } else if hintsUsed == 3 {
            hint = keyword.substringTo(0)
            for _ in 1..<keyword.characters.count {
                hint += " _"
            }
        }
        
        return hint
    }
}