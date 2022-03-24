//
//  occupationAPI.swift
//  occupations licence
//
//  Created by Mohamed Ali on 17/10/2021.
//

import Foundation

class occupationAPI: BaseAPI<occupationNetworking> {
    
    // MARK:- TODO:- This Method For Fetch All occupation in DataBase.
    func FetchAlloccupations(completion: @escaping (Result<occupationResponse?,NSError>) -> Void) {
        self.fetchData(Target: .getAlloccupation, ClassName: occupationResponse.self) { response in
            completion(response)
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Getting Occupation Details in DataBase.
    func FetchOccupationDetails (occupId: String , completion: @escaping (Result<occupationResponse?,NSError>) -> Void) {
        self.fetchData(Target: .getOccupationDetails(id: occupId), ClassName: occupationResponse.self) { response in
            completion(response)
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Search occupation with occup_Type.
    func SearchOccupationWithType (occupType: String , completion: @escaping (Result<occupationResponse?,NSError>) -> Void) {
        self.fetchData(Target: .SearchWithType(type: occupType), ClassName: occupationResponse.self) { response in
            completion(response)
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Check Distance Between the current location and distanation.
    func CheckDistance(code: String, lati: String, long: String, completion: @escaping (Result<occupationResponse?,NSError>) -> Void) {
        self.fetchData(Target: .checkDistance(code: code, lati: lati, long: long), ClassName: occupationResponse.self) { response in
            completion(response)
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Getting Next Page of occupations.
    func GetNextPage(uri: String,completion: @escaping (Result<occupationResponse?,NSError>) -> Void) {
        self.fetchData(Target: .NextPage(uri: uri), ClassName: occupationResponse.self) { response in
            completion(response)
        }
    }
    // ------------------------------------------------
    
}
