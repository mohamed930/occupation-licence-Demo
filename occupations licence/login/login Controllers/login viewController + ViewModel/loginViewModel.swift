//
//  loginViewModel.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

class loginViewModel {
    
    // MARK:- TODO:- This Section for init RxVarbiles.
    var EmailBehaviour = BehaviorRelay<String>(value: "")
    var PasswordBehaviour = BehaviorRelay<String>(value: "")
    
    var isloadingBehaviour = BehaviorRelay<Bool>(value: false)
    var loginResponseBehaviour = BehaviorRelay<String>(value: "")
    
    
    // MARK:- TODO:- init API varible.
    let user = userAPI()
    
    // MARK:- TODO:- Make conditions.
    var isEmailBehaviour : Observable<Bool> {
        return EmailBehaviour.asObservable().map { email -> Bool in
            let isEmailEmpty = email.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isEmailEmpty
        }
    }
    
    var isPasswordBehaviour : Observable<Bool> {
        return PasswordBehaviour.asObservable().map { password -> Bool in
            let isPasswordEmpty = password.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isPasswordEmpty
        }
    }
    
    var isLoginButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isEmailBehaviour,isPasswordBehaviour) {
            emailEmpty , passwordEmpty  in
            let loginValid = !emailEmpty && !passwordEmpty
            
            return loginValid
        }
    }
    
    // MARK:- TODO:- This Method For Login With Email & Password
    func loginWithEmailOperation() {
        
        isloadingBehaviour.accept(true)
        
        user.loginWithEmailAndPassword(email: EmailBehaviour.value, password: PasswordBehaviour.value) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let user):
                guard let user = user else { return }
                guard let userData = user.user else { return }
                if user.status == 1 {
                    tocken = user.tocken!
                    userId = userData.id
//                    userdata = user.userData
                    
                    let ob = SavedUserModel()
                    ob.userId = String(userData.id)
                    ob.userName = userData.userName
                    ob.userEmail = userData.email
                    ob.password = self.PasswordBehaviour.value
                    
                    // Save Data To NSUserDefaults
                    UserDefaultsMethods.SaveDataToUserDefaults(Key: currentUser, ob) { [weak self] response in
                        guard let self = self else { return }
                        if response == "Success" {
                            // send to load to stop and send response success
                            self.isloadingBehaviour.accept(false)
                            self.loginResponseBehaviour.accept(user.messageEng!)
                        }
                        else {
                            self.isloadingBehaviour.accept(false)
                            self.loginResponseBehaviour.accept("Failed")
                        }
                    }
                    /*UserDefaultsMethods.SaveDataToUserDefaults(Key: currentUser, UserLoginModel.self) { response in
                        if response == "Success" {
                            // send to load to stop and send response success
                            self.isloadingBehaviour.accept(false)
                            self.loginResponseBehaviour.accept(user.message)
                        }
                        else {
                            self.isloadingBehaviour.accept(false)
                            self.loginResponseBehaviour.accept("Failed")
                        }
                    }*/
                }
                
            case .failure(let error):
                self.isloadingBehaviour.accept(false)
                self.loginResponseBehaviour.accept(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
            
        }
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Login With UserName & Password
    func loginwithUserNameOperation() {
        
        isloadingBehaviour.accept(true)
        
        user.loginWithUserNameAndPassword(userName: EmailBehaviour.value, password: PasswordBehaviour.value) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let user):
                guard let user = user else { return }
                guard let userData = user.user else { return }
                if user.status == 1 {
                    tocken = user.tocken!
                    userId = userData.id
                    
                    // send to load to stop and send response success
                    self.isloadingBehaviour.accept(false)
                    self.loginResponseBehaviour.accept(user.messageEng!)
                    
                    // Save Data To NSUserDefaults
                    /*UserDefaultsMethods.SaveDataToUserDefaults(Key: currentUser, user.userData) { response in
                        if response == "Success" {
                            // send to load to stop and send response success
                            self.isloadingBehaviour.accept(false)
                            self.loginResponseBehaviour.accept(user.message)
                        }
                        else {
                            self.isloadingBehaviour.accept(false)
                            self.loginResponseBehaviour.accept("Failed")
                        }
                    }*/
                }
                
            case .failure(let error):
                self.isloadingBehaviour.accept(false)
                self.loginResponseBehaviour.accept(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
            
        }
        
    }
    // ------------------------------------------------
    
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: EmailBehaviour.value)
    }
    
}
