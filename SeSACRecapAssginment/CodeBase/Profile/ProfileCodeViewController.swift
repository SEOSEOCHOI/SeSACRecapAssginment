//
//  ProfileCodeViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/29/24.
//

import UIKit
import TextFieldEffects

#Preview {
    ProfileCodeViewController()
}

enum ValidationError: Error {
    case isContainNumber
    case isLengthOver
    case iscontainSpecial
}

class ProfileCodeViewController: UIViewController {
    var profileImageName: String = ""
    
    let profileImageView = ProfileImageView(frame: .zero)
    let cameraImageView = UIImageView()

    
    lazy var nicknameTextField:HoshiTextField = {
        let view = HoshiTextField()
        view.placeholder = "영화를 검색해 보세요"
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        return view
    }()
    let statusLabel = UILabel()
    let completeButton = CompleteButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        setBackgroundColor()
        configureHeirarchy()
        configureConstarints()
        configureView()
        configureTapGestureRecognizer()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        if UserDefaultManager.shaerd.userImage != "" {
            profileImageName = UserDefaultManager.shaerd.userImage
            profileImageView.image = UIImage(named: profileImageName)
        }
    }
}

extension ProfileCodeViewController {
    func configureNavigationItem() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "프로필 설정"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureHeirarchy() {
        view.addSubview(profileImageView)
        view.addSubview(cameraImageView)
        view.addSubview(nicknameTextField)
        view.addSubview(statusLabel)
        view.addSubview(completeButton)
    }
    
    func configureConstarints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.size.equalTo(120)
        }
        cameraImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView).inset(5)
            make.size.equalTo(profileImageView).multipliedBy(0.25)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(20)
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
    
    func configureView() {
        guard let profileImage = ProfileImage.allCases.randomElement()?.rawValue else { return }
        
        profileImageName = profileImage
        profileImageView.image = UIImage(named: profileImage)
        
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

extension ProfileCodeViewController {
    @objc func compliteButtonCliked() {
        UserDefaultManager.shaerd.userNickname = nicknameTextField.text!
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
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapGestureRecognizerAction() {
        let vc = ProfileSettingCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Textfield 기능
extension ProfileCodeViewController: UITextFieldDelegate {
    @objc func textFieldDidChanged() {
        guard let text = nicknameTextField.text else { return }
        do {
            let _ = try validateUserInputError(text: text)
            statusLabel.text = "사용할 수 있는 닉네임이에요"
            completeButton.isEnabled = true
            completeButton.addTarget(self, action: #selector(compliteButtonCliked), for: .touchUpInside)
            print(text)
        } catch {
            switch error {
            case ValidationError.isLengthOver:
                print("2글자 이상 10글자 미만으로 설정해 주세요")
                statusLabel.text = "2글자 이상 10글자 미만으로 설정해 주세요"
                completeButton.isEnabled = false
            case ValidationError.isContainNumber:
                print("닉네임에 숫자를 포함할 수 없어요.")
                statusLabel.text = "닉네임에 숫자를 포함할 수 없어요."
                completeButton.isEnabled = false
            case ValidationError.iscontainSpecial:
                print("닉네임에 @, #, $, %는 포함할 수 없어요.")
                statusLabel.text = "닉네임에 @, #, $, %는 포함할 수 없어요."
                completeButton.isEnabled = false
            default: break
            }
        }
    }
    
    func validateUserInputError(text: String) throws -> Bool {
        let numberPattern: String = "^.*[0-9].*$"
        let specialPattern: String = "^.*[@#$%].*$"

        
        guard text.count >= 2, text.count < 10 else {
            throw ValidationError.isLengthOver
        }
        
        guard text.range(of: specialPattern, options: .regularExpression) == nil else {
            throw ValidationError.iscontainSpecial
        }
        
        guard text.range(of: numberPattern, options: .regularExpression) == nil else {
            throw ValidationError.isContainNumber
        }
    return true
    }
}


