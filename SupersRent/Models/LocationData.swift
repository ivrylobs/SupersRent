import Alamofire
import SwiftyJSON

protocol GetLocationDataDelegate {
    func didGetLocationData(locationData: [LocationModel])
}

struct GetLocationData {
    
    let locationUrl = "https://api.supersrent.com/app-user/api/address/getAll"
    var delegate: GetLocationDataDelegate?
    
    func getLocation() {
        AF.request(locationUrl).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data)
                var locationData: [LocationModel] = []
                for json in jsonData.arrayValue {
                    for district in json["district"].arrayValue {
                        locationData.append(LocationModel(provinceName: json["name"].stringValue,
                                                          districtName: district["name"].stringValue))
                    }
                }
                self.delegate?.didGetLocationData(locationData: locationData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
