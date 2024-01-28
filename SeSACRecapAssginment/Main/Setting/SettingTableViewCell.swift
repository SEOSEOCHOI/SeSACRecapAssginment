//
//  SettingTableViewCell.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/21/24.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    @IBOutlet var settingTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingTitleLabel.font = .systemFont(ofSize: 13)
    }
}

extension SettingTableViewCell {
    
    func configureCell(data: String) {
        settingTitleLabel.text =  data

    }
}
