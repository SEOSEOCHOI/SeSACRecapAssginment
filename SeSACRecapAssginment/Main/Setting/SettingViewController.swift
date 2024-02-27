//
//  SettingViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/21/24.
//

import UIKit

class SettingViewController: UIViewController {
    
    let settingTableView = UITableView()
    
    let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureView()
    }
    // TODO: 값전달로 값 변경될 때마다 데이터 수정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingTableView.reloadData()
    }
}

extension SettingViewController {
    func configureView() {
        navigationItem.title = "설정"
    }
}


extension SettingViewController {
    func showAlert() {
        let alert = UIAlertController(title: "처음부터 시작하기", message: "데이터를 모두 초기화하겠습니까?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default) { action in
            
            UserDefaultManager.shaerd.userImage = ""
            UserDefaultManager.shaerd.userNickname = ""
            UserDefaultManager.shaerd.userLike = []
            UserDefaultManager.shaerd.userSearch = []
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene // 씬 딜리게이트 가져오기
            let sceneDelegate = windowScene?.delegate as? SceneDelegate

            let sb = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = sb.instantiateViewController(identifier: OnboradingViewController.identifier) as! OnboradingViewController
            let nav = UINavigationController(rootViewController: vc)
            
            sceneDelegate?.window?.rootViewController = nav
            sceneDelegate?.window?.makeKeyAndVisible()
        }
        let cancle = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(ok)
        alert.addAction(cancle)
        
        present(alert, animated: true)
    }
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.numberOfRowsInSection
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingProfileTableViewCell.identifier, for: indexPath) as! SettingProfileTableViewCell

            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
            
            cell.configureCell(data: viewModel.cellForRowAt(indexPath))
            cell.settingTitleLabel.font = .systemFont(ofSize: 13)
            
            if indexPath.row != viewModel.settingList.endIndex - 1
            {
                cell.selectionStyle = .none
            }
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let sb = UIStoryboard(name: "Profile", bundle: nil)
            
            let vc = sb.instantiateViewController(withIdentifier: ProfileViewController.identifier) as! ProfileViewController
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            if indexPath.row == viewModel.settingList.endIndex - 1
            {
                showAlert()
            }
        }
    }
    func configureTableView() {
        let xib = UINib(nibName: SettingTableViewCell.identifier, bundle: nil)
        
        settingTableView.register(xib, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
        let xib2 = UINib(nibName: SettingProfileTableViewCell.identifier, bundle: nil)
        
        settingTableView.register(xib2, forCellReuseIdentifier: SettingProfileTableViewCell.identifier)
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
}
