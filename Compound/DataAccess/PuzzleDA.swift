//
//  PuzzleDA.swift
//  Compound
//
//  Created by Daniel Maness on 11/14/14.
//  Copyright (c) 2014 Daniel Maness. All rights reserved.
//

import Foundation
import Parse

class PuzzleDA {
    func getNewPuzzle() -> Puzzle {
        let db = SQLiteDB.sharedInstance()
        let keywordIds = db.query("SELECT k.KeywordId FROM viKeyword k")
        let keywordId = keywordIds[Int(arc4random_uniform(UInt32(keywordIds.count)))].data["KeywordId"]!.asString()
        
        var puzzleIds = db.query("SELECT DISTINCT p.PuzzleId FROM Puzzle p WHERE p.WordId = " + String(keywordId))
        let puzzleId = puzzleIds[Int(arc4random_uniform(UInt32(puzzleIds.count)))].data["PuzzleId"]!.asInt()
        
        return getPuzzle(puzzleId)
    }
    
    func getPuzzle(puzzleId: Int) -> Puzzle! {
        var puzzle = Puzzle()
        let db = SQLiteDB.sharedInstance()
        let data = db.query("SELECT * FROM viPuzzle p WHERE p.PuzzleId = " + String(puzzleId) + " LIMIT 1")
        if data.count > 0 {
            let row = data[0]
            puzzle.puzzleId = puzzleId
            puzzle.keyword = Word(id: row["KeywordId"]!.asInt(), name: row["KeywordName"]!.asString())
            
            let combination1 = Combination(combinationId: row["CombinationId1"]!.asInt(), keyword: puzzle.keyword, leftWord: Word(id: row["FirstWordId1"]!.asInt(), name: row["FirstName1"]!.asString()), rightWord: Word(id: row["SecondWordId1"]!.asInt(), name: row["SecondName1"]!.asString()))
            let combination2 = Combination(combinationId: row["CombinationId2"]!.asInt(), keyword: puzzle.keyword, leftWord: Word(id: row["FirstWordId2"]!.asInt(), name: row["FirstName2"]!.asString()), rightWord: Word(id: row["SecondWordId2"]!.asInt(), name: row["SecondName2"]!.asString()))
            let combination3 = Combination(combinationId: row["CombinationId3"]!.asInt(), keyword: puzzle.keyword, leftWord: Word(id: row["FirstWordId3"]!.asInt(), name: row["FirstName3"]!.asString()), rightWord: Word(id: row["SecondWordId3"]!.asInt(), name: row["SecondName3"]!.asString()))
            
            puzzle.combinations = [combination1, combination2, combination3]
        }
        
        return puzzle
    }
    
    func savePuzzle(puzzle: Puzzle) -> Int? {
        let userPuzzle = PFObject(className: "UserPuzzle")
        let user = PFObject(className: "User")
        let pfPuzzle = PFObject(className: "Puzzle")
        let status = PFObject(className: "Status")
        //userPuzzle["UserId"] = currentUser.userId
        //userPuzzle["PuzzleId"] = puzzle.puzzleId
        //userPuzzle["StatusId"] = puzzle.status.rawValue
        userPuzzle["StartTime"] = puzzle.startTime
        userPuzzle["StopTime"] = puzzle.endTime
        userPuzzle["HintTime1"] = puzzle.hintTime1
        userPuzzle["HintTime2"] = puzzle.hintTime2
        userPuzzle["HintTime3"] = puzzle.hintTime3
        userPuzzle.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
        
        var id = userPuzzle.objectId
        return id?.toInt()
//        let db = SQLiteDB.sharedInstance()
//        let hintTime1 = puzzle.hintTime1 == "" ? "NULL" : "'" + puzzle.hintTime1 + "'"
//        let hintTime2 = puzzle.hintTime2 == "" ? "NULL" : "'" + puzzle.hintTime2 + "'"
//        let hintTime3 = puzzle.hintTime3 == "" ? "NULL" : "'" + puzzle.hintTime3 + "'"
//        db.execute("INSERT INTO UserPuzzle (UserId, PuzzleId, StatusId, StartTime, EndTime, HintTime1, HintTime2, HintTime3) VALUES(" +
//                    String(currentUser.userId) + ", " +
//                    String(puzzle.puzzleId) + ", " +
//                    String(puzzle.status.rawValue) + ", " +
//                    "'" + puzzle.startTime + "', " +
//                    "'" + puzzle.endTime + "', " +
//                    "" + hintTime1 + ", " +
//                    "" + hintTime2 + ", " +
//                    "" + hintTime3 + ")")
//        
//        let userPuzzleId = db.query("SELECT last_insert_rowid() AS userPuzzleId FROM UserPuzzle up WHERE up.UserId = " + String(currentUser.userId))[0]["userPuzzleId"]!.asInt()
//
//        for guess in puzzle.guesses {
//            guess.userPuzzleId = userPuzzleId
//            db.execute("INSERT INTO Guess (UserPuzzleId, Description, SubmitTime) VALUES(" +
//                        String(guess.userPuzzleId) + ", " +
//                        "'" + guess.description + "', " +
//                        "'" + guess.submitTime + "')")
//        }
//        
//        return userPuzzleId
    }
}
