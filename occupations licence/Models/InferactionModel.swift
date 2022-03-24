//
//  InferactionModel.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import Foundation

// MARK: - Infractions
struct InfractionModel: Codable {
    let id, id1: Int
    let occup_category: String
    let typeofinfraction: String
    let infraction: Float // hint to Int
    let infraDate: String?
    let occupID: String?
    let useradded: Int
    let caseOccup, caseOccupDo, payCase: String?
    let Notes: String

    enum CodingKeys: String, CodingKey {
        case id , typeofinfraction, infraction, occup_category
        case id1 = "ID1"
        case infraDate = "infra_date"
        case occupID = "occup_id"
        case useradded
        case caseOccup = "case_occup"
        case caseOccupDo = "case_occup_do"
        case payCase = "pay_case"
        case Notes
    }
}
