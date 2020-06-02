//
//  StudentLocationRequest.swift
//  OnTheMap
//
//  Created by Le Dat on 6/1/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import Foundation

struct StudentLocationRequest : Codable{
    let uniqueKey : String
    let firstName : String
    let lastName : String
    let mapString : String
    let mediaURL : String
    let latitude : Double
    let longitude : Double
}
