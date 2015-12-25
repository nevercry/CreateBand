//
//  NetworkManager.swift
//  CreateBand
//
//  Created by nevercry on 12/20/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    struct Domain {
        static let headers = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"]
        static let host = "https://nevercryair.local/createband/"
        static let sendSMS = host + "sendSMS.php"
        static let login =  host + "login.php"
        static let regist = host + "regist.php"
    }
    
    
    
    class var sharedInstance: NetworkManager {
        struct Singleton {
            static let instance: NetworkManager = NetworkManager()
        }
        
        return Singleton.instance
    }
    
    
    var manager: Manager?
    
    init() {
        manager = Manager.sharedInstance
        manager!.delegate.sessionDidReceiveChallenge = { (session, challenge) in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if let serverTrust = challenge.protectionSpace.serverTrust {
                    
//                    let newTrustPolicies = NSMutableArray()
//                    
//                    let sslPolicy = SecPolicyCreateSSL(true, "nevercryair.local")
//                    
//                    newTrustPolicies.addObject(sslPolicy)
                    
                    
                    // ------  Load Cert
                    
                    // First load our extra root-CAs to be trusted from the app bundle.
                    
                    let rootCa = "Certificates"
                    if let rootCaPath = NSBundle.mainBundle().pathForResource(rootCa, ofType: "cer") {
                        if let rootCaData = NSData(contentsOfFile: rootCaPath) {
                            let rootCert = SecCertificateCreateWithData(nil, rootCaData)
                            let rootCerts = [rootCert!]
                            SecTrustSetAnchorCertificates(serverTrust, rootCerts)
                            SecTrustSetAnchorCertificatesOnly(serverTrust, false) // also allow regular CAs.
                        }
                    }
                    
//                    let certificates = NSMutableArray()
//                    
//                    let count = SecTrustGetCertificateCount(serverTrust)
//                    
//                    var i: CFIndex
//                    for (i = 0; i < count; i++) {
//                        let item = SecTrustGetCertificateAtIndex(serverTrust, i)
//                        
//                        certificates.addObject(item!)
//                    }
//                    
//                    var newTrust: SecTrustRef?
//                    
//                    if (SecTrustCreateWithCertificates(certificates, newTrustPolicies, &newTrust) != errSecSuccess) {
//                        
//                        print("error  Create new Trust Fail")
//                    }
                    
                    var secresult = SecTrustResultType(kSecTrustResultInvalid)
                    
                    if (SecTrustEvaluate(serverTrust, &secresult) != errSecSuccess) {
                        /* Trust evaluation failed. */
                        
                        disposition = .CancelAuthenticationChallenge
                    } else {

                        if (Int(secresult) == kSecTrustResultUnspecified ||
                            Int(secresult) == kSecTrustResultProceed) {
                                // Trust certificate.
                                credential = NSURLCredential(forTrust: serverTrust)
                                disposition = .UseCredential
                        } else {
                            NSLog("Invalid server certificate.")
                        }
                    }
                }
            }
            
            return (disposition, credential)
        }
        
        manager!.delegate.sessionDidBecomeInvalidWithError = { (session, error ) in
            print(error)
        }
    }
    
    // MARK: Debug Print 
    
    func debugPrintsResut(response: Response<AnyObject, NSError>) {
        debugPrint(response)
        // debug
        print(response.request)  // original URL request
        print(response.response) // URL response
        print(NSString(data: response.data!, encoding: NSUTF8StringEncoding))     // server data
        print(response.result)   // result of response serialization
       
        
        if let JSON = response.result.value {
            print("JSON: \(JSON)")
        }
        
        
    }
    
    // MARK: - API
    // MARK: 获取验证码
    // parameters: ["mobile":"输入手机号码“,"smsType":"Login"/*登录*/|"Regist"/*注册*/]
    
    func sendSMS(parameters:[String:String], completionHandler:(Response<String, NSError>)->Void) {
        
        NetworkManager.sharedInstance.manager!.request(.POST, Domain.sendSMS, parameters: parameters, encoding: .URLEncodedInURL, headers: Domain.headers).validate().responseString(encoding: NSUTF8StringEncoding) { response in
            
            // debug
            debugPrint(response)
            print("Response String: \(response.result.value)")
            completionHandler(response)
        }
    }
    
    // MARK: 注册
    // parameters: ["mobile":"输入手机号码“,"verify_code":"输入4位验证码","username":"输入用户名6-20位字母数字组合"]
    func regist(parameters:[String:String], completionHandler:(Response<AnyObject, NSError>)->Void) {
        NetworkManager.sharedInstance.manager!.request(.POST, Domain.regist, parameters: parameters, encoding: .URLEncodedInURL, headers: Domain.headers).validate().responseJSON { response in
            // debug
            self.debugPrintsResut(response)
            completionHandler(response)
        }
    }
    
    // MARK: 登录
    // parameters: ["mobile":"输入手机号码“,"verify_code":"输入4位验证码"]
    func login(parameters:[String:String], completionHandler:(Response<AnyObject, NSError>)->Void) {
        NetworkManager.sharedInstance.manager!.request(.POST, Domain.login, parameters: parameters, encoding: .URLEncodedInURL, headers: Domain.headers).validate().responseJSON { response in
            // debug
            self.debugPrintsResut(response)
            completionHandler(response)
        }
    }

}



