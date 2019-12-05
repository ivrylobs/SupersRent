import Alamofire
import SwiftyJSON

struct LocationModel {
    let provinceName:String
    let districtName:String
}

protocol GetLocationDataDelegate {
    func didGetLocationData(locationData: [LocationModel])
}

struct GetLocationData {
    
    let locationUrl = "https://api.supersrent.com/app-user/api/address/getAll"
    var delegate: GetLocationDataDelegate?
    
    func getProductGroup() {
        Alamofire.request(locationUrl).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data)
                //var locationData: [LocationModel] = []
                for json in jsonData.arrayValue {
                    print(json)
                }
                //self.delegate?.didGetLocationData(locationData: locationData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
