//
//  CollectionViewCell.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/19/24.
//

import UIKit

class ProfileSettingCollectionViewCell: UICollectionViewCell {

    @IBOutlet var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.setRadius(image: profileImageView)
    }
}

extension ProfileSettingCollectionViewCell {
    func configureCell(image: String, select: String) {
        profileImageView.image = UIImage(named: image)
        
        if select == image {
            profileImageView.setBorder(image: profileImageView)
        } else {
            profileImageView.layer.borderWidth = 0
        }
        
    }
}
