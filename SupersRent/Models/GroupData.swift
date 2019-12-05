//
//  CategoryModel.swift
//  SupersRent
//
//  Created by ivrylobs on 5/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct GroupModel {
    let groupId:Int
    let groupName:String
}

protocol GetGroupDataDelegate {
    func didGetGroupData(groupData: [GroupModel])
}

struct GetGroupData {
    
    let groupUrl = "https://api.supersrent.com/app-user/api/test/getGroup"
    var delegate: GetGroupDataDelegate?
    
    func getProductGroup() {
        Alamofire.request(groupUrl).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data)
                var groupData: [GroupModel] = []
                for json in jsonData.arrayValue {
                    print("ID: \(json["groupID"].intValue)  Name: \(json["groupName"])")
                    groupData.append(GroupModel(groupId: json["groupID"].intValue, groupName: json["groupName"].stringValue))
                }
                self.delegate?.didGetGroupData(groupData: groupData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
