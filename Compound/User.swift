//
//  UserData.swift
//  Compound
//
//  Created by Daniel Maness on 4/18/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation

class User {
    private var userDA = UserDA()
    
    let userId: Int
    
    init() {
        self.userId = 1
    }
    
    func getPersonalStats() -> (totalStars: Int, totalPuzzles: Int, totalWon: Int, averageStars: Double, totalHints: Int, averageTime: Int) {
        let totalStars = getTotalStars()
        let totalPuzzles = getPuzzleCount(nil)
        let totalWon = getPuzzleCount(Status.Complete)
        let averageStars = getAverageStars()
        let totalHints = getHintCount()
        let averageTime = getAverageTime()
        
        return (totalStars, totalPuzzles, totalWon, averageStars, totalHints, averageTime)
    }
    
    func getVersusStats() {
        
    }
    
    func getBestOfStats() {
        
    }
    
    func getTotalStars() -> Int {
        return userDA.getTotalStars(self.userId)
    }
    
    func getPuzzleCount(status: Status!) -> Int {
        return userDA.getPuzzleCount(self.userId, status: status)
    }
    
    func getAverageStars() -> Double {
        return userDA.getAverageStars(self.userId)
    }
    
    func getHintCount() -> Int {
        return userDA.getHintCount(self.userId)
    }
    
    func getAverageTime() -> Int {
        return userDA.getAverageTime(self.userId)
    }
}

var currentUser = User()