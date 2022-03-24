//
//  occupationViewModel.swift
//  occupations licence
//
//  Created by Mohamed Ali on 19/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

class occupationViewModel {
    
    // MARK:- TODO:- This Section For Rx Varibles.
    let catagory = BehaviorRelay<[String]>(value: [])
    let pickedCatagoryIdBehaviour = BehaviorRelay<String>(value: "")
    let pickedCatagoryBehaviour = BehaviorRelay<String>(value: "")
    var isloadingBevaiour = BehaviorRelay<Bool>(value: false)
    var userNameBehaviour = BehaviorRelay<String>(value: "")
    
    var responseBehaviour = BehaviorRelay<String>(value: "")
    var occupationResponseBehaviour = BehaviorRelay<[OccupationModel]>(value: [])
//    var userResponseBehaviour = BehaviorRelay<UserLoginModel?>(value: nil)
    var BackupResponseBehaviour = BehaviorRelay<[OccupationModel]>(value: [])
    var BackupNexturlBehaviour = BehaviorRelay<String>(value: "")
    
    var NexturlBehaviour = BehaviorRelay<String>(value: "")
    var ispaggaingBehaviour = BehaviorRelay<Bool?>(value: nil)
    
    let occupation = occupationAPI()
    
    // MARK:- TODO:- This Method For Fill Sections Name For Search
    func FillCatagory() {
        let arr = ["الكل","سياحى","تجارى","تحت باكية","شعبى"]
        
        catagory.accept(arr)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Get User Profile Name.
    func GetUserDataOperation() {
        guard let userData = UserDefaultsMethods.loadDataFromUserDefaults(Key: currentUser, className: SavedUserModel.self) else { return }
        
        userNameBehaviour.accept(userData.userName)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Getting All occupation For DataBase.
    func GetAllOccupationsOperation() {
        
        isloadingBevaiour.accept(true)
        
        occupation.FetchAlloccupations { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let result):
                guard  let result = result else {
                    return
                }
                if result.status == 1 {
                    
                    self.responseBehaviour.accept("Success")
                    
                    if result.occupation?.count != 0 {
                        self.occupationResponseBehaviour.accept(result.occupation!)
                        self.BackupResponseBehaviour.accept(result.occupation!)
                        guard let next = result.next?.url else {
                            self.NexturlBehaviour.accept("")
                            return
                        }
                        self.NexturlBehaviour.accept(next)
                        self.BackupNexturlBehaviour.accept(next)
                    }
                    else {
                        self.occupationResponseBehaviour.accept([])
                        self.responseBehaviour.accept("failed")
                    }
                    
                    self.isloadingBevaiour.accept(false)
                }
            case .failure(let error):
                self.isloadingBevaiour.accept(false)
                self.responseBehaviour.accept(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                self.responseBehaviour.accept("failed")
            }
        }
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Search occupation
    func SearchOccupation() {
        
        if (handleTitle() == "All") {
            // Show All occupations.
            occupationResponseBehaviour.accept(BackupResponseBehaviour.value)
            NexturlBehaviour.accept(BackupNexturlBehaviour.value)
            responseBehaviour.accept("Success")
        }
        else {
            // Show the filtered occupation.
            isloadingBevaiour.accept(true)
            occupation.SearchOccupationWithType(occupType: handleTitle()) { [weak self] response in
                
                guard let self = self else { return }
                
                switch response {
                
                case .success(let result):
                    guard  let result = result else {
                        return
                    }
                    if result.status == 1 {
                        if result.occupation?.count != 0 {
                            print("F: we are searched success")
//                            self.occupationResponseBehaviour.accept([])
                            self.occupationResponseBehaviour.accept(result.occupation!)
                            
                            guard let next = result.next?.url else {
                                self.NexturlBehaviour.accept("")
                                return
                            }
                            self.NexturlBehaviour.accept(next)
                            self.responseBehaviour.accept("Success")
                        }
                        else {
                            self.occupationResponseBehaviour.accept([])
                            self.responseBehaviour.accept("false")
                        }
                        
                        self.isloadingBevaiour.accept(false)
                    }
                case .failure(let error):
                    self.isloadingBevaiour.accept(false)
                    self.responseBehaviour.accept(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                    self.responseBehaviour.accept("false")
                }
            }
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Get Next page of occupations from Database.
    func GetNextPageOperation() {
        if NexturlBehaviour.value == "" {
            self.ispaggaingBehaviour.accept(false)
            self.isloadingBevaiour.accept(false)
            print("F: there is no pages")
        }
        else {
            occupation.GetNextPage(uri: NexturlBehaviour.value) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let success):
                    
                    guard let success = success else {
                        return
                    }
                    
                    if success.status == 1 {
                        var arr = self.occupationResponseBehaviour.value
                        arr += success.occupation!
                        self.occupationResponseBehaviour.accept(arr)
                        guard let next = success.next?.url else {
                            self.NexturlBehaviour.accept("")
                            print("F: there is no next url")
                            return
                        }
                        
                        print("F: there is next url")
                        self.NexturlBehaviour.accept(next)
                        self.isloadingBevaiour.accept(false)
                        self.ispaggaingBehaviour.accept(false)
                    }
                    
                case .failure(let fail):
                    self.responseBehaviour.accept(fail.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                    self.isloadingBevaiour.accept(false)
                    self.ispaggaingBehaviour.accept(false)
                }
            }
        }
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Merthod For Handle Search TextField with switch.
    private func handleTitle() -> String {
        switch pickedCatagoryIdBehaviour.value {
        case "الكل":
            return "All"
        case "سياحى":
            return "S"
        case "تجارى":
            return "T"
        case "تحت باكية":
            return "P"
        case "شعبى":
            return "SH"
        default:
            return "SH"
        }
    }
    // ------------------------------------------------
    
}
