//
//  LoginViewController.swift
//  CreateBand
//
//  Created by nevercry on 12/19/15.
//  Copyright © 2015 nevercry. All rights reserved.
// 登录页面

import UIKit
import Alamofire

struct CellIdentifier {
    static let UserIdCellIdentifier = "UserId Cell";
    static let SMSCellIdentifier = "SMS Cell";
    static let LoginCellIdentifier = "Login Cell";
}

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.keyboardDismissMode = .OnDrag
        }
    }
    
    // MARK: ref UserIdTableViewCell
    weak var userIdTextField: UITextField? {
        didSet {
            if userIdTextField != nil {
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: userIdTextField, queue: NSOperationQueue.mainQueue()) { (NSNotification) -> Void in
                    self.checkLoginButtonState()
                    self.checkSMSRequestButtonState()
                }
            }
        }
    }
    
    // MARK: ref smsTableViewCell
    weak var smsTextField: UITextField? {
        didSet {
            if smsTextField != nil {
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: smsTextField, queue: NSOperationQueue.mainQueue()) { (NSNotification) -> Void in
                    self.checkLoginButtonState()
                }
            }
        }
    }
    weak var requestSMSButton: UIButton?{
        didSet {
            checkSMSRequestButtonState()
        }
    }
    weak var lastCountLabel: UILabel?
    
    var timeRemaining = 59 {
        didSet {
            lastCountLabel?.text = "等待\(timeRemaining)s"
        }
    }
    // MARK: ref LoginTableViewCell
    weak var loginButton: UIButton?

    
    
    // MARK: Action
    
    func requestLoginSMS(sender: UIButton) {
        sender.hidden = true
        lastCountLabel?.hidden = false
        lastCountLabel?.text = "等待\(timeRemaining)s"
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateLastCountLabel:", userInfo: nil, repeats: true)
        timer.fire()
        // TODO: 调用短信接口
        print("调用短信接口")
        
        NetworkManager.sharedInstance.sendSMS((userIdTextField?.text)!, andSMSType: "Login")
        
    }
    

    // MARK: Custom Methods
    
    @IBAction func hideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func checkLoginButtonState() {
        if userIdTextField?.hasText() == true && smsTextField?.hasText() == true {
            loginButton?.enabled = true
            loginButton?.setBackgroundColor(UIColor(red: 0.0, green: 175.0/255, blue: 255.0/255, alpha: 1.0), forState: .Normal)
        } else {
            loginButton?.enabled = false
            loginButton?.setBackgroundColor(UIColor(red: 102.0/255, green: 204.0/255, blue: 255.0/255, alpha: 1.0), forState: .Normal)
        }
    }
    
    func checkSMSRequestButtonState() {
        let mobiePhoneRex = "^0?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$"
        if let userId = userIdTextField?.text {
            requestSMSButton?.enabled = RegexHelper.init(mobiePhoneRex).match(userId)
            // debug
//            let result = RegexHelper.init(mobiePhoneRex).match(userId)
//            print(result)
        }
    }
    
    func updateLastCountLabel(timer: NSTimer) {
        if timeRemaining == 0 {
            timer.invalidate()
            requestSMSButton?.hidden = false
            lastCountLabel?.hidden = true
            timeRemaining = 59
        } else {
            timeRemaining--
        }
    }

    
    
    // MARK: UITextFieldDelegate 
    // Cell里面的TextField delegate
    
    
    
    // MARK: UITable View DataSource and Delegate 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var tableViewCell: UITableViewCell
        var cellIdentifier: String
        
        switch indexPath.row {
        case 0:
            cellIdentifier = CellIdentifier.UserIdCellIdentifier
        case 1:
            cellIdentifier = CellIdentifier.SMSCellIdentifier
        case 2:
            cellIdentifier = CellIdentifier.LoginCellIdentifier
        default:
            cellIdentifier = "UnKownCellId"
        }
        
        tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        tableViewCell.setUpWithIdentifier(cellIdentifier, forIndexPath: indexPath, andController: self)
        
        
        return tableViewCell
    }
}


extension UITableViewCell {
    
    func setUpWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath, andController controller: LoginViewController) {
        
        switch identifier {
        case CellIdentifier.UserIdCellIdentifier:
            let userIdCell = self as! UserIdTableViewCell
            userIdCell.userIdTextField.delegate = controller
            controller.userIdTextField = userIdCell.userIdTextField
            
        
        case CellIdentifier.SMSCellIdentifier:
            let smsCell = self as! SmsTableViewCell
            smsCell.requestSMSButton .addTarget(controller, action: "requestLoginSMS:", forControlEvents: .TouchUpInside)
            smsCell.smsTextField.delegate = controller
            controller.smsTextField = smsCell.smsTextField
            controller.requestSMSButton = smsCell.requestSMSButton
            controller.lastCountLabel = smsCell.lastCountLabel
            
            
        case CellIdentifier.LoginCellIdentifier:
            let loginCell = self as! LoginTableViewCell
            loginCell.loginButton .addTarget(controller, action: "login:", forControlEvents: .TouchUpInside)
            controller.loginButton = loginCell.loginButton
        default: break
        }
    }
}

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