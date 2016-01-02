//
//  UserStyleInfoViewController.swift
//  CreateBand
//
//  Created by nevercry on 1/1/16.
//  Copyright © 2016 nevercry. All rights reserved.
//

import UIKit

class UserStyleInfoViewController: UIViewController {
    
    var userType: UserType?
    var selectedButtons: [UIButton]?
    
    @IBOutlet weak var typeSegment: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedButtons = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func buttonPressed(sender: UIButton) {
        
    }
    

    // MARK: Custom Methods
    
    

}
