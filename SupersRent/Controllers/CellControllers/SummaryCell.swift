//
//  SummaryCell.swift
//  SupersRent
//
//  Created by ivrylobs on 14/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import UIKit

class SummaryCell: UITableViewCell {

    @IBOutlet weak var totalPricePerDay: UILabel!
    @IBOutlet weak var totalPriceAll: UILabel!
    @IBOutlet weak var taxPrice: UILabel!
    @IBOutlet weak var almostTotalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
