//
//  AccountInfoViewController.swift
//  CreateBand
//
//  Created by nevercry on 12/28/15.
//  Copyright © 2015 nevercry. All rights reserved.
//  资料完善界面

import UIKit

class AccountInfoViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    struct Constants {
        static let UserStyleInfoViewControolerIdentifier = "UserStyleInfoViewController"
    }
    

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedRole: UserRole?
    var selectedUserType: UserType?
    var musicStyles: [MusicStyle]?
    
    var tableView: UITableView? // 职业选择tableView
    
    var roles = UserRole.allValues
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    
    // MARK: Customs 
    
    func setUpViews() {
        // 初始化tableView
        tableView = UITableView.init()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        automaticallyAdjustsScrollViewInsets = false
        title = "职业选择"
        
        // 初始化 userStyleInfoVC
        let userStyleInfoVC = UserStyleInfoViewController()
        userStyleInfoVC.view = NSBundle.mainBundle().loadNibNamed("UserStyleInfoView", owner: userStyleInfoVC, options: nil).last as! UIView
        userStyleInfoVC.view.frame = CGRectMake(view.bounds.width, 0, view.bounds.width, view.bounds.height)
        

        // 初始化 scroolView
        scrollView.contentSize = CGSizeMake(2 * view.bounds.width, view.bounds.height)
        scrollView.delegate = self
        
        scrollView.addSubview(tableView!)
        scrollView.addSubview(userStyleInfoVC.view)
        
        addChildViewController(userStyleInfoVC)
    }
    
    func checkParmaSatisfied() {
        let childVC = childViewControllers.last as! UserStyleInfoViewController
        
        selectedUserType = childVC.userType
        musicStyles = childVC.musicStyles()
        
        if selectedRole != nil && selectedUserType != nil && musicStyles?.count > 0 {
            let rightButton = UIBarButtonItem.init(barButtonSystemItem: .Done, target: self, action: "submitUserInfo")
            navigationItem.rightBarButtonItem = rightButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        
        
    }
    
    func submitUserInfo() {
        
    }
    
    // MARK: Actions
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: UITableView Delegate and DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: "Cell")
            cell?.selectionStyle = .None            
        }
        
        cell?.textLabel?.text = roles[indexPath.row].simpleDescription()
        cell?.accessoryType = (roles[indexPath.row] == selectedRole) ? .Checkmark : .None
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRole = roles[indexPath.row]
        tableView.reloadData()
        
        scrollView.setContentOffset(CGPointMake(view.bounds.size.width,0), animated: true)
        
    }
    
    // MARK: UIScrollView Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        
        // 当内容的orgin 离scrollView的orgin 的距离大于或等于屏幕的宽度时，翻页
        if offset.x >= view.bounds.width {
            pageControl.currentPage = 1
            
            title = "属性风格"
        } else {
            pageControl.currentPage = 0
            title = "职业选择"
        }
    }
    
    

   
    
}
