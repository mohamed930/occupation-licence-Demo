//
//  OccupationModel.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import Foundation

// MARK: - Occupation
struct OccupationModel: Codable {
    let id: Int
    let occupationsCoverURL: String
    let name: String?
    let nameAr : namrAR
    let occupCategory: String
    let addressAr: String
    let currentActivity: String
    let neighborhoodAra: Int
    let occupCode: String?
    let caseoccup: String
    let latitude, longitude: Double
    let currentArea: Double // Hint licenseArea to Int
    let licenseArea: Int
    let documents: String
    let userAddedID: Int
    let fileID: String?
    let tel: String?
    let owners: [OwnerModel]?
    let licenses: LicenseModel?
    let infractions: [InfractionModel]?
    let users: UserLoginModel?
    let tempinfractions: [InfractionModel]?

    enum CodingKeys: String, CodingKey {
        case id
        case occupationsCoverURL = "occupationsCoverUrl"
        case nameAr, name
        case occupCategory = "occup_category"
        case addressAr, neighborhoodAra
        case currentActivity = "current_activity"
        case occupCode = "occup_code"
        case caseoccup = "case_occup"
        case latitude = "lati"
        case longitude = "longi"
        case currentArea = "current_area"
        case licenseArea = "license_area"
        case documents
        case userAddedID = "userAddedId"
        case fileID = "file_id"
        case tel
        case owners, licenses, infractions
        case users , tempinfractions
    }
    
    func HandleName() -> String {
        switch nameAr {
            
        case .A:
            return  "بنك وفاترينه"
        case .B:
            return  "تجمع"
        case .C:
            return  "فاترينة"
        case .D:
            return  "كارافانات"
        case .E:
            return  "كشك"
        case .F:
            return "كشك وتلاجة"
        case .G:
            return  "فاترينة و تلاجة"
        case .H:
            return  "كشك و فاترينة"
        case .J:
            return  "أمن غذائى"
        case .K:
            return  "فرش أمام الغير"
        case .L:
            return  "منفذ"
        case .empty:
            return "كشك"
        }
    }
    
    func HandleCatagory() -> String {
        switch occupCategory {
            case "S":
                return "سياحى"
            case "T":
                return "تجارى"
            case "P":
                return "تحت باكيه"
            default:
                return "شعبى"
        }
    }
    
    func HandleNeighbourhoodName() -> String {
        switch neighborhoodAra {
        case 1:
            return "الشرق"
        default:
            return "العرب"
        }
    }
}
