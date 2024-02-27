//
//  ProfileCodeViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/29/24.
//

import UIKit

#Preview {
    ProfileCodeViewController()
}

class ProfileCodeViewController: BaseViewController {
    let viewModel = ProfileSettingViewModel()
    let mainView = ProfileView()
    override func loadView() {
        self.view = mainView
    }

    var profileImageName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        setBackgroundColor()
        configureTapGestureRecognizer()
        
        mainView.nicknameTextField.delegate = self
        mainView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        bindData()
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaultManager.shaerd.userImage != "" {
            profileImageName = UserDefaultManager.shaerd.userImage
            mainView.profileImageView.image = UIImage(named: profileImageName)
        }
    }
    
    func bindData() {
        viewModel.outputVlidation.bind { value in
            self.mainView.statusLabel.text = value
        }
        viewModel.outputValidationColor.bind { value in
            if value == true {
                self.mainView.statusLabel.textColor = .green
                self.mainView.completeButton.isEnabled = value
                self.mainView.completeButton.addTarget(self, action: #selector(self.compliteButtonCliked), for: .touchUpInside)
            } else {
                self.mainView.statusLabel.textColor = .red
                self.mainView.completeButton.isEnabled = value
            }
        }
    }
    
    override func configureView() {
        guard let profileImage = ProfileImage.allCases.randomElement()?.rawValue else { return }
        
        profileImageName = profileImage
        
        mainView.profileImageView.image = UIImage(named: profileImage)
    }
}

extension ProfileCodeViewController {
    func configureNavigationItem() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "프로필 설정"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}

extension ProfileCodeViewController {
    @objc func compliteButtonCliked() {
        UserDefaultManager.shaerd.userNickname = mainView.nicknameTextField.text!
        UserDefaultManager.shaerd.userImage = profileImageName
        UserDefaultManager.shaerd.userStatus = true
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
            let vc = MainSearchCodeViewController()
        let nav = UINavigationController(rootViewController: vc)
            sceneDelegate?.window?.rootViewController = nav

        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func configureTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction))
        mainView.profileImageView.addGestureRecognizer(tapGestureRecognizer)
        mainView.profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapGestureRecognizerAction() {
        let vc = ProfileSettingCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Textfield 기능
extension ProfileCodeViewController: UITextFieldDelegate {
    @objc func textFieldDidChanged() {
        guard let text = mainView.nicknameTextField.text else { return }
        viewModel.inputNickname.value = text
    }
}


