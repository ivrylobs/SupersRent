import UIKit

class ProductItemCell: UITableViewCell {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func decreaseQuantity(_ sender: UIButton) {
        var amount = Int(self.quantityLabel.text!)!
        if amount == 0 {
            amount = 0
        } else {
            amount -= 1
        }
        self.quantityLabel.text = String(amount)
    }
    
    @IBAction func increaseQuantity(_ sender: UIButton) {
        var amount = Int(self.quantityLabel.text!)!
               if amount == 99 {
                   amount = 99
               } else {
                   amount += 1
               }
               self.quantityLabel.text = String(amount)
    }
}
