//
//  UIButton + Extension.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/19/24.
//

import UIKit
extension UIButton {
    func setRadius(button: UIButton) {
        DispatchQueue.main.async {
            button.layer.cornerRadius = button.frame.width / 2
        }
    }
}
