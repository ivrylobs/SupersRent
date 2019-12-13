//
//  PriceSummaryCell.swift
//  SupersRent
//
//  Created by ivrylobs on 13/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import UIKit

class PriceSummaryCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var summaryPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
