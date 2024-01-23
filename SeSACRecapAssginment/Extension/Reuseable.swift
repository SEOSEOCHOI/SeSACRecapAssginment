//
//  Reuseable.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/20/24.
//

import UIKit
extension UICollectionView: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableView: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
