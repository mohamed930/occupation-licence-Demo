//
//  ErrorResponse.swift
//  occupation
//
//  Created by Mohamed Ali on 09/10/2021.
//

import Foundation

class ErrorResponse: Decodable {
    var status: Int
    var error: error
    
    enum CodingKeys: String,CodingKey {
        case status
        case error
    }
}

class error: Codable {
    var messageEng: String
    var messageAra: String
    var distanceMeter: String?
    
    enum CodingKeys: String,CodingKey {
        case messageEng = "messageEng"
        case messageAra = "messageAra"
        case distanceMeter
    }
}
