import UIKit

class SearchItemController: UIViewController {
    
    var productData: [ProductModel]?
    var categoryData: [ProductModel] = []
    
    //Create SearchParam.
    var searchGroup: GroupModel?
    var searchLocation: LocationModel?
    var searchDate: DateModel?
    
    @IBOutlet weak var productTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareCategoryData()
        self.productTable.register(UINib(nibName: "ProductItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        self.productTable.dataSource = self
        self.productTable.delegate = self
                
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func prepareCategoryData() {
        for items in self.productData! {
            if items.groupId == self.searchGroup?.groupId {
                self.categoryData.append(items)
            } else {
                print("Not match")
            }
        }
    }
}

extension SearchItemController: ProductItemCellDelegate {
    func didChageAmount(product: ProductItem, itemLabel: String, itemAmount: Double) {
        print("\(product) Amount: \(itemAmount)")
    }
}

extension SearchItemController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.text = "    \(self.categoryData[section].categoryName)"
        header.backgroundColor = UIColor(rgb: ColorString.BlackGrey)
        header.textColor = UIColor(rgb: ColorString.White)
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categoryData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.categoryData[section].productItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.productTable.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ProductItemCell
        cell.delegate = self
        cell.productInfo = self.categoryData[indexPath.section].productItem[indexPath.row]
        cell.itemLabel.text = " \(self.categoryData[indexPath.section].productItem[indexPath.row].productId)  ขนาด: \(self.categoryData[indexPath.section].productItem[indexPath.row].productSize)"
        cell.noteLabel.text = " ราคาเช่า (บาท/วัน):  \(self.categoryData[indexPath.section].productItem[indexPath.row].productRentPrice)"
        return cell
    }
    
}

extension SearchItemController: UITableViewDelegate {

}
