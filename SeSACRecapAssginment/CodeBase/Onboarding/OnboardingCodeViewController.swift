//
//  OnboardingCodeViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/29/24.
//

import UIKit

#Preview {
    OnboardingCodeViewController()
}

class OnboardingCodeViewController: UIViewController {
    
    let titleImageView = UIImageView()
    let shoppingImageView = UIImageView()
    let startButton = CompleteButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        configureHierarchy()
        configureConstraint()
        configureView()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetProfile()
    }
}

extension OnboardingCodeViewController {
    func configureHierarchy() {
        view.addSubview(titleImageView)
        view.addSubview(shoppingImageView)
        view.addSubview(startButton)
    }
    func configureView() {
        titleImageView.image = UIImage(named: "sesacShopping")
        titleImageView.contentMode = .scaleAspectFit
        
        shoppingImageView.image = UIImage(named: "onboarding")
        shoppingImageView.contentMode = .scaleAspectFill
        
        startButton.setTitle("시작하기", for: .normal)
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    func configureConstraint() {
        titleImageView.snp.makeConstraints { make in
            
            make.centerX.equalTo(view)
            make.top.equalTo(50)
            make.width.equalTo(view).multipliedBy(0.6)
            make.height.equalTo(shoppingImageView.snp.width).multipliedBy(0.6)
        }
        
        shoppingImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(titleImageView.snp.bottom).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(shoppingImageView.snp.width)
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.horizontalEdges.equalTo(view).inset(20)
            make.bottom.equalTo(view).inset(50)
            make.height.equalTo(50)
        }
        
    }
}

extension OnboardingCodeViewController {

    @objc func startButtonClicked() {
        // 코드로 이동하기
        print(#function)
        // TODO: 제네릭, 메타 타입
        let vc = ProfileCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func resetProfile() {
        UserDefaultManager.shaerd.userNickname = ""
        UserDefaultManager.shaerd.userImage = ""
        UserDefaultManager.shaerd.userSearch = []
        UserDefaultManager.shaerd.userStatus = false
    }
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "필요하신 물품은 없으신가요?"
        notificationContent.body = "없는 물건이 없어요! 필요하신 물건을 검색해 보세요!"
        notificationContent.badge = 100
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(Date())", content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
