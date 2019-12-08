import KDCalendar

struct GroupModel {
    let groupId:Int
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

struct ProductModel {
    let categoryName:String
    let groupId:Int
    let productItem:[ProductItem]
}

struct ProductItem {
    let productName:String
    let productId:String
    let productSize:String
    let productRentPrice:Double
    let productQuantity:Double
}
