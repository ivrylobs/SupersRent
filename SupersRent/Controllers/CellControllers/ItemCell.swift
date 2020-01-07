import UIKit

protocol ItemCellControllerDelegate {
	func didChageAmount(tableCellItem: ItemCell, product: ProductModel, inputType: String)
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
        
    }
	
	func changeAmountLabel(amount: Int) {
		print("Change Amount")
		self.productAmount = amount
		self.quantityLabel.text = String(self.productAmount)
	}
	
	override func prepareForReuse() {
		print(ItemSelectController.orderItems)
		if ItemSelectController.orderItems.count == 0 {
			changeAmountLabel(amount: 0)
		} else {
			for item in ItemSelectController.orderItems {
				if item.id == self.productInfo?.id {
					print("Match Product Order")
					print(item.productRent)
					changeAmountLabel(amount: item.productRent)
				} else {
					print("Not Match Product Order")
					changeAmountLabel(amount: 0)
				}
			}
		}
	}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func decreaseQuantity(_ sender: UIButton) {
		self.delegate?.didChageAmount(tableCellItem: self, product: self.productInfo!, inputType: "decrease")
    }
    
    @IBAction func increaseQuantity(_ sender: UIButton) {
		self.delegate?.didChageAmount(tableCellItem: self, product: self.productInfo!, inputType: "increase")
    }
}
