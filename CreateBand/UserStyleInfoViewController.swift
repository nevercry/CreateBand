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
    var selectedButtons: [UIButton] = []
    
    @IBOutlet weak var typeSegment: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func buttonPressed(sender: UIButton) {
        // 检查 sender 是否已选中
        if sender.selected {
            sender.selected = false
            if selectedButtons.contains(sender) {
                let index = selectedButtons.indexOf(sender)
                selectedButtons.removeAtIndex(index!)
            }
        } else {
            // 检查 selecteButtons 是否已经含有三个
            if selectedButtons.count == 3 {
                return
            }
            
            sender.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            sender.selected = true
            selectedButtons.append(sender)
        }
        
        checkParmaSatisfied()
    }
    
    @IBAction func selectUserType(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            userType = UserType.School
        case 1:
            userType = UserType.Freelance
        default:
            userType = nil
        }
        
        checkParmaSatisfied()
    }
    
    
    

    // MARK: Custom Methods
    
    func checkParmaSatisfied() {
        parentViewController?.performSelector("checkParmaSatisfied")
    }
    
    func musicStyles() -> [MusicStyle]? {
       return selectedButtons.map({ MusicStyle(rawValue: $0.tag)!
       })
    }
    

}
