//
//  userAPI.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import Foundation

class userAPI: BaseAPI<userNetworking> {
    
    // MARK:- TODO:- This Method For Login with Email & password
    func loginWithEmailAndPassword(email: String, password: String,completion: @escaping (Result<UserLoginResponse?,NSError>) -> Void) {

        self.fetchData(Target: .loginwithEmail(email: email, password: password), ClassName: UserLoginResponse.self) { response in
            completion(response)
        }

    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Login with UserName & password
    func loginWithUserNameAndPassword(userName: String, password: String,completion: @escaping (Result<UserLoginResponse?,NSError>) -> Void) {

        self.fetchData(Target: .loginwithUserName(userName: userName, password: password), ClassName: UserLoginResponse.self) { response in
            completion(response)
        }

    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Send Email To User To Verifiy his email to make sure accept to update password
    func forgetPassword(email: String, completion: @escaping (Result<UserLoginResponse?,NSError>) -> Void) {
        
        self.fetchData(Target: .forgetPassword(Email: email), ClassName: UserLoginResponse.self) { response in
            completion(response)
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Update Password for user
    func UpdatePassword(email: String, passwrod: String, completion: @escaping (Result<UserLoginResponse?,NSError>) -> Void) {
        
        self.fetchData(Target: .updatePassword(email: email, password: passwrod), ClassName: UserLoginResponse.self) { response in
            completion(response)
        }
        
    }
    // ------------------------------------------------
}
