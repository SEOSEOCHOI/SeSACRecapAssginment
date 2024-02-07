//
//  ProfileImageView.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/29/24.
//

import UIKit

class ProfileImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        layer.borderWidth = 6
        layer.borderColor = UIColor(named: Color.PointColor.rawValue)?.cgColor
        
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.frame.width / 2
        }
        layer.masksToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
