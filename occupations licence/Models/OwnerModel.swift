//
//  OwnerModel.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import Foundation

// MARK: - Owners
struct OwnerModel: Codable {
    let id , id1: Int
    let ownerNameAr: String
    let birthDate: String?
    let address: String?
    let ssn: String?
    let telNumber: String?
    let ownerType: String

    enum CodingKeys: String, CodingKey {
        case id1 = "ID1"
        case id = "ID"
        case ownerNameAr
        case birthDate = "birth_date"
        case address, ssn
        case telNumber = "tel_number"
        case ownerType = "owner_type"
    }
}
