//
//  VerificationViewModel.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import Foundation
import RxSwift
import RxRelay

class VerificationViewModel {
    
    var tockenBehaviour = BehaviorRelay<String>(value: "")
    var emailBehaviour = BehaviorRelay<String>(value: "")
    
    var digitoneBehaviour = BehaviorRelay<String>(value: "")
    var digittwoBehaviour = BehaviorRelay<String>(value: "")
    var digitthreeBehaviour = BehaviorRelay<String>(value: "")
    var digitfourBehaviour = BehaviorRelay<String>(value: "")
    
    var sendedTockenBehaviour = BehaviorRelay<String>(value: "")
    
    var isloadingBehaviour = BehaviorRelay<Bool>(value: false)
    var responseBehaviour = BehaviorRelay<Bool?>(value: nil)
    
    var responseSendAgainBehaviour = BehaviorRelay<Bool?>(value: nil)
    
    let user = userAPI()
    
    // MARK:- TODO:- This Method For Verify Code Operation
    func VerifyCodeOperation() {
        if tockenBehaviour.value == sendedTockenBehaviour.value {
            responseBehaviour.accept(true)
        }
        else {
            responseBehaviour.accept(false)
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Send Code Again to user.
    func SendCodeAgainOperation() {
        
        isloadingBehaviour.accept(true)
        
        user.forgetPassword(email: emailBehaviour.value) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let success):
                guard let success = success else { return }
                if success.status == 1 {
                    self.responseSendAgainBehaviour.accept(true)
                    self.tockenBehaviour.accept(success.tocken!)
                    self.isloadingBehaviour.accept(false)
                }
            case .failure(let error):
                self.responseSendAgainBehaviour.accept(false)
                self.isloadingBehaviour.accept(false)
                self.tockenBehaviour.accept(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
        }
    }
    // ------------------------------------------------
}
