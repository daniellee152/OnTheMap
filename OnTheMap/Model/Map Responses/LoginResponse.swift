//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Le Dat on 5/28/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import Foundation

struct Account : Codable {
    let registered : Bool
    let key : String
}

struct Session : Codable {
    let id : String
    let expiration : String
}


struct LoginResponse : Codable {
    let account : Account
    let session : Session
}
