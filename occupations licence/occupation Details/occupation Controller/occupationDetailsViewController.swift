//
//  occupationDetailsViewController.swift
//  occupations licence
//
//  Created by Mohamed Ali on 17/10/2021.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class occupationDetailsViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK:- TODO:- IBOutlets Varibles.
    @IBOutlet weak var occupationImageView: UIImageView!
    @IBOutlet weak var occupationNameLabel: UILabel!
    @IBOutlet weak var occupationCurrentActivityLabel: UILabel!
    
    @IBOutlet weak var licenceAreaLabel: UILabel!
    @IBOutlet weak var currentAreaLabel: UILabel!
    @IBOutlet weak var typeoccupationLabel: UILabel!
    @IBOutlet weak var neighbourhoodLabel: UILabel!
    
    @IBOutlet weak var occupationAddressLabel: UILabel!
    @IBOutlet weak var occupationownerNameLabel: UILabel!
    
    @IBOutlet weak var DistanceLabel: UILabel!
    
    @IBOutlet weak var MapView: UIView!
    
    @IBOutlet weak var DetailsView: UIView!
    @IBOutlet weak var ViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var MapHight: NSLayoutConstraint!
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var EditButton: UIButton!
    
    // MARK:- TODO:- This Method For initialise new veribles here:-
    var tag = 0
    let buttonBackgroundColor = "#005DFF"
    var screenedgeup : UISwipeGestureRecognizer!
    var screenedgeDown : UISwipeGestureRecognizer!
    let cornerRadious = 32.0
    let animationDuration = 1.1
    var locationManager: CLLocationManager!
    let occupationdetailsviewmodel = occupationDetailsViewModel()
    let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigureView()
        ConfgiureSwipeGeuster()
        
        SubscribeTooccupationDetails()
        
        SubscribeToBackButtonAction()
        
        ConfigureEditButton()
        SubscribeToShowButtonOrNot()
        SubscribeToEditButtonAction()
//        WorkonDistance()
    }
    
    // MARK:- TODO:- This Method For Configure DetailsView UI.
    func ConfigureView() {
        self.DetailsView.MakeRound(cornerRadious: CGFloat(cornerRadious), v: [.layerMaxXMinYCorner,.layerMinXMinYCorner])
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Configure Swipe To Details View.
    func ConfgiureSwipeGeuster() {
        screenedgeup = UISwipeGestureRecognizer(target: self, action: #selector(ShowDetails(_:)))
        screenedgeup.direction = .up
        DetailsView.addGestureRecognizer(screenedgeup)
        
        screenedgeDown = UISwipeGestureRecognizer(target: self, action: #selector(ShowDetails(_:)))
        screenedgeDown.direction = .down
        DetailsView.addGestureRecognizer(screenedgeDown)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Add GuesterAction
    @objc func ShowDetails (_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .up {
            ShowDetailsWithAnimation()
        }
        else {
            HideDetailsWithAnimation()
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Handle When Swipe Up Show All Details in View.
    private func ShowDetailsWithAnimation() {
        UIView.animate(withDuration: animationDuration) {
//            if self.view.frame.height == 568 {
//                self.StepCollectionHight.constant = self.DetailsView.frame.height * 0.02
//            }
            self.ViewHight.constant = self.view.frame.height - 30
            self.DetailsView.MakeRound(cornerRadious: 0, v: [.layerMaxXMinYCorner,.layerMinXMinYCorner])
            self.view.layoutIfNeeded()
        }
        if self.view.frame.height == 812 {
            self.MapHight.constant = self.DetailsView.frame.height * 0.36
        }
        else if self.view.frame.height == 667 {
            self.MapHight.constant = self.DetailsView.frame.height * 0.3
        }
        else if self.view.frame.height == 568 {
            self.MapHight.constant = self.DetailsView.frame.height * 0.25
        }
        else {
            self.MapHight.constant = self.DetailsView.frame.height * 0.46
        }
        self.BackButton.isHidden = true
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Dismiss Animation When Swipe Down.
    private func HideDetailsWithAnimation() {
        UIView.animate(withDuration: animationDuration) {
            self.ViewHight.constant = 429
            self.DetailsView.MakeRound(cornerRadious: CGFloat(self.cornerRadious), v: [.layerMaxXMinYCorner,.layerMinXMinYCorner])
            self.view.layoutIfNeeded()
        }
        
        self.BackButton.isHidden = false
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method  For Handle occupation Details Data.
    func SubscribeTooccupationDetails() {
        
        if tag == 1 {
            SubscribeToisloadingBahaviour()
            GetoccupationDetais()
            SubscribeToResponse()
        }
        else if tag == 2 {
            let occup = occupationdetailsviewmodel.pickedoccupationDetails.value!
            loadDataFromOfflineObject(occup: occup)
        }
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Load data from Offile object when getting collection.
    func loadDataFromOfflineObject(occup: OccupationModel) {
//        let occup = occupationdetailsviewmodel.pickedoccupationDetails.value!
        
        occupationNameLabel.text = occup.HandleName()
        occupationCurrentActivityLabel.text = occup.currentActivity
        
//        guard let licence = occup.licenses else { return }
        
        licenceAreaLabel.text = String(occup.licenseArea)
        currentAreaLabel.text = String(occup.licenseArea)
        typeoccupationLabel.text = occup.HandleCatagory()
        neighbourhoodLabel.text = occup.HandleNeighbourhoodName()
        
        occupationAddressLabel.text = occup.addressAr
        
        // MARK:- TODO:- Return To it.
        if occup.owners!.count == 0 {
            occupationownerNameLabel.text = "اسم المالك"
        }
        else {
            occupationownerNameLabel.text = occup.owners![occup.owners!.count - 1].ownerNameAr
        }
        
        occupationdetailsviewmodel.CreateAnnotation(view: MapView, long: occup.longitude, latit: occup.latitude, Title: occup.HandleName(), Des: occup.addressAr, zoom: 22)
        
        DispatchQueue.main.async {
            self.occupationdetailsviewmodel.downloadImage(img: self.occupationImageView, with: occup.occupationsCoverURL)
        }
        
        
        print("F: \(occup.id)")
        
        self.ConfigureLocation()
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Subscribe to Load animation.
    func SubscribeToisloadingBahaviour() {
        occupationdetailsviewmodel.isloadingBehaviour.subscribe(onNext: { [weak self] isloading in
            
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
    
    // MARK:- TODO:- This Method For Subscribe To Response.
    func SubscribeToResponse() {
        occupationdetailsviewmodel.responseBehaviour.subscribe(onNext: { [weak self] response in
            
            guard let self = self else { return }
            
            if response == "Success" {
                let occup = self.occupationdetailsviewmodel.occupationDataBehaviour.value
                self.loadDataFromOfflineObject(occup: occup!)
                self.ConfigureLocation()
            }
            else if response == "" {
                
            }
            else {
                self.ShowError(mess: response)
            }
        }).disposed(by: disposebag)
    }
    
    // MARK:- TODO:- This Method For For GetData From API
    func GetoccupationDetais() {
        occupationdetailsviewmodel.getOccupationData()
    }
    
    // MARK:- TODO:- This Method For Back Button Action.
    func SubscribeToBackButtonAction() {
        BackButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.locationManager != nil {
                self.locationManager.stopUpdatingLocation()
                self.locationManager.delegate = nil
            }
            
            self.dismiss(animated: true)
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Configure Edit Button UI.
    func ConfigureEditButton() {
        EditButton.SetCornerRadious(BackgroundColor: buttonBackgroundColor, CornerRadious: 11)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Edit Button Action.
    func SubscribeToEditButtonAction() {
        EditButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { _ in
            
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Configure Location.
    func ConfigureLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        alwaysAuthorization()
    }
    
    func alwaysAuthorization() {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let l = locations[locations.count - 1]
        if l.horizontalAccuracy > 0 {
//            locationManager.stopUpdatingLocation()
//            locationManager.delegate = nil
            
            print("Long = \(l.coordinate.longitude) latitude = \(l.coordinate.latitude)")
            
            occupationdetailsviewmodel.currentlati.accept(l.coordinate.latitude)
            occupationdetailsviewmodel.currentlong.accept(l.coordinate.longitude)
            print("lati: \(occupationdetailsviewmodel.currentlati.value), long: \(occupationdetailsviewmodel.currentlong.value)")
            WorkonDistance()
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // MARK:- TODO:- This Method Handle The button Show or not.
    func SubscribeToShowButtonOrNot() {
        occupationdetailsviewmodel.DistanceresponseBehaviour.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            
            print(result)
            
            if result == "" {
                
            }
            else if result == "true" {
                self.EditButton.isHidden = false
                self.DistanceLabel.isHidden = true
                self.locationManager.stopUpdatingLocation()
                self.locationManager.delegate = nil
            }
            else if result == "تمت تعديل بيانات الكشك بالفعل"{
                self.EditButton.isHidden = true // Don't Forget to change it
                self.DistanceLabel.isHidden = true
                self.DistanceLabel.text = result
                self.locationManager.delegate = nil
                self.locationManager.stopUpdatingLocation()
                
            }
            else {
                self.EditButton.isHidden = false // Don't Forget to change it true
                self.DistanceLabel.isHidden = false // Don't Forget to change it false
                self.DistanceLabel.text = "المسافه : " + result.replacedArabicDigitsWithEnglish + " م"
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method Worked in background to check the distance.
    func WorkonDistance() {
        DispatchQueue.main.async {
            self.occupationdetailsviewmodel.GetDistanceOperation()
        }
    }
    // ------------------------------------------------
    
}
