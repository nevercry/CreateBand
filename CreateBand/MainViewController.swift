//
//  MainViewController.swift
//  CreateBand
//
//  Created by nevercry on 12/19/15.
//  Copyright © 2015 nevercry. All rights reserved.
//  首页

import UIKit

struct Constant {
    static let LoginViewControllerIdentifier = "LoginViewController"
}

class MainViewController: UIViewController {

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
    
    
    // MARK: Custom Methods 
    
    func showLogin() {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier(Constant.LoginViewControllerIdentifier)
        self.navigationController?.presentViewController(loginVC!, animated: true, completion: nil)
    }
    
}
