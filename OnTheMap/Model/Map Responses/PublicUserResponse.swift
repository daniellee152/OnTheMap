//
//  PublicUserResponse.swift
//  OnTheMap
//
//  Created by Le Dat on 6/1/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import Foundation

struct PublicUserResponse : Codable {
    let user : User
}

struct User : Codable {
    let lastName : String
    let firstName : String
    
    enum CodingKeys : String, CodingKey{
        case lastName = "last_name"
        case firstName = "first_name"
    }
}
