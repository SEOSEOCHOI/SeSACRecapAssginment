//
//  searchResultCollectionViewCell.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/21/24.
//

import UIKit
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet var resultImageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var mallNameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resultImageView.layer.cornerRadius = 10
        
        mallNameLabel.font = .systemFont(ofSize: 15)
        mallNameLabel.textColor = .lightGray
        
        productNameLabel.numberOfLines = 2
        productNameLabel.font = .systemFont(ofSize: 15)
        
        priceLabel.font = .boldSystemFont(ofSize: 16)
        
        likeButton.tintColor = .black
        likeButton.setTitle("", for: .normal)
        likeButton.backgroundColor = .white
        likeButton.setRadius(button: likeButton)

    }

}

extension SearchResultCollectionViewCell {
    func configureCell(data: Item){
        
        
        let url = URL(string: data.image)
        
        resultImageView.kf.setImage(with: url)

        mallNameLabel.text = data.mallName
        
        productNameLabel.text = data.title

        priceLabel.text = data.lprice
        
        let image = UserDefaultManager.shaerd.userLike.contains(data.productID) ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: image), for: .normal)

        
    }
}
