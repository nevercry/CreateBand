//
//  RegistViewController.swift
//  CreateBand
//
//  Created by nevercry on 12/25/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD


class RegistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    struct Constents {
        static let RegistSuccessSegue = "Regist Success"
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.keyboardDismissMode = .OnDrag
        }
    }
    
    // MARK: ref UserNameTableViewCell
    weak var userNameTextField: UITextField? {
        didSet {
            if userNameTextField != nil {
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: userNameTextField, queue: NSOperationQueue.mainQueue()) { (NSNotification) -> Void in
                    self.checkRegistButtonState()
                    self.checkSMSRequestButtonState()
                }
            }
        }
    }
    
    // MARK: ref UserIdTableViewCell
    weak var userIdTextField: UITextField? {
        didSet {
            if userIdTextField != nil {
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: userIdTextField, queue: NSOperationQueue.mainQueue()) { (NSNotification) -> Void in
                    self.checkRegistButtonState()
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
                    self.checkRegistButtonState()
                }
            }
        }
    }
    
    // MARK: ref Regist
    weak var registButton: UIButton? 
    
    // 取消注册通知
    deinit {
        if let observer = userNameTextField {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        if let observer = userIdTextField {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        if let observer = smsTextField {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }
    
    weak var requestSMSButton: UIButton?{
        didSet {
            checkSMSRequestButtonState()
        }
    }
    

    // MARK: Actions 
    // MARK: 取消注册
    @IBAction func cancelRegist(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: 获取注册验证码
    func requestLoginSMS(sender: UIButton) {
        // debug
        // print("调用短信接口")
        let parameters = ["mobile":userIdTextField!.text!,"smsType":"Regist"]
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        NetworkManager.sharedInstance.sendSMS(parameters) { (resp) -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if let error = resp.result.error {
                self.alertViewShow("error", andMessage: "请求失败 \(error)")
            }
        }
    }
    
    // MARK:  注册
    func regist(sender: UIButton) {
        // 检查用户名是否符合要求
        if !self.isValidUserName(userNameTextField!.text!) {
            self.alertViewShow("用户名格式不正确", andMessage: "请输入6-20位字母和数字组合")
            return
        }
        
        // 检查验证码是否是4位数
        if smsTextField?.text?.characters.count != 4 {
            let alertTitle = "验证码不足4位"
            let alertMessage = "请重新输入"
            self.alertViewShow(alertTitle, andMessage: alertMessage)
            return
        }
        
        // 调用注册接口
        let parameters = ["mobile":userIdTextField!.text!,"username":userNameTextField!.text!,"verify_code":smsTextField!.text!]
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        NetworkManager.sharedInstance.regist(parameters) { response in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            // 验证服务器返回
            if let error = response.result.error {
                self.alertViewShow("error", andMessage: "请求失败 \(error)")
            } else {
                UserManager.sharedInstance.userId = self.userIdTextField!.text!
                let JSON = response.result.value as! [String:String]
                UserManager.sharedInstance.token = JSON["token"]
                
                // 登录成功
                self.performSegueWithIdentifier(Constents.RegistSuccessSegue, sender: self)
            }
            
        }
    }
    
    
    // MARK: Custom Methods
    
    @IBAction func hideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func checkRegistButtonState() {
        if userIdTextField?.hasText() == true && smsTextField?.hasText() == true && userNameTextField?.hasText() == true {
            registButton?.enabled = true
            registButton?.setBackgroundColor(UIColor(red: 0.0, green: 175.0/255, blue: 255.0/255, alpha: 1.0), forState: .Normal)
        } else {
            registButton?.enabled = false
            registButton?.setBackgroundColor(UIColor(red: 102.0/255, green: 204.0/255, blue: 255.0/255, alpha: 1.0), forState: .Normal)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == userNameTextField {
            userIdTextField?.becomeFirstResponder()
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
            cellIdentifier = CellIdentifier.UserNameCellIdentifier
        case 1:
            cellIdentifier = CellIdentifier.UserIdCellIdentifier
        case 2:
            cellIdentifier = CellIdentifier.SMSCellIdentifier
        case 3:
            cellIdentifier = CellIdentifier.RegistConformCellIdentifier
        default:
            cellIdentifier = "UnKownCellId"
        }
        
        tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        self.setUpWithIdentifier(cellIdentifier, forIndexPath: indexPath, andCell: tableViewCell)
        
        return tableViewCell
    }
    
    func setUpWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath, andCell cell: UITableViewCell) {
        
        switch identifier {
        case CellIdentifier.UserNameCellIdentifier:
            let userNameCell = cell as! UserIdTableViewCell // 用户名跟手机号共用一种Cell
            userNameCell.userIdTextField.delegate = self
            self.userNameTextField = userNameCell.userIdTextField
                        
        case CellIdentifier.UserIdCellIdentifier:
            let userIdCell = cell as! UserIdTableViewCell
            userIdCell.userIdTextField.delegate = self
            self.userIdTextField = userIdCell.userIdTextField
            
        case CellIdentifier.SMSCellIdentifier:
            let smsCell = cell as! SmsTableViewCell
            smsCell.requestSMSButton .addTarget(self, action: "requestLoginSMS:", forControlEvents: .TouchUpInside)
            smsCell.smsTextField.delegate = self
            self.smsTextField = smsCell.smsTextField
            self.requestSMSButton = smsCell.requestSMSButton
            
        case CellIdentifier.RegistConformCellIdentifier:
            let registCell = cell as! LoginTableViewCell // 注册Button跟登录共用一种Cell
            registCell.loginButton.addTarget(self, action: "regist:", forControlEvents: .TouchUpInside)
            self.registButton = registCell.loginButton
            
        default: break
        }
    }

}

