//
//  MainSearchTableViewCell.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/20/24.
//

import UIKit

class MainSearchTableViewCell: UITableViewCell {

    @IBOutlet var searchImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        searchImage.image = UIImage(systemName: "magnifyingglass")
        searchImage.tintColor = .lightGray
        
        deleteButton.setTitle("", for: .normal)
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .lightGray
        
        titleLabel.font = .systemFont(ofSize: 13)
    }
}

extension MainSearchTableViewCell {
    func configureCell(data: String) {
        titleLabel.text = data
    }
}
