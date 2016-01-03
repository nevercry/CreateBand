//
//  UserManager.swift
//  CreateBand
//
//  Created by nevercry on 12/19/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import Foundation


let CreatebandUserId = "CreatebandUserId"

enum UserType: Int {
    case School = 0
    case Freelance
}

enum MusicStyle: Int {
    case Pop = 1
    case Rock
    case Folk
    case Ponk
    case Metal
    case Hardcore
    case Britpop
    case Blues
    case PostRock
    case Reggae
    case Jazz
    case Rap
    case Jpop
    case Gothic
    case Light
}

enum UserRole: Int {
    case LeadGuitar = 0
    case RhythmGuitar
    case Drummer
    case Bassist
    case LeadVocalist
    case Keyboardist
    case Turntablist
    
    func simpleDescription() -> String {
        switch self {
        case .LeadGuitar:
            return "主音吉他手"
        case .RhythmGuitar:
            return "节奏吉他手"
        case .Drummer:
            return "鼓手"
        case .Bassist:
            return "贝斯手"
        case .Keyboardist:
            return "键盘手"
        case .Turntablist:
            return "调音师"
        case .LeadVocalist:
            return "主唱"
        }
    }
    
    static let allValues = [LeadGuitar,RhythmGuitar,Drummer,Bassist,LeadVocalist,Keyboardist,Turntablist]
}

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
    
    var role: UserRole?
    
    
    
    // TODO: 需要后端建表
    var isCompleteInfo = false
    
    func roleImage() -> String {
        var imagePath: String
        
        if let _role = role {
            switch _role {
            case .LeadGuitar:
                imagePath = "Guitarist"
            case .RhythmGuitar:
                imagePath = "Guitarist"
            case .Bassist:
                imagePath = "Bassist"
            case .Drummer:
                imagePath = "Drummer"
            case .Keyboardist:
                imagePath = "Keyboardist"
            case .Turntablist:
                imagePath = "Turntablist"
            case .LeadVocalist:
                imagePath = "Vocalist"
            }
        } else {
            imagePath = "default_header"
        }
        
        return imagePath
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