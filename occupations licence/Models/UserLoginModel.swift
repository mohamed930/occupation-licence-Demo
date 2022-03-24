//
//  UserLoginModel.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import Foundation

struct UserLoginModel: Codable {
    let id: Int
    let userName, email: String
    let numberofOccupation: Int?
    let next: NextModel?
//    let occupation: [OccupationModel]?
    let occup: [OccupationModel]?
}
