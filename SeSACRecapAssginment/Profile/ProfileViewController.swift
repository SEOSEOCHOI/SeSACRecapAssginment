//
//  ProfileViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/18/24.
//

import UIKit
import TextFieldEffects

class ProfileViewController: UIViewController {
    var profileImageName: String = ""
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var nicknameTextField: HoshiTextField!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var compliteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureView()
        configureTapGestureRecognizer()
        configureStatusLable()
        configureTextField()
        

        nicknameTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        if UserDefaultManager.shaerd.userImage != "" {
            profileImageName = UserDefaultManager.shaerd.userImage // 인스턴스의 프로퍼티 가지고 오고 있는 상태라 get 호출함
            profileImageView.image = UIImage(named: profileImageName)
        }
    }
    
    // MARK: 화면 전환
    @objc func compliteButtonCliked() {
        
        UserDefaultManager.shaerd.userNickname = nicknameTextField.text!
        UserDefaultManager.shaerd.userImage = profileImageName
        
        UserDefaultManager.shaerd.userStatus = true
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        if UserDefaultManager.shaerd.userSearch.isEmpty {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "mainTabBarController") as! UITabBarController
            sceneDelegate?.window?.rootViewController = vc
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "mainSearchTabBarController") as! UITabBarController
            sceneDelegate?.window?.rootViewController = vc
        }

        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
}
// MARK: View
extension ProfileViewController {
    func configureNavigationItem() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "프로필 설정"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureView() {
        setBackgroundColor()
        // MARK: set ProfileImage
        guard let profileImage = ProfileImage.allCases.randomElement()?.rawValue else { return }
        profileImageName = profileImage
        profileImageView.image = UIImage(named: profileImage)
        profileImageView.setBorder(image: profileImageView)
        profileImageView.setRadius(image: profileImageView)
        
        // MARK: set cameraButton
        // TODO: imageView로 수정
        cameraButton.setTitle("", for: .normal)
        cameraButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        cameraButton.tintColor = .white
        cameraButton.backgroundColor = UIColor(named: Color.PointColor.rawValue)
        cameraButton.setRadius(button: cameraButton)
        cameraButton.layer.borderWidth = 3
        cameraButton.layer.borderColor = UIColor.white.cgColor
        
        compliteButton.setTitle("완료", for: .normal)
        compliteButton.setTitleColor(.white, for: .normal)
        compliteButton.backgroundColor = UIColor(named: Color.PointColor.rawValue)
    }
    
    // MARK: TapGestureReconizer
    func configureTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapGestureRecognizerAction() {
        // TODO: 스토리보드 명 직접 입력하지 않기
        let sb = UIStoryboard(name: "ProfileSetting", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ProfileSettingViewController.identifier) as! ProfileSettingViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: set TextField
    func configureTextField() {
        // TODO: active: 조건 ?? pointColor : errorColor
        nicknameTextField.borderInactiveColor = .white
        nicknameTextField.borderActiveColor = UIColor(named: Color.PointColor.rawValue)
        nicknameTextField.backgroundColor = .clear
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.textColor = .white
    }
    
    func configureStatusLable() {
        statusLabel.text = "닉네임을 입력해 주세요"
        statusLabel.textColor = UIColor(named: Color.PointColor.rawValue)
        statusLabel.font = .systemFont(ofSize: 13)
    }
    
}
// MARK: Textfield 기능
extension ProfileViewController: UITextFieldDelegate {
    // TODO: Regex 학습
    @objc func textFieldDidChanged() {
        statusLabel.text = ""
        

        if nickname() == true {
            statusLabel.text = "2글자 이상 10글자 미만으로 설정해 주세요"
        }
        
        if nickname2() == true {
            statusLabel.text = "닉네임에 @, #, $, %는 포함할 수 없어요."
        }

        if nickname3() == true {
            statusLabel.text = "닉네임에 숫자를 포함할 수 없어요."
        }
        
        if !nickname() && !nickname2() && !nickname3() {
            compliteButton.isEnabled = true

            compliteButton.addTarget(self, action: #selector(compliteButtonCliked), for: .touchUpInside)
        } else {
            compliteButton.isEnabled = false
        }
    }
    
    func nickname() -> Bool {
        if let nickname = nicknameTextField.text {
            if nickname.count < 2 || nickname.count > 10 {
                return true
            }
        }
        return false
    }
    
    func nickname2() -> Bool {
        if let nickname = nicknameTextField.text {
            if nickname.contains("@") ||
                nickname.contains("#") ||
                nickname.contains("$") ||
                nickname.contains("%") {
                return true
            }
        }
        return false
    }
    
    func nickname3() -> Bool  {
        let pattern: String = "^.*[0-9].*$"
        
        let nickname = nicknameTextField.text!
        if nickname.range(of: pattern, options: .regularExpression) != nil {
            return true
        }
        return false
    }
}


