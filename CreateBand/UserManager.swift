//
//  UserManager.swift
//  CreateBand
//
//  Created by nevercry on 12/19/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import Foundation


let CreatebandUserId = "CreatebandUserId"

class UserManager: NSObject {
    static let sharedInstance = UserManager()
    
    var userId: String? {
        get {
            if let _userId = NSUserDefaults.standardUserDefaults().stringForKey(CreatebandUserId) {
                return _userId
            } else {
                return nil
            }
        }
        
        set {
            self.userId = newValue
            
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: CreatebandUserId)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
       
    }
    
    var token: String? {
        get {
            if self.userId != nil {
                let _token = KeychainWrapper.stringForKey(self.userId!)
                return _token
            } else {
                return nil
            }
        }
        
        set {
            self.token = newValue
            KeychainWrapper.setString(self.token!, forKey: self.userId!)
        }
    }
}