//
//  occupationNetworking.swift
//  occupations licence
//
//  Created by Mohamed Ali on 17/10/2021.
//

import Foundation
import Alamofire

enum occupationNetworking {
    
    case getAlloccupation
    case getOccupationDetails(id: String)
    case SearchWithType(type: String)
    case checkDistance(code: String, lati: String, long: String)
    case NextPage(uri: String)
    
}

extension occupationNetworking: TargetType {
    
    var baseURL: String {
        switch self {
        
        case .getAlloccupation:
            return baseurl
        case .getOccupationDetails:
            return baseurl
        case .SearchWithType:
            return baseurl
        case .checkDistance:
            return baseurl
        case .NextPage(let uri):
            return uri
        }
    }
    
    var path: String {
        switch self {
        case .getAlloccupation:
            return occupationEndPoint
        case .getOccupationDetails(let id):
            return occupationEndPoint + "/\(id)"
        case .SearchWithType:
            return occupationEndPoint
        case .checkDistance:
            return occupationEndPoint
        case .NextPage:
            return ""
        }
        
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        switch self {
        
        case .getAlloccupation:
            return .requestPlain
            
        case .getOccupationDetails:
            return .requestPlain
            
        case .SearchWithType(let type):
            let params = ["occupationType": type]
            return .requestParameters(parameters: params, encoding: URLEncoding(destination: .queryString))
            
        case .checkDistance(let code, let lati, let long):
            let params = ["code": code, "lati": lati , "long": long]
            return .requestParameters(parameters: params, encoding: URLEncoding(destination: .queryString))
            
        case .NextPage:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
