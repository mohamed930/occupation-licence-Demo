//
//  UserLoginResponse.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import Foundation

struct UserLoginResponse: Codable {
    let status: Int
    let messageEng:String?
    let messageAra, tocken: String?
    let message: String?
    let user: UserLoginModel?
}
