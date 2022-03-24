//
//  ForgetPasswordViewController.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var ForgetPasswordButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    
    let disposebag = DisposeBag()
    let forgetviewmodel = ForgetPasswordViewModel()
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
        
        SubscribeToBackButtonAction()
    }
    
    // MARK:- TODO:- TextField UI Configure
    func ConfigureTextField() {
        EmailTextField.SetPlaceHoler(PlaceHolder: "EmailPlaceHolder".localized, Color: placeHolderColor, paddingValue: 45)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Relate TextField To Rx Varible.
    func BindToTextField() {
        EmailTextField.rx.text.orEmpty.bind(to: forgetviewmodel.EmailBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Make Return Button Action
    func SubscribeReturnButton() {
        EmailTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.EmailTextField.resignFirstResponder()
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Make Forget Password Button UI Configure
    func ConfigureButton() {
        ForgetPasswordButton.SetCornerRadious(BackgroundColor: buttonBackgorundColor, CornerRadious: 5)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Making Loading Action
    func SubscribeToloading() {
        forgetviewmodel.isloadingBehaviour.subscribe(onNext: { [weak self] isloading in
            
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
        forgetviewmodel.isEmailBehaviour.subscribe(onNext: { [weak self] isEnabled in
            guard let self = self else { return }
            
            if isEnabled == true {
                self.ForgetPasswordButton.isEnabled = false
            }
            else {
                self.ForgetPasswordButton.isEnabled = true
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Handle Response.
    func SubscribeToResponse() {
        forgetviewmodel.tocken.subscribe(onNext: { [weak self] tocken in
            guard let self = self else { return }
            
            if tocken.isNumber {
                // Send it to next Page.
//                print(tocken)
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                nextVC.modalPresentationStyle = .fullScreen
                nextVC.verificationviewmodel.emailBehaviour.accept(self.EmailTextField.text!)
                nextVC.verificationviewmodel.tockenBehaviour.accept(tocken)
                self.present(nextVC, animated: true)
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
        ForgetPasswordButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.forgetviewmodel.SendEmailVerification()
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:-  This Method For Action For Back Button
    func SubscribeToBackButtonAction() {
        BackButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.dismiss(animated: true)
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Dismiss Key pad when touch view.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // ------------------------------------------------
}
