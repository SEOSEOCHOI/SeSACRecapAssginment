//
//  SearchResultCodeCollectionViewCell.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/30/24.
//

import UIKit

class SearchResultCodeCollectionViewCell: UICollectionViewCell {
    let resultImageView = UIImageView()
    let likeButton = LikeButton()
    let productNameLabel = UILabel()
    let mallNameLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(resultImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(priceLabel)
        
        // TODO: 레이아웃 수정
        resultImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(resultImageView.snp.width)
        }
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(resultImageView).multipliedBy(0.3)
            make.trailing.bottom.equalTo(resultImageView).inset(10)
        }
        mallNameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(resultImageView)
            make.top.equalTo(resultImageView.snp.bottom).offset(10)
        }
        productNameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(productNameLabel)
            make.top.equalTo(productNameLabel.snp.bottom).offset(10)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(productNameLabel)
            make.top.equalTo(productNameLabel.snp.bottom).offset(10)
        }
        
        
        resultImageView.layer.cornerRadius = 10
        
        mallNameLabel.font = .systemFont(ofSize: 15)
        mallNameLabel.textColor = .lightGray
        mallNameLabel.textAlignment = .left
        
        productNameLabel.numberOfLines = 2
        productNameLabel.font = .systemFont(ofSize: 15)
        productNameLabel.textAlignment = .left
        
        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.textAlignment = .left

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SearchResultCodeCollectionViewCell {
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
