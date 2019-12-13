//
//  SummaryItemCell.swift
//  SupersRent
//
//  Created by ivrylobs on 13/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import UIKit

class SummaryItemCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var itemIdLabel: UILabel!
    @IBOutlet weak var itemSizeLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    @IBOutlet weak var itemAmount: UILabel!
    @IBOutlet weak var itemTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
