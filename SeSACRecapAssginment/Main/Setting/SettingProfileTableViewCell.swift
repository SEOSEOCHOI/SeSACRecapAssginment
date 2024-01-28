//
//  SettingProfileTableViewCell.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/21/24.
//

import UIKit

class SettingProfileTableViewCell: UITableViewCell {
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var uesrNameLabel: UILabel!
    @IBOutlet var userLikesCountLabel: UILabel!
    @IBOutlet var userStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uesrNameLabel.font = .boldSystemFont(ofSize: 17)
        
        userLikesCountLabel.font = .systemFont(ofSize: 15)
        userLikesCountLabel.textColor = UIColor(named: Color.PointColor.rawValue)
        
        userStatusLabel.text = "을 좋아하고 있어요!"
        userStatusLabel.font = .systemFont(ofSize: 15)
        
        userProfileImageView.setBorder(image: userProfileImageView)
        userProfileImageView.setRadius(image: userProfileImageView)
        
        uesrNameLabel.text = UserDefaultManager.shaerd.userNickname
        
        userLikesCountLabel.text = "\(UserDefaultManager.shaerd.userLike.count)개의 상품을"
        
        userProfileImageView.image = UIImage(named: UserDefaultManager.shaerd.userImage)
    }
    
}
