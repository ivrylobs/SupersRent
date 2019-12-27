//
//  UserInfoCell.swift
//  SupersRent
//
//  Created by ivrylobs on 13/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var sirName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
