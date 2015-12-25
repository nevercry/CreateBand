//
//  MainViewController.swift
//  CreateBand
//
//  Created by nevercry on 12/19/15.
//  Copyright © 2015 nevercry. All rights reserved.
//  首页

import UIKit



class MainViewController: UIViewController {
    
    struct Constant {
        static let LoginViewControllerIdentifier = "LoginViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 检查token 是否存在 判断用户是否登录
        
        if let _ = UserManager.sharedInstance.token {
            // TODO: 调用首页借口下载数据
        } else {
            // TDO: 展示登录页面
            print("no usertoken")
            
            showLogin()
        }
    }
    
    // MARK: Actions
    @IBAction func accountInfo(sender: AnyObject) {
        let alertC = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
        let actionAccountInfo = UIAlertAction.init(title: "帐户信息", style: .Default, handler: nil)
        let actionAccountLogout = UIAlertAction.init(title: "退出", style: .Destructive) { (action) in
            UserManager.sharedInstance.token = nil // 清空token
            self.showLogin()
        }
        let actionCancel = UIAlertAction.init(title: "取消", style: .Cancel, handler: nil)
        
        alertC.addAction(actionAccountInfo)
        alertC.addAction(actionAccountLogout)
        alertC.addAction(actionCancel)
        
        self.presentViewController(alertC, animated: true, completion: nil)
    }
    
    // MARK: Custom Methods 
    
    func showLogin() {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier(Constant.LoginViewControllerIdentifier)
        self.navigationController?.presentViewController(loginVC!, animated: true, completion: nil)
    }
    
}
