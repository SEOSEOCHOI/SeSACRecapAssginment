//
//  CompleteButton.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/29/24.
//

import UIKit

class CompleteButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 17)
        backgroundColor = UIColor(named: "PointColor")
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
