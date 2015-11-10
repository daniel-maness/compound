//
//  PuzzleService.swift
//  Compound
//
//  Created by Daniel Maness on 11/14/14.
//  Copyright (c) 2014 Daniel Maness. All rights reserved.
//

import Foundation
import Parse
import SQLite

class PuzzleService {
    var db: Connection!
    
    init() {
        do {
            var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let path = NSURL(fileURLWithPath: paths[0]).URLByAppendingPathComponent("compound.sqlite")
            
            self.db = try Connection(path.relativeString!)
        } catch let error as NSError {
            EventService.logError(error, description: "Could not load puzzle database", object: "PuzzleService", function: "init")
        }
    }
    
    private func selectKeywordId() -> Int {
        let keywordView = View("viKeyword")
        let keywordId = Expression<Int>("KeywordId")
        var keywordIds: [Int] = []
        
        for keyword in self.db.prepare(keywordView) {
            keywordIds.append(keyword[keywordId])
        }
        
        return keywordIds[Int(arc4random_uniform(UInt32(keywordIds.count)))]
    }
    
    private func selectPuzzleIdByKeyword(keywordId: Int) -> Int {
        let puzzleTable = Table("Puzzle")
        let puzzleId = Expression<Int>("PuzzleId")
        let wordId = Expression<Int>("WordId")
        var puzzleIds: [Int] = []
        
        let filteredPuzzles = puzzleTable.filter(wordId == keywordId)
        
        for puzzle in db.prepare(filteredPuzzles) {
            puzzleIds.append(puzzle[puzzleId])
        }
        
        return puzzleIds[Int(arc4random_uniform(UInt32(puzzleIds.count)))]
    }
    
    private func getNewPuzzle() -> Puzzle {
        let selectedKeywordId = selectKeywordId()
        let selectedPuzzleId = selectPuzzleIdByKeyword(selectedKeywordId)
        
        return getPuzzle(selectedPuzzleId)
    }
    
    func getPuzzle(id: Int!) -> Puzzle! {
        if id == nil {
            return self.getNewPuzzle()
        } else {
            let puzzle = Puzzle()
            let query = db.prepare("SELECT PuzzleId, KeywordName, FirstName1, FirstName2, FirstName3, SecondName1, SecondName2, SecondName3 FROM viPuzzle p WHERE p.PuzzleId = " + String(id) + " LIMIT 1")
            for row in query {
                puzzle.puzzleId = id
                puzzle.keyword = row[1] as! String
                let combination1 = Combination(keyword: puzzle.keyword, leftWord: row[2] as! String, rightWord: row[5] as! String)
                let combination2 = Combination(keyword: puzzle.keyword, leftWord: row[3] as! String, rightWord: row[6] as! String)
                let combination3 = Combination(keyword: puzzle.keyword, leftWord: row[4] as! String, rightWord: row[7] as! String)
                
                puzzle.combinations = [combination1, combination2, combination3]
            }
            
            return puzzle
        }
    }
}
