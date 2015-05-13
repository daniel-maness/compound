//
//  Friend
//  Compound
//
//  Created by Daniel Maness on 5/6/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation

class Friend {
    var id: Int = -1
    var firstName: String = ""
    var lastName: String = ""
    var pictureFileName: String = ""
    var isMember: Bool = false
    var totalWonAgainst: Int = 0
    var totalLostAgainst: Int = 0
    
    var displayName: String {
        return self.firstName + " " + self.lastName
    }
    
    init() {
        
    }
    
    init(id: Int) {
        self.id = id
    }
}