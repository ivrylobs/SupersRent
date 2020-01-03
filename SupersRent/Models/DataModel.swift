import KDCalendar

struct GroupModel {
    let groupId:String
    let groupName:String
}

struct LocationModel {
    let provinceName:String
    let districtName:String
}

struct DateModel {
    let firstDate:Date
    let finalDate:Date
}

struct CategoryProduct {
    let categoryName:String
    let groupId:String
    let productItem:[ProductModel]
}

struct ProductModel {
    let id:String
    let productCategory:String
    let productGroup:String
    let productId:String
    let productSize:String
    let productRentPrice:Double
    let productQuantity:Double
}

struct Customer {
    let firstName:String
    let lastName:String
    let phoneNumber:String
    let email:String
}

struct OrderModel {
    let id:String
    let productCategory:String
    let productGroup:String
    let productId:String
    let productSize:String
    let productRentPrice:Double
    var productRent:Int
    let productQuantity:Double
    var productBalance:Int
    var totalForItem:String
	
	mutating func changeAmount(itemAmount: Int) {
		self.productRent = itemAmount
		self.productBalance = itemAmount
		self.totalForItem = String(format: "%.2f", self.productRentPrice * Double(itemAmount))
	}
}

struct OrderSummary {
    let orderAllItemBalance:Int
    let orderAllTotalAndVAT:Double
    let orderContractEndFormat:String
    let orderContractStart:String
    let orderContractStartFormat:String
    let orderCustomer:Customer
    let orderDate:String //Date that order created
    let orderItemAllTotal:Double
    let orderItemTotal:Double //Total Price
    let orderItems:[OrderModel]
    let orderLocationDistrict:String
    let orderLocationProvince:String
    let orderNumberOfItem:Int
    let orderNumberOfItemOrder:Int
    let orderStatus:Bool
    let orderTimeRent:Int
    let orderVAT:Double
    
}
