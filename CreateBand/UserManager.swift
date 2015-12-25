//
//  UserManager.swift
//  CreateBand
//
//  Created by nevercry on 12/19/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import Foundation


let CreatebandUserId = "CreatebandUserId"

class UserManager {
    static let sharedInstance = UserManager()
    
    var userId: String? {
        get {
            if let _userId = NSUserDefaults.standardUserDefaults().stringForKey(CreatebandUserId) {
                return _userId
            } else {
                return nil
            }
        }
        
        set (newValue)  {
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
        
        set (newValue) {
            if newValue != nil {
                KeychainWrapper.setString(newValue!, forKey: self.userId!)
            } else {
                KeychainWrapper.removeObjectForKey(self.userId!)
            }
        }
    }
}


struct RegexHelper {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        do {
            regex = try NSRegularExpression.init(pattern: pattern, options: .CaseInsensitive)
        } catch {
            print("\(error)")
            regex = nil
        }
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matchesInString(input, options: .ReportCompletion, range: NSMakeRange(0, input.characters.count)) {
            return matches.count > 0
        } else {
            return false
        }
    }
}