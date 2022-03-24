//
//  occupationResponse.swift
//  occupations licence
//
//  Created by Mohamed Ali on 17/10/2021.
//

import Foundation

// MARK: - UserResponse
struct occupationResponse: Codable {
    let status: Int
    let messageEng: String
    let distanceMeter: String?
    let numberofOccupations: Int?
    let next: NextModel?
    let occupation: [OccupationModel]?
}
