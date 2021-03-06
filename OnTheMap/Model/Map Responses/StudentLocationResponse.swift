//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by Le Dat on 6/1/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import Foundation

struct StudentLocationResponse : Codable{
    let results : [StudentInfo]
}

struct StudentInfo :Codable {
    let createdAt : String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
