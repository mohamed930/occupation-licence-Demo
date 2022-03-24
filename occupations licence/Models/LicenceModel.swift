//
//  LicenceModel.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import Foundation

// MARK: - Licenses
struct LicenseModel: Codable {
    let id,id1: Int
    let licenseID: String?
    let licenseFee: Double
    let receiptNum: String?
    let licenseStart, licenseEnd: String
    let previewerName: String?
    let details: String?

    enum CodingKeys: String, CodingKey {
        case id1 = "ID1"
        case id
        case licenseID = "license_id"
        case licenseFee = "license_fee"
        case receiptNum = "receipt_num"
        case licenseStart = "license_start"
        case licenseEnd = "license_end"
        case previewerName = "previewer_name"
        case details
    }
}
