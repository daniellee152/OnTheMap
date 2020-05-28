//
//  UdacityErrorResponse.swift
//  OnTheMap
//
//  Created by Le Dat on 5/28/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import Foundation

struct UdacityErrorResponse: Codable, Error {
    let status: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message = "error"
    }
}

extension UdacityErrorResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}


