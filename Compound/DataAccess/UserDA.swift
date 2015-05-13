//
//  UserDA.swift
//  Compound
//
//  Created by Daniel Maness on 4/29/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation

class UserDA {
    func getTotalStars(userId: Int) -> Int {
        let db = SQLiteDB.sharedInstance()
        let starCount4 = db.query("SELECT COUNT(*) AS Total FROM UserPuzzle WHERE HintTime1 IS NULL AND StatusId = 1")[0]["Total"]!.asInt()
        let starCount3 = db.query("SELECT COUNT(*) AS Total FROM UserPuzzle WHERE HintTime1 IS NOT NULL AND HintTime2 IS NULL AND StatusId = 1")[0]["Total"]!.asInt()
        let starCount2 = db.query("SELECT COUNT(*) AS Total FROM UserPuzzle WHERE HintTime2 IS NOT NULL AND HintTime3 IS NULL AND StatusId = 1")[0]["Total"]!.asInt()
        let starCount1 = db.query("SELECT COUNT(*) AS Total FROM UserPuzzle WHERE HintTime3 IS NOT NULL AND StatusId = 1")[0]["Total"]!.asInt()
        
        return starCount4 * 4 + starCount3 * 3 + starCount2 * 2 + starCount1
    }
    
    func getPuzzleCount(userId: Int, status: Status!) -> Int {
        var sql: String        
        if status == nil {
            sql = "SELECT COUNT(*) AS Total FROM UserPuzzle up WHERE up.UserId = " + String(userId)
        } else {
            sql = "SELECT COUNT(*) AS Total FROM UserPuzzle up WHERE up.UserId = " + String(userId) + " AND up.StatusId = " + String(status.rawValue)
        }
        
        let db = SQLiteDB.sharedInstance()
        let count = db.query(sql)[0]["Total"]!.asInt()
        
        return count
    }
    
    func getAverageStars(userId: Int) -> Double {
        let totalStars = Double(getTotalStars(userId))
        let possibleStars = Double(getPuzzleCount(userId, status: Status.Complete) * 4)
        let average = possibleStars > 0 ? totalStars / possibleStars * 4.0 : 0
        
        return average
    }
    
    func getHintCount(userId: Int) -> Int {
        let db = SQLiteDB.sharedInstance()
        let hintCount1 = db.query("SELECT COUNT(*) AS Total FROM UserPuzzle up WHERE up.UserId = " + String(userId) + " AND up.StatusId = 1 AND up.HintTime1 IS NOT NULL")[0]["Total"]!.asInt()
        let hintCount2 = db.query("SELECT COUNT(*) AS Total FROM UserPuzzle up WHERE up.UserId = " + String(userId) + " AND up.StatusId = 1 AND up.HintTime2 IS NOT NULL")[0]["Total"]!.asInt()
        let hintCount3 = db.query("SELECT COUNT(*) AS Total FROM UserPuzzle up WHERE up.UserId = " + String(userId) + " AND up.StatusId = 1 AND up.HintTime3 IS NOT NULL")[0]["Total"]!.asInt()
        
        return hintCount1 + hintCount2 + hintCount3
    }
    
    func getAverageTime(userId: Int) -> Int {
        let db = SQLiteDB.sharedInstance()
        let data = db.query("SELECT strftime('%s', up.EndTime) - strftime('%s', up.StartTime) AS Duration FROM UserPuzzle up WHERE up.UserId = " + String(userId) + " AND up.StatusId = 1")
        
        var totalDuration = 0.0
        for row in data {
            totalDuration += row["Duration"]!.asDouble()
        }
        
        return data.count > 0 ? Int(totalDuration) / data.count : 0
    }
    
    func getFriend(userId: Int) -> Friend {
        let db = SQLiteDB.sharedInstance()
        let data = db.query("SELECT u.UserId, u.FirstName, u.LastName FROM User u WHERE u.UserId = ?", parameters: [String(userId)])[0]
        
        var friend = Friend(id: data["UserId"]!.asInt())
        friend.firstName = data["FirstName"]!.asString()
        friend.lastName = data["LastName"]!.asString()
        friend.pictureFileName = "group-icon"
        
        return friend
    }
    
    func getFriendsList(userId: Int) -> [Friend] {
        let db = SQLiteDB.sharedInstance()
        let userIdString = String(userId)
        let data = db.query("SELECT u.UserId, u.FirstName, u.LastName " +
                            "FROM UserFriend uf " +
                            "JOIN User u ON u.UserId = uf.UserId OR u.UserId = uf.FriendId " +
                            "WHERE (uf.UserId = " + userIdString + " OR uf.FriendId = " + userIdString + ") " +
                            "AND u.UserId != " + userIdString + " " +
                            "ORDER BY u.FirstName")
        
        var friends = [Friend]()
        for row in data {
            var friend = Friend(id: row["UserId"]!.asInt())
            friend.firstName = row["FirstName"]!.asString()
            friend.lastName = row["LastName"]!.asString()
            friend.pictureFileName = "group-icon"
            friends.append(friend)
        }
        
        return friends
    }
}