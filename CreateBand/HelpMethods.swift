//
//  HelpMethods.swift
//  CreateBand
//
//  Created by nevercry on 12/25/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import UIKit


extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, forState: forState)
    }
    
}

extension UIViewController {
    // 验证有效手机号
    func isValidMobile(mobile: String) -> Bool {
        let mobiePhoneRex = "^0?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$"
        return RegexHelper.init(mobiePhoneRex).match(mobile)
    }
    
    // 验证有效用户名 6-20位 英文和数字组合
    func isValidUserName(userName: String) -> Bool {
        let userNameRex = "^[A-Za-z0-9]{6,20}+$"
        return RegexHelper.init(userNameRex).match(userName)
    }
    
    func alertViewShow(title:String, andMessage message: String) {
        alerViewShow(title, andMessage: message, andHandler: nil)
    }
    
    func alerViewShow(title:String, andMessage message: String, andHandler handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .Alert)
        let actionCancel = UIAlertAction.init(title: "确定", style: .Cancel, handler: handler)
        alertController.addAction(actionCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension UIView {
    func cornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func bordeColor(color: UIColor) {
        self.layer.borderColor = color.CGColor
    }
    
    func bordeWidth(width: CGFloat) {
        self.layer.borderWidth = width
    }
}



