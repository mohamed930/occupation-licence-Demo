//
//  VerificationViewController.swift
//  occupations licence
//
//  Created by Mohamed Ali on 16/10/2021.
//

import UIKit
import RxSwift
import RxRelay

class VerificationViewController: UIViewController {
    
    // MARK:- TODO:- Initialise New @IBOutlets
    @IBOutlet weak var DigitOneTextField: UITextField!
    @IBOutlet weak var DigittwoTextField: UITextField!
    @IBOutlet weak var DigitthreeeTextField: UITextField!
    @IBOutlet weak var DigitfourTextField: UITextField!
    @IBOutlet weak var TimerLabel: UILabel!
    
    @IBOutlet weak var VerifyButton: UIButton!
    @IBOutlet weak var SendAgainButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var StackHight: NSLayoutConstraint!
    
    // MARK:- TODO:- Initialise New Varibles
    let colorBorder = "#D0DBEA"
    let disposebag = DisposeBag()
    let verificationviewmodel = VerificationViewModel()
    var timer = Timer()
    var seconds = 240

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Email: \(verificationviewmodel.emailBehaviour.value), \(verificationviewmodel.tockenBehaviour.value)")

        StackHight.constant = DigitOneTextField.frame.width + 5
        
        ConfigureTextField()
        BindToTextField()
        
        ConfgiureButton()
        
        ConfigureTimer()
        
        SubscribeToResponse()
        SubscribeToVerifyButtonAction()
        
        SubscribeToSendTockenResponse()
        SubscribeToSendAgainButton()
    }
    
    // MARK:- TODO:- This Method For Configure TextField UI.
    func ConfigureTextField() {
        let cornerRadious = DigitOneTextField.frame.size.width * 0.25 + 2
        
        DigitOneTextField.SetCornerRadiousWithBorder(cornerRadious: cornerRadious, BorderSize: 1, paddingValue: 0, PlaceHolder: "", Color: colorBorder)
        DigittwoTextField.SetCornerRadiousWithBorder(cornerRadious: cornerRadious, BorderSize: 1, paddingValue: 0, PlaceHolder: "", Color: colorBorder)
        DigitthreeeTextField.SetCornerRadiousWithBorder(cornerRadious: cornerRadious, BorderSize: 1, paddingValue: 0, PlaceHolder: "", Color: colorBorder)
        DigitfourTextField.SetCornerRadiousWithBorder(cornerRadious: cornerRadious, BorderSize: 1, paddingValue: 0, PlaceHolder: "", Color: colorBorder)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Configure Button UI.
    func ConfgiureButton() {
        VerifyButton.SetCornerRadious(BackgroundColor: "#57CBC2", CornerRadious: 28)
        
        SendAgainButton.layer.cornerRadius = 28
        SendAgainButton.layer.masksToBounds = true
        SendAgainButton.layer.borderColor = UIColor().hexStringToUIColor(hex: "#FFFFFF").cgColor
        SendAgainButton.layer.borderWidth = 1
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Bind TextField to Rx Swift.
    func BindToTextField() {
        DigitOneTextField.rx.text.orEmpty.bind(to: verificationviewmodel.digitoneBehaviour).disposed(by: disposebag)
        DigittwoTextField.rx.text.orEmpty.bind(to: verificationviewmodel.digittwoBehaviour).disposed(by: disposebag)
        DigitthreeeTextField.rx.text.orEmpty.bind(to: verificationviewmodel.digitthreeBehaviour).disposed(by: disposebag)
        DigitfourTextField.rx.text.orEmpty.bind(to: verificationviewmodel.digitfourBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Configure Timer.
    func ConfigureTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(timerset), userInfo: nil, repeats: true)
    }
    
    @objc func timerset() {
        seconds = seconds - 1
        TimerLabel.text = "\(asString(style: .positional, Time: TimeInterval(seconds)))"
        
        if seconds == 0 {
            TimerLabel.text = "--:--"
        }
        else if seconds <= 59 {
            TimerLabel.text = "--:\(seconds)"
        }
        else if seconds == 60 {
            TimerLabel.text = "01:--"
        }
        else if seconds == 120 {
            TimerLabel.text = "02:--"
        }
        else if seconds == 180 {
            TimerLabel.text = "03:--"
        }
        
    }
    
    func asString(style: DateComponentsFormatter.UnitsStyle, Time: TimeInterval) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour,.minute,.second,.nanosecond]
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: Time) else {
            return ""
        }
        return formattedString
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Subscribe To Response The Verify Operation.
    func SubscribeToResponse() {
        verificationviewmodel.responseBehaviour.subscribe(onNext: { [weak self] response in
            
            guard let self = self else { return }
            
            guard let response = response else { return }
            
            if response {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdatePasswordViewController") as! UpdatePasswordViewController
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
            }
            else {
                self.ShowError(mess: "MessageError".localized)
            }
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Verify Button Action.
    func SubscribeToVerifyButtonAction() {
        VerifyButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.verificationviewmodel.VerifyCodeOperation()
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Response For Sending Code Again
    func SubscribeToSendTockenResponse() {
        verificationviewmodel.responseSendAgainBehaviour.subscribe(onNext: { [weak self] response in
            
            guard let self = self else { return }
            
            guard let response = response else { return }
            
            if response {
                self.ShowSuccess(mess: "MessageCodeSuccess".localized)
                
                self.seconds = 240
                self.ConfigureTimer()
                self.TimerLabel.text = "04:00"
                self.DigitOneTextField.text = ""
                self.DigittwoTextField.text = ""
                self.DigitthreeeTextField.text = ""
                self.DigitfourTextField.text = ""
                self.DigitOneTextField.becomeFirstResponder()
            }
            else {
                self.ShowError(mess: "Error".localized)
            }
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Send Code Again Action.
    func SubscribeToSendAgainButton() {
        SendAgainButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.verificationviewmodel.SendCodeAgainOperation()
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------

}

extension VerificationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            DigitOneTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: "#1FCC79").cgColor
            DigittwoTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
            DigitthreeeTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
            DigitfourTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
        }
        else if textField.tag == 2 {
            DigitOneTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
            DigittwoTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: "#1FCC79").cgColor
            DigitthreeeTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
            DigitfourTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
        }
        else if textField.tag == 3 {
            DigittwoTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
            DigitthreeeTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: "#1FCC79").cgColor
            DigitOneTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
            DigitfourTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
        }
        else {
            DigitthreeeTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
            DigitOneTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
            DigittwoTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: colorBorder).cgColor
            DigitfourTextField.layer.borderColor = UIColor().hexStringToUIColor(hex: "#1FCC79").cgColor
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string != "" {
            if textField.text == "" {
                textField.text = string
                let nextrespons: UIResponder? = view.viewWithTag(textField.tag + 1)
                if nextrespons != nil {
                    nextrespons?.becomeFirstResponder()
                }
                else {
                    DigitfourTextField.resignFirstResponder()
                    
                    // MARK:- TODO:- in this block add function for API and Show Full Code.
                    print("Code: \(verificationviewmodel.digitoneBehaviour.value + verificationviewmodel.digittwoBehaviour.value + verificationviewmodel.digitthreeBehaviour.value + verificationviewmodel.digitfourBehaviour.value)")
                    
                    let code = verificationviewmodel.digitoneBehaviour.value + verificationviewmodel.digittwoBehaviour.value + verificationviewmodel.digitthreeBehaviour.value + verificationviewmodel.digitfourBehaviour.value
                    
                    verificationviewmodel.sendedTockenBehaviour.accept(code)
                }
            }
            return false
        }
        else {
            textField.text = string
            let nextrespons: UIResponder? = view.viewWithTag(textField.tag - 1)
            if nextrespons != nil {
                nextrespons?.becomeFirstResponder()
            }
            return false
        }
    }
    
}
