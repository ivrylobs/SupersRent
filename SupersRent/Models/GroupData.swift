import Alamofire
import SwiftyJSON

protocol GetGroupDataDelegate {
    func didGetGroupData(groupData: [GroupModel])
}

struct GetGroupData {
    
    let groupUrl = "https://api.supersrent.com/app-user/api/test/getGroup"
    var delegate: GetGroupDataDelegate?
    
    func getGroup() {
        Alamofire.request(groupUrl).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data)
                var groupData: [GroupModel] = []
                for json in jsonData.arrayValue {
                    groupData.append(GroupModel(groupId: json["groupID"].intValue,
                                                groupName: json["groupName"].stringValue))
                }
                self.delegate?.didGetGroupData(groupData: groupData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
