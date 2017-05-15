//
//  Friend.swift
//  Test VK
//
//  Created by Stepan Chegrenev on 12.05.17.
//  Copyright © 2017 Stepan Chegrenev. All rights reserved.
//

import UIKit

class Friend: NSObject {
    
    let firstName: String?
    let lastName: String?
    let userID: String?
    let photo: String?
    let photoID: String?
    
    init(aFirstName: String, aLastName: String, aPhoto: String, aUserID: String, aPhotoID: String) {
        firstName = aFirstName
        lastName = aLastName
        photo = aPhoto
        userID = aUserID
        photoID = aPhotoID
    }
    
}
