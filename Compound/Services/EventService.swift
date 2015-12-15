//
//  ErrorService.swift
//  Compound
//
//  Created by Daniel Maness on 7/30/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation
import Parse

class EventService {
    class func logError(error: NSError) {
        let errorObject = PFObject(className: ERROR_CLASSNAME)
        errorObject["userObject"] = PFUser.currentUser()
        errorObject["systemDescription"] = error.debugDescription as String
        
        errorObject.saveInBackgroundWithBlock({ (success, error) -> Void in
            print("1: Generic error")
            print("2: " + error.debugDescription)
            
            if error == nil {
                print("3: Error " + errorObject.objectId! + " saved in Parse\n")
            } else {
                print("3: Error failed to save in Parse\n")
            }
        })
    }
    
    class func logError(error: NSError, description: String!, object: String!, function: String!) {
        let errorObject = PFObject(className: ERROR_CLASSNAME)
        errorObject["userObject"] = PFUser.currentUser()
        errorObject["systemDescription"] = error.debugDescription as String
        errorObject["appDescription"] = description == nil ? NSNull() : description
        errorObject["appObject"] = object == nil ? NSNull() : object
        errorObject["appFunction"] = function == nil ? NSNull() : function
        
        errorObject.saveInBackgroundWithBlock({ (success, err) -> Void in
            print("1: " + description)
            print("2: " + error.debugDescription)
            
            if err == nil {
                print("3: Error " + errorObject.objectId! + " saved in Parse\n")
            } else {
                print("3: Error failed to save in Parse\n")
            }
        })
    }
    
    class func logSuccess(description: String) {
        print("1: Success: " + description + "\n")
    }
    
    class func logEvent(description: String) {
        print("1: Event: " + description + "\n")
    }
}