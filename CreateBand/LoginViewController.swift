//
//  LoginViewController.swift
//  CreateBand
//
//  Created by nevercry on 12/19/15.
//  Copyright © 2015 nevercry. All rights reserved.
// 登录页面

import UIKit
import Alamofire
import MBProgressHUD



class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    struct Constants {
        static let ShowRegistSegue = "Show Regist"
    }
    
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
    
    // MARK: ref LoginTableViewCell
    weak var loginButton: UIButton?
    
    // 取消注册通知
    deinit {
        if let obersver = smsTextField {
            NSNotificationCenter.defaultCenter().removeObserver(obersver)
        }
        if let obersver = userIdTextField {
            NSNotificationCenter.defaultCenter().removeObserver(obersver)
        }
    }
    
    
    // MARK: - Actions
    // MARK: 登录
    func login(sender: UIButton) {
        // 检查验证码是否是4位数
        if smsTextField?.text?.characters.count != 4 {
            let alertTitle = "验证码不足4位"
            let alertMessage = "请重新输入"
            self.alertViewShow(alertTitle, andMessage: alertMessage)
            return
        }
        
        // 调用登录接口
        let parameters = ["mobile":userIdTextField!.text!,"verify_code":smsTextField!.text!]
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        NetworkManager.sharedInstance.login(parameters) { (resp) in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if let error = resp.result.error {
                self.alertViewShow("error", andMessage: "请求失败 \(error)")
            } else {
                UserManager.sharedInstance.userId = self.userIdTextField!.text!
                let JSON = resp.result.value as! [String:String]
                UserManager.sharedInstance.token = JSON["token"]
                
                // 登录成功
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK: - 获取登录验证码
    func requestLoginSMS(sender: UIButton) {
        // debug
        // print("调用短信接口")
        let parameters = ["mobile":userIdTextField!.text!,"smsType":"Login"]
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        NetworkManager.sharedInstance.sendSMS(parameters) { (resp) -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if let error = resp.result.error {
                self.alertViewShow("error", andMessage: "请求失败 \(error)")
            }
        }
    }
    
    // MARK: - 注册进入注册界面
    func regist(sender: UIButton) {
        self.performSegueWithIdentifier(Constants.ShowRegistSegue, sender: sender)
    }
    
    // MARK: - Unwind Segue
    // 注册成功回调
    @IBAction func sucessuRegist(sender: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: - Custom Methods

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
        if let userId = userIdTextField?.text {
            requestSMSButton?.enabled = self.isValidMobile(userId)
        }
    }
    
    
    // MARK: UITextFieldDelegate 
    // Cell里面的TextField delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // 验证码限制在4位数
        if textField == smsTextField {
            if textField.text?.characters.count > 3 && string != "" {
                return false
            }
        }
        
        return true
    }
    
    
    
    // MARK: UITable View DataSource and Delegate 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
        case 3:
            cellIdentifier = CellIdentifier.RegistCellIdentfier
        default:
            cellIdentifier = "UnKownCellId"
        }
        
        tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        self.setUpWithIdentifier(cellIdentifier, forIndexPath: indexPath, andCell: tableViewCell)
        
        
        return tableViewCell
    }
    
    func setUpWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath, andCell cell: UITableViewCell) {
        
        switch identifier {
        case CellIdentifier.UserIdCellIdentifier:
            let userIdCell = cell  as! UserIdTableViewCell
            userIdCell.userIdTextField.delegate = self
            self.userIdTextField = userIdCell.userIdTextField
            // 检查UserDefault里面是否有上次登录的用户ID
            if let userId = UserManager.sharedInstance.userId {
                userIdCell.userIdTextField.text = userId
            }
            
        case CellIdentifier.SMSCellIdentifier:
            let smsCell = cell as! SmsTableViewCell
            smsCell.requestSMSButton .addTarget(self, action: "requestLoginSMS:", forControlEvents: .TouchUpInside)
            smsCell.smsTextField.delegate = self
            self.smsTextField = smsCell.smsTextField
            self.requestSMSButton = smsCell.requestSMSButton
            
        case CellIdentifier.LoginCellIdentifier:
            let loginCell = cell as! LoginTableViewCell
            loginCell.loginButton .addTarget(self, action: "login:", forControlEvents: .TouchUpInside)
            self.loginButton = loginCell.loginButton
            
        case CellIdentifier.RegistCellIdentfier:
            let registCell = cell as! RegistTableViewCell
            registCell.registButton .addTarget(self, action: "regist:", forControlEvents: .TouchUpInside)
        default: break
        }
    }
}


