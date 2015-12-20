//
//  LoginTableViewCell.swift
//  CreateBand
//
//  Created by nevercry on 12/19/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import UIKit


class LoginTableViewCell: UITableViewCell {

    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 4
            loginButton.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


