//
//  InvitableFriends.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/14/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import UIKit

class InvitableFriendsData {
    
    var friends = [Friend]()

    init(result: Any?) {
        if let data = (result as? [String: Any])?["data"] {
            if let data = data as? [[String: Any]] {
                for item in data {
                    let f = Friend(data: item)
                    self.friends.append(f)
                }
            }
        }
    }
}

class Friend {
    
    var id: String
    var name: String
    var picture: PictureData
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.picture = PictureData(data: data["picture"])
    }
}

class PictureData {
    
    var is_silhouette: Bool = false
    var url: String = ""
    
    init(data: Any?) {
        if let data = (data as? [String: Any])?["data"] {
            if let data = data as? [String: Any] {
                self.is_silhouette = data["is_silhouette"] as? Bool ?? false
                self.url = data["url"] as? String ?? ""
            }
        }
    }
}
