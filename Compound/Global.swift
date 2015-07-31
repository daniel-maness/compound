//
//  Global.swift
//  Compound
//
//  Created by Daniel Maness on 7/19/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation

let USER_CLASSNAME = "_User"
let CHALLENGE_CLASSNAME = "Challenge"
let FRIEND_CLASSNAME = "UserFriend"
let WORD_CLASSNAME = "Word"
let COMBINATION_CLASSNAME = "Combination"
let ERROR_CLASSNAME = "Error"
let PROFILE_PICTURE = "group-icon"
let GROUP_PICTURE = "group-icon"
let FACEBOOK_PERMISSIONS = ["user_friends", "email", "public_profile"]

let MAX_TIME = 60

var CurrentUser: User!

class Settings {
    static var autoWin: Bool!
}