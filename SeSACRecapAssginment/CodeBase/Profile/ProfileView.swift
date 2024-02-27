//
//  ProfileView.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 2/26/24.
//

import UIKit
import TextFieldEffects
import SnapKit

class ProfileView: BaseView {
    let profileImageView = ProfileImageView(frame: .zero)
    let cameraImageView = UIImageView()
    lazy var nicknameTextField:HoshiTextField = {
        let view = HoshiTextField()

        return view
    }()
    let statusLabel = UILabel()
    let completeButton = CompleteButton()

    
    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(cameraImageView)
        addSubview(nicknameTextField)
        addSubview(statusLabel)
        addSubview(completeButton)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide).inset(50)
            make.size.equalTo(120)
        }
        cameraImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView).inset(5)
            make.size.equalTo(profileImageView).multipliedBy(0.25)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.height.equalTo(25)
        }
        statusLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nicknameTextField).inset(20)
            make.top.equalTo(nicknameTextField).offset(40)
        }
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nicknameTextField)
            make.height.equalTo(50)
            make.top.equalTo(statusLabel.snp.bottom).offset(40)
        }
    }
    
    override func configureView() {
        cameraImageView.image = UIImage(named: "camera")
        
        completeButton.setTitle("완료", for: .normal)
        
        nicknameTextField.borderInactiveColor = .white
        nicknameTextField.borderActiveColor = UIColor(named: Color.PointColor.rawValue)
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.placeholderColor = .white
        nicknameTextField.textColor = .white
        
        statusLabel.text = "닉네임을 입력해 주세요"
        statusLabel.textColor = UIColor(named: Color.PointColor.rawValue)
        statusLabel.font = .systemFont(ofSize: 13)
    }

}
