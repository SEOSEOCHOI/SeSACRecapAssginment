//
//  MainSearchCodeTableViewCell.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/28/24.
//

import UIKit

class MainSearchCodeTableViewCell: UITableViewCell {
    
    let searchImage = UIImageView()
    let titleLabel = UILabel()
    let deleteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(searchImage)
        
        searchImage.image = UIImage(systemName: "magnifyingglass")
        searchImage.tintColor = .lightGray
        
        deleteButton.setTitle("", for: .normal)
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .lightGray
        
        titleLabel.font = .systemFont(ofSize: 13)
        
        deleteButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.trailingMargin.equalTo(contentView)
        }
        
        searchImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.leftMargin.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchImage.snp.trailing).offset(10)
            make.centerY.equalTo(searchImage)
            make.trailing.equalTo(deleteButton.snp.trailing).inset(8)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MainSearchCodeTableViewCell {
    func configureCell(data: String) {
        titleLabel.text = data
    }
}
