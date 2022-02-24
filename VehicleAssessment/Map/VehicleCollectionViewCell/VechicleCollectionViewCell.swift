//
//  VechicleCollectionViewCell.swift
//  VehicleAssessment
//
//  Created by Tejas Dubal on 22/02/22.
//

import UIKit
import Kingfisher

class VechicleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var driveLabel: UILabel!
    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var parkLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    
    var model: VehicleModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell() {
        carImageView.kf.setImage(with: URL(string: model?.vehiclePicAbsoluteUrl ?? ""), placeholder: UIImage(named: "demoCar"))
    }
    
    
    class var reuseIdentifier: String {
        return "VechicleCollectionViewCell"
    }
    class var nibName: String {
        return "VechicleCollectionViewCell"
    }
    
    
}
