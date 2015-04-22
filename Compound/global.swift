//
//  UserData.swift
//  Compound
//
//  Created by Daniel Maness on 4/18/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation

class UserData {
    private var totalStars: Int
    
    init() {
        self.totalStars = 0
    }
    
    func getTotalStars() -> Int {
        return self.totalStars
    }
    
    func addStars(stars: Int) {
        self.totalStars += stars
    }
}

var userData = UserData()