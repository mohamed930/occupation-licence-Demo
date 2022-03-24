//
//  InfractionCell.swift
//  occupations licence
//
//  Created by Mohamed Ali on 27/10/2021.
//

import UIKit

class InfractionCell: UITableViewCell {
    
    @IBOutlet weak var infractionTypeLabel: UILabel!
    @IBOutlet weak var infractionImageView: UIImageView!
    @IBOutlet weak var infractionDataLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func ConfigureCell(infractionmodel : InfractionTempModel) {
        infractionTypeLabel.text = infractionmodel.typeofinfraction
        infractionDataLabel.text = Date().ConvertTimeString()
        
        if infractionmodel.typeofinfraction == "مساحه" {
            infractionImageView.image = UIImage(named: "area")
        }
        else {
            infractionImageView.image = UIImage(named: "bussiness")
        }
    }
    
}
