//
//  ViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/18/24.
//

import UIKit

class MainController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureView()
    }
}

extension MainController {
    func configureNavigation() {
        navigationItem.title = "\(UserDefaultManager.shaerd.userNickname)님의 새싹 쇼핑"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureView() {
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        
        backgroundImageView.image = .empty
        backgroundImageView.contentMode = .scaleAspectFit
        
        statusLabel.text = "최근 검색어가 없어요"
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        statusLabel.font = .boldSystemFont(ofSize: 17)
    }
}

extension MainController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let item = searchBar.text {
            
            if !UserDefaultManager.shaerd.userSearch.contains(item) {
                UserDefaultManager.shaerd.userSearch.insert(item, at: 0)
            }

            let sb = UIStoryboard(name: "SearchResult", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as! SearchResultViewController
            
            vc.userFind = item
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
