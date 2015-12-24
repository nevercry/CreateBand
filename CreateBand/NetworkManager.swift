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
    
    func sendSMS(mobile: String, andSMSType smsType: String) {
        
       
        
//        // GET
//          NetworkManager.sharedInstance.manager!.request(.GET, "http://nevercryair.local/createband/sendSMS.php?mobile=\(mobile)&smsType=\(smsType)").responseData({ (resp) -> Void in
//            let string = String.init(data: resp.data!, encoding: NSUTF8StringEncoding)
//            
//            print("Test Respoinse is \(string)")
//        })
        
        let parameters = ["mobile":mobile,"smsType":smsType]
        
        NetworkManager.sharedInstance.manager!.request(.POST, "https://nevercryair.local/createband/sendSMS.php", parameters: parameters, encoding: .URLEncodedInURL, headers: ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"]).responseData({ (resp) -> Void in
            let string = String.init(data: resp.data!, encoding: NSUTF8StringEncoding)
            
            print("Test Respoinse is \(string)")
        })
        
        return
    }
    
}



