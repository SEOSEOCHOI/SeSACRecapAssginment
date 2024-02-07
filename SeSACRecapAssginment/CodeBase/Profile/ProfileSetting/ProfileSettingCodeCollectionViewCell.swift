//
//  ProfileSettingCodeCollectionViewCell.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/29/24.
//

import UIKit

class ProfileSettingCodeCollectionViewCell: UICollectionViewCell {
    let profileImageView = ProfileImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.center.equalTo(contentView)
            make.size.equalTo(contentView).multipliedBy(0.9)
        }
        
        profileImageView.setRadius(image: profileImageView)
}
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileSettingCodeCollectionViewCell {
    func configureCell(image: String, select: String) {
        profileImageView.image = UIImage(named: image)
        
        if select == image {
            profileImageView.setBorder(image: profileImageView)
        } else {
            profileImageView.layer.borderWidth = 0
        }
        
    }
}
