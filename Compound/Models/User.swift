//
//  UserData.swift
//  Compound
//
//  Created by Daniel Maness on 4/18/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class User {
    private let userManager = UserManager()
    
    var objectId: String
    var facebookUserId: String!
    var displayName: String
    var profilePicture: UIImage!
    var stats: Statistics!
    
    init(userObject: PFObject) {
        self.objectId = userObject.objectId!
        self.facebookUserId = userObject["facebookUserId"] as! String
        self.displayName = userObject["displayName"] as! String
        self.profilePicture = userManager.loadProfilePicture(self.facebookUserId)
    }
}