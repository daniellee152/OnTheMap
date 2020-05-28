//
//  PostSession.swift
//  OnTheMap
//
//  Created by Le Dat on 5/28/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import Foundation

struct Udacity : Codable {
    let username : String
    let password : String
}

struct LoginRequest : Codable {
    let udacity : Udacity
}
