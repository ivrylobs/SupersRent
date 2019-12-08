import Alamofire
import SwiftyJSON

protocol GetProductDataDelegate {
    func didGetProductData(productData: [ProductModel])
}

struct GetProductData {
    
    let productUrl = "https://api.supersrent.com/app-user/api/product/home/getCategoryProduct"
    var delegate: GetProductDataDelegate?
    
    func getProduct() {
        Alamofire.request(productUrl).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data)
                var productData: [ProductModel] = []
                for json in jsonData.arrayValue {
                    var productItem: [ProductItem] = []
                    for item in json["productHome"].arrayValue {
                        productItem.append(ProductItem(productName: item["category"].stringValue, productId: item["productId"].stringValue, productSize: item["productSize"].stringValue, productRentPrice: item["productRentPrice"].doubleValue, productQuantity: item["productQuantity"].doubleValue))
                    }
                    productData.append(ProductModel(categoryName: json["categoryName"].stringValue, groupId: json["group"].intValue, productItem: productItem))
                }
                self.delegate?.didGetProductData(productData: productData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
