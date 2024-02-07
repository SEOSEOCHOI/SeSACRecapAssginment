//
//  LikeButton.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/30/24.
//

import UIKit

class LikeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .black
        setTitle("", for: .normal)
        backgroundColor = .white
        setRadius(button: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



