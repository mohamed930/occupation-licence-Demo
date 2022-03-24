//
//  UpdatePasswordViewController.swift
//  occupations licence
//
//  Created by Mohamed Ali on 17/10/2021.
//

import UIKit
import RxSwift
import RxCocoa

class UpdatePasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var UpdatePasswordButton: UIButton!
    
    let disposebag = DisposeBag()
    let updatepasswordviewmodel = UpdatePasswordViewModel()
    let placeHolderColor = "#A2A2A2"
    let buttonBackgorundColor = "#5ACCC1"

    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigureTextField()
        BindToTextField()
        SubscribeReturnButton()
        
        ConfigureButton()
        SubscribeToloading()
        SubscribeToButtonEnabled()
        SubscribeToResponse()
        SubscribeToForgetPasswordButtonAction()
        
    }
    
    // MARK:- TODO:- TextField UI Configure
    func ConfigureTextField() {
        passwordTextField.SetPlaceHoler(PlaceHolder: "PasswordPlaceHolder".localized, Color: placeHolderColor, paddingValue: 45)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Relate TextField To Rx Varible.
    func BindToTextField() {
        passwordTextField.rx.text.orEmpty.bind(to: updatepasswordviewmodel.PasswordBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Make Return Button Action
    func SubscribeReturnButton() {
        passwordTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.passwordTextField.resignFirstResponder()
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Make Forget Password Button UI Configure
    func ConfigureButton() {
        UpdatePasswordButton.SetCornerRadious(BackgroundColor: buttonBackgorundColor, CornerRadious: 5)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Making Loading Action
    func SubscribeToloading() {
        updatepasswordviewmodel.isloadingBehaviour.subscribe(onNext: { [weak self] isloading in
            
            guard let self = self else { return }
            
            if isloading {
                self.ShowAnimation()
            }
            else {
                self.DismissAnimation()
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Make Forget Password Enabled or not.
    func SubscribeToButtonEnabled() {
        updatepasswordviewmodel.isPasswordBehaviour.subscribe(onNext: { [weak self] isEnabled in
            guard let self = self else { return }
            
            if isEnabled == true {
                self.UpdatePasswordButton.isEnabled = false
            }
            else {
                self.UpdatePasswordButton.isEnabled = true
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Handle Response.
    func SubscribeToResponse() {
        updatepasswordviewmodel.responseMessageBehaviour.subscribe(onNext: { [weak self] tocken in
            guard let self = self else { return }
            
            if tocken == "تم تعديل كلمه المرور بنجاح" {
                // Send it to next Page.
//                print(tocken)
                self.ShowSuccess(mess: tocken)
                let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                nextVc.modalPresentationStyle = .fullScreen
                self.present(nextVc, animated: true)
            }
            else if tocken == "" {
                
            }
            else {
                self.ShowError(mess: tocken)
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Forget password Action.
    func SubscribeToForgetPasswordButtonAction() {
        UpdatePasswordButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.updatepasswordviewmodel.UpdatePasswordOperation()
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Dismiss Key pad when touch view.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // ------------------------------------------------

}
