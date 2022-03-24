//
//  userNetworking.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import Foundation
import Alamofire

enum userNetworking {
    
    case loginwithEmail(email: String , password: String)
    case loginwithUserName(userName: String, password: String)
    case forgetPassword(Email: String)
    case updatePassword(email: String ,password: String)
    
}


extension userNetworking: TargetType {
    var baseURL: String {
        switch self {
        case .loginwithEmail:
            return baseurl
        case .loginwithUserName:
            return baseurl
        case .forgetPassword:
            return baseurl
        case .updatePassword:
            return baseurl
        }
    }
    
    var path: String {
        switch self {
        
        case .loginwithEmail:
            return userEndPoint
        case .loginwithUserName:
            return userEndPoint
        case .forgetPassword:
            return userEndPoint
        case .updatePassword(let email,_):
            return userEndPoint + "?email=\(email)"
        }
        
    }
    
    var method: HTTPMethod {
        switch  self {
        case .loginwithEmail:
            return .get
        case .loginwithUserName:
            return .get
        case .forgetPassword:
            return .get
        case .updatePassword:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        
        case .loginwithEmail(let email,let password):
            
            let params = ["email": email,"password": password]
            return .requestParameters(parameters: params, encoding: URLEncoding(destination: .queryString))
            
        case .loginwithUserName(let userName,let password):
            
            let params = ["userName": userName, "passowrd": password]
            return .requestParameters(parameters: params, encoding: URLEncoding(destination: .queryString))
            
            
        case .forgetPassword(let Email):
            
            let params = ["email": Email]
            return .requestParameters(parameters: params, encoding: URLEncoding(destination: .queryString))
            
        case .updatePassword(_ ,let password):
            
            let params = ["password": password]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
