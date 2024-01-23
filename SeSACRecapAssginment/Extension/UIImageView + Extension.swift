//
//  UIImageView + Extension.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/18/24.
//

import UIKit

extension UIImageView {
    func setBorder(image: UIImageView) {
        image.layer.borderWidth = 6
        image.layer.borderColor = UIColor(named: Color.PointColor.rawValue)?.cgColor
    }
    
    func setRadius(image: UIImageView) {
        DispatchQueue.main.async {
            image.layer.cornerRadius = image.frame.width / 2
        }
    }
}
