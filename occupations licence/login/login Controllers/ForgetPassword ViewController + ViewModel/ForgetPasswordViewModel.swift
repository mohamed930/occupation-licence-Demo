//
//  ForgetPasswordViewModel.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

class ForgetPasswordViewModel {
 
    var EmailBehaviour = BehaviorRelay<String>(value: "")
    var isloadingBehaviour = BehaviorRelay<Bool>(value: false)
    var tocken = BehaviorRelay<String>(value: "")
    
    // MARK:- TODO:- init API varible.
    let user = userAPI()
    
    // MARK:- TODO:- Make conditions.
    var isEmailBehaviour : Observable<Bool> {
        return EmailBehaviour.asObservable().map { email -> Bool in
            let isEmailEmpty = email.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isEmailEmpty
        }
    }
    
    // MARK:- TODO:- This Method For Send Email Verification to user.
    func SendEmailVerification() {
        
        isloadingBehaviour.accept(true)
        
        user.forgetPassword(email: EmailBehaviour.value) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let success):
                guard  let success = success else {
                    return
                }
                if success.status == 1 {
                    email = self.EmailBehaviour.value
                    self.tocken.accept(success.tocken!)
                    self.isloadingBehaviour.accept(false)
                }
            case .failure(let error):
                self.isloadingBehaviour.accept(false)
                self.tocken.accept(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
            
        }
    }
    // ------------------------------------------------
}
