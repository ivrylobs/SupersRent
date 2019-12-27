//
//  RentTimeCell.swift
//  SupersRent
//
//  Created by ivrylobs on 14/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import UIKit

class RentTimeCell: UITableViewCell {

    @IBOutlet weak var dateTimeStart: UILabel!
    @IBOutlet weak var dateTimeEnd: UILabel!
    @IBOutlet weak var rentDuration: UILabel!
    @IBOutlet weak var itemAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
