//
//  PuzzleService.swift
//  Compound
//
//  Created by Daniel Maness on 11/14/14.
//  Copyright (c) 2014 Daniel Maness. All rights reserved.
//

import Foundation
import Parse

class PuzzleService {
    private func getNewPuzzle() -> Puzzle {
        let db = SQLiteDB.sharedInstance()
        let keywordIds = db.query("SELECT k.KeywordId FROM viKeyword k")
        let keywordId = keywordIds[Int(arc4random_uniform(UInt32(keywordIds.count)))].data["KeywordId"]!.asString()
        
        var puzzleIds = db.query("SELECT DISTINCT p.PuzzleId FROM Puzzle p WHERE p.WordId = " + String(keywordId))
        let puzzleId = puzzleIds[Int(arc4random_uniform(UInt32(puzzleIds.count)))].data["PuzzleId"]!.asInt()
        
        return getPuzzle(puzzleId)
    }
    
    func getPuzzle(puzzleId: Int!) -> Puzzle! {
        if puzzleId == nil {
            return self.getNewPuzzle()
        } else {
            var puzzle = Puzzle()
            let db = SQLiteDB.sharedInstance()
            let data = db.query("SELECT * FROM viPuzzle p WHERE p.PuzzleId = " + String(puzzleId) + " LIMIT 1")
            if data.count > 0 {
                let row = data[0]
                puzzle.puzzleId = puzzleId
                puzzle.keyword = row["KeywordName"]!.asString()
                
                let combination1 = Combination(keyword: puzzle.keyword, leftWord: row["FirstName1"]!.asString(), rightWord: row["SecondName1"]!.asString())
                let combination2 = Combination(keyword: puzzle.keyword, leftWord: row["FirstName2"]!.asString(), rightWord: row["SecondName2"]!.asString())
                let combination3 = Combination(keyword: puzzle.keyword, leftWord: row["FirstName3"]!.asString(), rightWord: row["SecondName3"]!.asString())
                
                puzzle.combinations = [combination1, combination2, combination3]
            }
            
            return puzzle
        }
    }
}
