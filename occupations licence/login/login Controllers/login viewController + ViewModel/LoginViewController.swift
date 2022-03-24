//
//  LoginViewController.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    // MARK:- TODO:- Initialise IBOutlets here:-
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var SignupButton: UIButton!
    
    // MARK:- TODO:- Intialise new varible here:-
    let placeHolderColor = "#A2A2A2"
    let buttonBackgorundColor = "#5ACCC1"
    let loginviewmodel = loginViewModel()
    let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigureTextField()
        BindToTextField()
        SubscribeReturnButtonAction()
        
        SubscribeButtonEnabled()
        SubscbireisLoadingBehaviour()
        SubscribeLoginResponse()
        SubscribeToLoginButtonAction()
        
        SubscribeToForgetPassword()
        SubscribeToSignupButtonAction()
    }
    
    // MARK:- TODO:- This Method For Configure Button UI.
    func ConfigureTextField() {
        EmailTextField.SetPlaceHoler(PlaceHolder: "EmailOrUserName".localized , Color: placeHolderColor, paddingValue: 45)
        PasswordTextField.SetPlaceHoler(PlaceHolder: "Password".localized, Color: placeHolderColor, paddingValue: 45)
        
        loginButton.SetCornerRadious(BackgroundColor: buttonBackgorundColor, CornerRadious: 10)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Bind TextField to RxVaribles.
    func BindToTextField() {
        EmailTextField.rx.text.orEmpty.bind(to: loginviewmodel.EmailBehaviour).disposed(by: disposebag)
        PasswordTextField.rx.text.orEmpty.bind(to: loginviewmodel.PasswordBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Congifure Return Button Action.
    func SubscribeReturnButtonAction() {
        EmailTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
            
            guard let self = self else { return }
            
            self.PasswordTextField.becomeFirstResponder()
            
        }).disposed(by: disposebag)
        
        PasswordTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
            
            guard let self = self else { return }
            
            self.PasswordTextField.resignFirstResponder()
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This method for Subscribe loading action
    func SubscbireisLoadingBehaviour() {
        loginviewmodel.isloadingBehaviour.subscribe(onNext: { [weak self] isloading in
            
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
    
    // MARK:- TODO:- This Method For Configure Button UI.
    func ConfigureLoginButtonUI() {
        loginButton.SetCornerRadious(BackgroundColor: buttonBackgorundColor, CornerRadious: 5.0)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Subscrib login Button Enabled or not.
    func SubscribeButtonEnabled() {
        loginviewmodel.isLoginButtonEnabled.subscribe(onNext: { [weak self] isEnabled in
            guard let self = self else { return }
            
            if isEnabled {
                self.loginButton.isEnabled = true
            }
            else {
                self.loginButton.isEnabled = false
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Handle Response login
    func SubscribeLoginResponse() {
        loginviewmodel.loginResponseBehaviour.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            if response == "login is successfully" {
                
                let sotryBoard = UIStoryboard(name: "home", bundle: nil)
                let nextVC = sotryBoard.instantiateViewController(withIdentifier: "tabBar")
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
                
            }
            else if response == "" {
                
            }
            else {
                self.ShowError(mess: response)
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Handle Signin Button Action.
    func SubscribeToLoginButtonAction() {
        loginButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            if self.loginviewmodel.isValidEmail() {
                self.loginviewmodel.loginWithEmailOperation()
            }
            else {
                self.loginviewmodel.loginwithUserNameOperation()
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Handle ForgetPassword Button Action.
    func SubscribeToForgetPassword() {
        forgetPasswordButton.rx.tap.subscribe(onNext: { [weak self] _ in
            
            guard let self = self else { return }
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true)
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Handle Signup Button Action.
    func SubscribeToSignupButtonAction() {
        SignupButton.rx.tap.subscribe(onNext: { _ in
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------

    // MARK:- TODO:- This Method For Dismiss Keypad when touch any where.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // ------------------------------------------------
}

