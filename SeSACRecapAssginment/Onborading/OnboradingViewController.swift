//
//  onboradingViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/18/24.
//

import UIKit

class OnboradingViewController: UIViewController {
    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var shoppingImageView: UIImageView!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var onboradView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetProfile()
    }
    
    @objc func startButtonClicked() {
        let sb = UIStoryboard(name: "Profile", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ProfileViewController.identifier) as! ProfileViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension OnboradingViewController {
    func configureView() {
        setBackgroundColor()
        
        titleImageView.image = UIImage(named: "sesacShopping")
        titleImageView.contentMode = .scaleAspectFit
        
        shoppingImageView.image = UIImage(named: "onboarding")
        shoppingImageView.contentMode = .scaleAspectFill
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        startButton.backgroundColor = UIColor(named: "PointColor")
        startButton.layer.cornerRadius = 10
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
