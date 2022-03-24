//
//  occupationViewController.swift
//  occupations licence
//
//  Created by Mohamed Ali on 19/10/2021.
//

import UIKit
import RxSwift
import RxCocoa

class occupationViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var SearchTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var SearchButton: UIButton!
    
    var picker: UIPickerView!
    let placeHolderColor = "#243C60"
    let cornerRadiour = 10
    let paddingValue = 55
    let cellIdentifier = "Cell"
    let NibFileName = "occupationCell"
    let occupationviewmodel = occupationViewModel()
    let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigureTextFieldUI()
        SubscribeToStartSearchAction()
        SubscribeToSearchButtonAction()
        
        GetUserData()
        
        ConfigureCollectionView()
        SubscribeToisloading()
        SubscribeToResponse()
        BindToCollectionView()
        Getoccupations()
        BindToCellTapped()
        subscribeToPaggingStatus()
        BindToPagaging()
    }
    
    // MARK:- TODO:- This Method For Custom UI To TextField
    func ConfigureTextFieldUI() {
        SearchTextField.SetPlaceHoler(PlaceHolder: "PlaceSectionPlaceHolder".localized, Color: placeHolderColor , paddingValue: paddingValue)
        
        SearchTextField.layer.cornerRadius = CGFloat(cornerRadiour)
        SearchTextField.layer.masksToBounds = true
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Add PickerView To TextField.
    func SubscribeToStartSearchAction() {
        SearchTextField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.HandleDoneButton()
            self.SearchTextField.inputView = self.loadPicker()
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Convert TextField To PickerView.
    private func loadPicker() -> UIPickerView {
        
        occupationviewmodel.FillCatagory()
        
        // Load picker and return from here.
        picker = UIPickerView()
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKeyPath: "textColor")
        
        BindPickerViewToRxSwift()

        return picker
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Binding PickerView to his RxSwift.
    func BindPickerViewToRxSwift() {
        
        // Bind DataSource.
        self.occupationviewmodel.catagory.bind(to: picker.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposebag)
        
        // Bind Selected Item.
        Observable
            .zip(picker.rx.itemSelected, picker.rx.modelSelected(String.self))
            .bind { [weak self] selectedIndex, branch in

                    guard let self = self else { return }
                self.occupationviewmodel.pickedCatagoryIdBehaviour.accept(branch.first!)
                self.occupationviewmodel.pickedCatagoryBehaviour.accept(branch.first!)
            }.disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Handle Done Button on Search TextField.
    func HandleDoneButton() {
        SearchTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        SearchTextField.text = occupationviewmodel.pickedCatagoryBehaviour.value
        
        SearchTextField.resignFirstResponder()
        
        // Search on DataBase.
        occupationviewmodel.SearchOccupation()
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For SubscribeTo Search Button Action
    func SubscribeToSearchButtonAction() {
        SearchButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.occupationviewmodel.GetAllOccupationsOperation()
            self.SearchTextField.resignFirstResponder()
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Configure CollectionView With the Cell
    func ConfigureCollectionView() {
        
        collectionView.register(UINib(nibName: NibFileName, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.backgroundColor = UIColor.clear
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        var size = 0
        
        if self.view.frame.height == 667 {
            size = Int(((collectionView.frame.size.width - 10) / CGFloat(2)))
        }
        else if self.view.frame.height == 568 {
            size = Int((collectionView.frame.size.width / CGFloat(2)) - 5)
        }
        else {
            size = Int((collectionView.frame.size.width / CGFloat(2)) + 15)
        }
        
        flowLayout.itemSize = CGSize(width: size, height: 337)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView.collectionViewLayout = flowLayout
//        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Subscribe To Load Animation
    func SubscribeToisloading() {
        occupationviewmodel.isloadingBevaiour.subscribe(onNext: { [weak self] isloading in
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
    
    // MARK:- TODO:- This Method For BindTo CollectionView.
    func BindToCollectionView() {
        occupationviewmodel.occupationResponseBehaviour.bind(to: self.collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: occupationCell.self)){ row , branch , cell in
            
            guard let user = branch.users else { return }
            
            cell.ConfigureCell(user: user, occupation: branch)
            
        }.disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Check Response
    func SubscribeToResponse() {
        occupationviewmodel.responseBehaviour.subscribe(onNext: { [weak self] response in
            guard let self = self else {return}
            
            if response == "Success" {
                self.collectionView.isHidden = false
                self.messageLabel.isHidden = true
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                  at: .top,
                                                  animated: true)
            }
            else if response == "" {
                
            }
            else {
                self.collectionView.isHidden = true
                self.messageLabel.isHidden = false
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Getting The occupations.
    func Getoccupations() {
        occupationviewmodel.GetAllOccupationsOperation()
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Action Cell Tapped To Sea Details.
    func BindToCellTapped() {
        
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(OccupationModel.self))
            .bind { [weak self] selectedIndex, branch in

                guard let self = self else { return }
                
                let story = UIStoryboard(name: "occupationDetails", bundle: nil)
                
                let next = story.instantiateViewController(withIdentifier: "occupationDetailsViewController") as! occupationDetailsViewController
                
                occupationDetalis = branch
                
                next.occupationdetailsviewmodel.pickedoccupationDetails.accept(branch)
                
                next.tag = 2
                
                next.modalPresentationStyle = .fullScreen
                
                self.present(next, animated: true)
                
//                print(selectedIndex[1], branch.UserName)
        }
        .disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Handle Pagaging operation.
    func subscribeToPaggingStatus() {
        occupationviewmodel.ispaggaingBehaviour.subscribe(onNext: { [weak self] isloaded in
            guard let self = self else { return }
            
            if isloaded == true {
                self.occupationviewmodel.GetNextPageOperation()
                self.ShowAnimation()
            }
            else if isloaded == nil {
                self.ShowAnimation()
            }
            else {
                print("we are getting Data")
            }
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Pagging in collectionView.
    func BindToPagaging() {
        collectionView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.collectionView.contentOffset.y
            let contentHeight = self.collectionView.contentSize.height

            if offSetY > (contentHeight - self.collectionView.frame.size.height - 100) {
                // Get Next Page Elements if we are not getting element operation.
                if self.occupationviewmodel.ispaggaingBehaviour.value != true {
                    self.occupationviewmodel.ispaggaingBehaviour.accept(true)
                }
            }
        }
        .disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Getting UserName From UserDefaults.
    func GetUserData() {
        occupationviewmodel.GetUserDataOperation()
        userNameLabel.text = occupationviewmodel.userNameBehaviour.value
    }
    // ------------------------------------------------

}
