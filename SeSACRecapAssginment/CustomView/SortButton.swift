//
//  SortButton.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/30/24.
//

import UIKit
class SortButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .white
        layer.borderWidth = 1
        layer.cornerRadius = self.bounds.width * 0.3
        layer.borderColor = UIColor.white.cgColor
        titleLabel?.font = .boldSystemFont(ofSize: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
