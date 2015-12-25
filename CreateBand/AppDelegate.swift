//
//  AppDelegate.swift
//  CreateBand
//
//  Created by nevercry on 12/1/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import UIKit

struct CellIdentifier {
    static let UserIdCellIdentifier = "UserId Cell";
    static let SMSCellIdentifier = "SMS Cell";
    static let LoginCellIdentifier = "Login Cell";
    static let RegistCellIdentfier = "Regist Cell";
    
    static let UserNameCellIdentifier = "UserName Cell";
    static let RegistConformCellIdentifier = "RegistConform Cell"
}





@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

