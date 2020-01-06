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
		self.productAmount = amount
		self.quantityLabel.text = String(self.productAmount)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
	}
	
	override func prepareForReuse() {
		if ItemSelectController.orderItems.count == 0 {
			changeAmountLabel(amount: 0)
		} else {
			for item in ItemSelectController.orderItems {
				if item.id == self.productInfo?.id {
					changeAmountLabel(amount: item.productRent)
				} else {
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
