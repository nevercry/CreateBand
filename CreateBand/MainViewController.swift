//
//  MainViewController.swift
//  CreateBand
//
//  Created by nevercry on 12/19/15.
//  Copyright © 2015 nevercry. All rights reserved.
//  首页

import UIKit
import MapKit


class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    struct Constant {
        static let LoginViewControllerIdentifier = "LoginViewController"
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    lazy var locationManager = CLLocationManager()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 检查token 是否存在 判断用户是否登录
        if (UserManager.sharedInstance.token == nil) {
            // 展示登录页面
            print("no usertoken")
            
            showLogin()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = UserManager.sharedInstance.token {
            // 开始更新位置
            startLocationUpdate()
            
            // TODO: 调用首页接口下载数据
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopLocationUpdate()
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
    func startLocationUpdate() {
        // 获取应用位置授权状态
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .Denied || authStatus == .Restricted {
            //用户限制不做定位
        } else {
            locationManager.delegate = self
            
            if authStatus == .NotDetermined {
                // 请求用户在是App使用期间获得位置授权
                locationManager.requestWhenInUseAuthorization()
            } else {
                mapView.showsUserLocation = true
            }
        }
    }
    
    func stopLocationUpdate() {
        locationManager.delegate = nil
        mapView.showsUserLocation = false
    }
    
    
    func showLogin() {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier(Constant.LoginViewControllerIdentifier)
        self.navigationController?.presentViewController(loginVC!, animated: true, completion: nil)
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - CLLocationManagerDelegate 
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    
    
    
}
