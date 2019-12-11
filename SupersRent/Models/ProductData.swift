import Alamofire
import SwiftyJSON

protocol GetProductDataDelegate {
    func didGetProductData(productData: [CategoryProduct])
}

struct GetProductData {
    
    let productUrl = "https://api.supersrent.com/app-user/api/product/home/getCategoryProduct"
    var delegate: GetProductDataDelegate?
    
    func getProduct() {
        Alamofire.request(productUrl).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data)
                var productData: [CategoryProduct] = []
                for json in jsonData.arrayValue {
                    var productItem: [ProductModel] = []
                    for item in json["productHome"].arrayValue {
                        productItem.append(ProductModel(id: item["id"].stringValue,
                                                        productCategory: item["category"].stringValue,
                                                        productGroup: item["group"].stringValue,
                                                        productId: item["productId"].stringValue,
                                                        productSize: item["productSize"].stringValue,
                                                        productRentPrice: item["productRentPrice"].doubleValue,
                                                        productQuantity: item["productQuantity"].doubleValue))
                    }
                    productData.append(CategoryProduct(categoryName: json["categoryName"].stringValue,
                                                    groupId: json["group"].stringValue,
                                                    productItem: productItem))
                }
                self.delegate?.didGetProductData(productData: productData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
