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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
