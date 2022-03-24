//
//  occupationDetailsViewModel.swift
//  occupations licence
//
//  Created by Mohamed Ali on 17/10/2021.
//

import Foundation
import RxCocoa
import RxSwift
import Kingfisher
import GoogleMaps

class occupationDetailsViewModel {
    
    var pickedoccupationDetails = BehaviorRelay<OccupationModel?>(value: nil)
    
    var isloadingBehaviour = BehaviorRelay<Bool>(value: false)
    var occupationDataBehaviour = BehaviorRelay<OccupationModel?>(value: nil)
    var responseBehaviour = BehaviorRelay<String>(value: "")
    var occupationCode = BehaviorRelay<String>(value: "")
    
    var currentlati = BehaviorRelay<Double>(value: 0.0)
    var currentlong = BehaviorRelay<Double>(value: 0.0)
    var DistanceresponseBehaviour = BehaviorRelay<String>(value: "")
    
    let occupation = occupationAPI()
    
    let apiKey = "AIzaSyCQi_F0vnM78KTQHAv_xM3Do_iii04OPaE"
    var mapView:GMSMapView?
    var camera:GMSCameraPosition?
    
    // MARK:- TODO:- Set Map API Key
    private func setApiKEY() {
        GMSServices.provideAPIKey(apiKey)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Draw Annotation in Google Maps.
    func CreateAnnotation (view: UIView,long: Double, latit: Double,Title: String, Des: String ,zoom: Float) {
            
        setApiKEY()
        
        // Creates a marker in the center of the map.
        camera = GMSCameraPosition.camera(withLatitude: latit, longitude: long, zoom: zoom)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera!)
        mapView!.mapType = .satellite
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latit, longitude: long)
        marker.title = Title
        marker.snippet = Des
        marker.map = mapView
//        marker.icon = icon
                
        mapView?.frame = view.bounds
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Download Image from API.
    func downloadImage(img: UIImageView,`with` urlString : String){
        let url1 = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let url = URL.init(string: url1) else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        
        print("F: \(urlString)")

        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print("F: Image: \(value.image). Got from: \(value.cacheType)")
                img.image = value.image
            case .failure(let error):
                print("F: Error: \(error)")
                img.image = UIImage(named: "img12")
            }
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Getting Occupartion Data From API
    func getOccupationData() {
        
        isloadingBehaviour.accept(true)
        
        occupation.FetchOccupationDetails(occupId: occupationCode.value) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let response):
                guard let response = response else {
                    return
                }
                if response.status == 1 {
                    /*guard let occupation = response.occupations else {
                        self.responseBehaviour.accept("NotFound".localized)
                        self.isloadingBehaviour.accept(false)
                        return
                    }
                    
                    self.occupationDataBehaviour.accept(occupation[0])
                    self.responseBehaviour.accept("Success")
                    self.isloadingBehaviour.accept(false)*/
                    
                    if response.occupation!.count > 0 {
                        occupationDetalis = response.occupation![0]
                        self.occupationDataBehaviour.accept(response.occupation![0])
                        self.responseBehaviour.accept("Success")
                        self.isloadingBehaviour.accept(false)
                    }
                    else {
                        self.responseBehaviour.accept("NotFound".localized)
                        self.isloadingBehaviour.accept(false)
                    }
                }
            case .failure(let error):
                self.responseBehaviour.accept(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                self.isloadingBehaviour.accept(false)
            }
        }
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Check Distance Between current location and occupation.
    func GetDistanceOperation() {
        
        if occupationDataBehaviour.value == nil {
            let occu = pickedoccupationDetails.value
            let id = occu!.occupCode
            GetDistance(id: String(id!))
            
        }
        else {
            let occu = occupationDataBehaviour.value
            let id = occu!.occupCode
            GetDistance(id: String(id!))
        }
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Getting Distance From API and Get Response if it can edit or not.
    private func GetDistance(id: String) {
        occupation.CheckDistance(code: id, lati: String(currentlati.value), long: String(currentlong.value)) { response in
            switch response {
            
            case .success(let success):
                guard let success = success else { return }
                if success.status == 1 {
//                    print(success.messageEng)
                    self.DistanceresponseBehaviour.accept("true")
                }
            case .failure(let error):
//                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                self.DistanceresponseBehaviour.accept(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
        }
    }
    // ------------------------------------------------
    
}
