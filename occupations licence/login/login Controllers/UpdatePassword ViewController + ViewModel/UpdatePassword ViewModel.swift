//
//  UpdatePassword ViewModel.swift
//  occupations licence
//
//  Created by Mohamed Ali on 17/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

class UpdatePasswordViewModel {
    
    var PasswordBehaviour = BehaviorRelay<String>(value: "")
    
    var isloadingBehaviour = BehaviorRelay<Bool>(value: false)
    var responseMessageBehaviour = BehaviorRelay<String>(value: "")
    
    let user = userAPI()
    
    // MARK:- TODO:- Make conditions.
    var isPasswordBehaviour : Observable<Bool> {
        return PasswordBehaviour.asObservable().map { email -> Bool in
            let isEmailEmpty = email.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isEmailEmpty
        }
    }
    
    // MARK:- TODO:- This Method For Update Password Operation
    func UpdatePasswordOperation() {
        user.UpdatePassword(email: email, passwrod: PasswordBehaviour.value) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let response):
                guard let reponse = response else {
                    return
                }
                
                if reponse.status == 1 {
                    self.isloadingBehaviour.accept(false)
                    self.responseMessageBehaviour.accept(reponse.messageAra!)
                }
            case .failure(let error):
                self.isloadingBehaviour.accept(false)
                self.responseMessageBehaviour.accept(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
        }
    }
    // ------------------------------------------------
    
}
