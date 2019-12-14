import UIKit

protocol ItemCellControllerDelegate {
    func didChageAmount(product: ProductModel, itemAmount: Double)
}

class ItemCell: UITableViewCell {
    
    var productInfo: ProductModel?
    var productAmount: Int = 0
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var delegate: ItemCellControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.quantityLabel.text = String(self.productAmount)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func decreaseQuantity(_ sender: UIButton) {
        if self.productAmount == 0 {
            self.productAmount = 0
        } else {
            self.productAmount -= 1
        }
        //print("Decrease: \(self.productAmount)")
        self.quantityLabel.text = String(self.productAmount)
        self.delegate?.didChageAmount(product: self.productInfo!, itemAmount: Double(self.productAmount))
    }
    
    @IBAction func increaseQuantity(_ sender: UIButton) {
       if self.productAmount == 99 {
            self.productAmount = 99
        } else {
            self.productAmount += 1
        }
        //print("Increase: \(self.productAmount)")
        self.quantityLabel.text = String(self.productAmount)
        self.delegate?.didChageAmount(product: self.productInfo!, itemAmount: Double(self.productAmount))
    }
}
