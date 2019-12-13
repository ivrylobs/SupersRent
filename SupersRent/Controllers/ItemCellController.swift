import UIKit

protocol ItemCellControllerDelegate {
    func didChageAmount(product: ProductModel, itemLabel: String, itemAmount: Double)
}

class ItemCellController: UITableViewCell {
    
    var productInfo: ProductModel?
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var delegate: ItemCellControllerDelegate?
    
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
        self.delegate?.didChageAmount(product: self.productInfo!, itemLabel: self.itemLabel.text!, itemAmount: Double(self.quantityLabel.text!)!)
    }
    
    @IBAction func increaseQuantity(_ sender: UIButton) {
        var amount = Int(self.quantityLabel.text!)!
        if amount == 99 {
            amount = 99
        } else {
            amount += 1
        }
        self.quantityLabel.text = String(amount)
        self.delegate?.didChageAmount(product: self.productInfo!, itemLabel: self.itemLabel.text!, itemAmount: Double(self.quantityLabel.text!)!)
    }
    
}
