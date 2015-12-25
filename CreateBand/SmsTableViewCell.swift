//
//  SmsTableViewCell.swift
//  CreateBand
//
//  Created by nevercry on 12/19/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import UIKit

class SmsTableViewCell: UITableViewCell {

    @IBOutlet weak var requestSMSButton: UIButton!
    @IBOutlet weak var smsTextField: UITextField!
    @IBOutlet weak var lastCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        requestSMSButton.addTarget(self, action: "countSeconds:", forControlEvents: .TouchUpInside)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var timeRemaining = 59 {
        didSet {
            lastCountLabel?.text = "等待\(timeRemaining)s"
        }
    }
    
    func countSeconds(sender: UIButton) {
        sender.hidden = true
        lastCountLabel?.hidden = false
        lastCountLabel?.text = "等待\(timeRemaining)s"
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateLastCountLabel:", userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func updateLastCountLabel(timer: NSTimer) {
        if timeRemaining == 0 {
            timer.invalidate()
            requestSMSButton?.hidden = false
            lastCountLabel?.hidden = true
            timeRemaining = 59
        } else {
            timeRemaining--
        }
    }

}
