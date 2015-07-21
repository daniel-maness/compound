//
//  Friend
//  Compound
//
//  Created by Daniel Maness on 5/6/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation
import Parse

class Friend {
    var id: String!
    var firstName: String = ""
    var lastName: String = ""
    var pictureFileName: String = ""
    var profilePictureUrl: String!
    var profilePicture: UIImage!
    var isMember: Bool = false
    var totalWonAgainst: Int = 0
    var totalLostAgainst: Int = 0
    var displayName: String!
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
}