//
//  occupationCell.swift
//  occupations licence
//
//  Created by Mohamed Ali on 17/10/2021.
//

import UIKit
import RappleProgressHUD
import Kingfisher

class occupationCell: UICollectionViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var occupationCoverImageView: UIImageView!
    @IBOutlet weak var occupationName: UILabel!
    @IBOutlet weak var infractionLabel: UILabel!
    
    let cornerRadious = 26

    override func awakeFromNib() {
        super.awakeFromNib()
        
        occupationCoverImageView.MakeImageCornerRadious(CornderRadious: CGFloat(cornerRadious))
    }
    
    func ConfigureCell(user: UserLoginModel ,occupation : OccupationModel) {
        userNameLabel.text = "اسم المستخدم :" + user.userName
        
        if occupation.infractions!.count > 0 {
            
            var infraction = 0
            var message = ""
            
            for i in 0..<occupation.infractions!.count {
                
                infraction += Int(occupation.infractions![i].infraction)
                
                if i == occupation.infractions!.count - 1 {
                    message += occupation.infractions![i].typeofinfraction
                }
                else {
                    message += occupation.infractions![i].typeofinfraction + " , "
                }
                
            }
            
            if infraction == 0 {
                infractionLabel.text = "لا يوجد"
                infractionLabel.textColor = UIColor().hexStringToUIColor(hex: "#338D00")
            }
            else {
                infractionLabel.text = "المخالفه : " + String(infraction) + " " + message
                infractionLabel.textColor = .red
            }
        }
        else {
            infractionLabel.text = "لا يوجد"
            infractionLabel.textColor = UIColor().hexStringToUIColor(hex: "#338D00")
        }
        
        occupationName.text = occupation.HandleName()
        
        
        /*if occupation.infractions!.infraction == 0 {
            infractionLabel.text = occupation.infractions!.typeofinfraction
        }
        else {
            infractionLabel.text = String(occupation.infractions!.infraction) + " " + occupation.infractions!.typeofinfraction
        }*/
        
        
        downloadImage(img: occupationCoverImageView, with: occupation.occupationsCoverURL)
        
//        DispatchQueue.main.async {
//            self.occupationCoverImageView.kf.setImage(with:URL(string: occupation.occupationsCoverURL)!)
//
//            RappleActivityIndicatorView.stopAnimation()
//        }
        
    }

    
    private func downloadImage(img: UIImageView,`with` urlString : String){
        let url1 = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let url = URL.init(string: url1) else {
            return
        }
        let resource = ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print("F: Image: \(value.image). Got from: \(value.cacheType)")
                img.image = value.image
                RappleActivityIndicatorView.stopAnimation()
            case .failure(let error):
                print("F: Error: \(error)")
                img.image = UIImage(named: "img12")
                RappleActivityIndicatorView.stopAnimation()
            }
        }
    }
}
