//
//  MainSearchViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/20/24.
//

import UIKit

class MainSearchViewController: UIViewController {
    var searchList: [String] = UserDefaultManager.shaerd.userSearch
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var backView: UIView!
    @IBOutlet var recentLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureTableView()
        configureNavigationItem()
    }
}



extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainSearchTableViewCell.identifier, for: indexPath) as! MainSearchTableViewCell
        
        cell.configureCell(data: searchList[indexPath.row])
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteCellClicked), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteCellClicked(sender: UIButton) {
        searchList.remove(at: sender.tag)
        UserDefaultManager.shaerd.userSearch = searchList
        searchTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "SearchResult", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as! SearchResultViewController
        
       UserDefaultManager.shaerd.userSearch = searchList

        searchTableView.reloadData()

        vc.userFind = searchList[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let item = searchBar.text else { return }
            var isDuplicate = false
            
            for data in UserDefaultManager.shaerd.userSearch {
                if data.lowercased() == item.lowercased() {
                    isDuplicate = true
                    break
                }
            }
                if !isDuplicate {
                    searchList.insert(item, at: 0)
            }
        

            UserDefaultManager.shaerd.userSearch = searchList
            searchTableView.reloadData()
            
            searchBar.text = ""
            
            let sb = UIStoryboard(name: "SearchResult", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as! SearchResultViewController
            
            vc.userFind = item
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }


extension MainSearchViewController {
    func configureView() {
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        
        backView.backgroundColor = .clear
        recentLabel.text = "최근 검색"
        recentLabel.font = .boldSystemFont(ofSize: 15)
        
        deleteButton.setTitle("모두 지우기", for: .normal)
        deleteButton.setTitleColor(UIColor(named: Color.PointColor.rawValue), for: .normal)
        deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    @objc func deleteButtonClicked() {
        searchList.removeAll()
        UserDefaultManager.shaerd.userSearch = searchList
        
        searchTableView.reloadData()
        
        navigationController?.popViewController(animated: true)
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene // 씬 딜리게이트 가져오기
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let vc = storyboard?.instantiateViewController(identifier: "mainTabBarController") as! UITabBarController
        
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
        
    }
    
    func configureTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        let xib = UINib(nibName: MainSearchTableViewCell.identifier, bundle: nil)
        searchTableView.register(xib, forCellReuseIdentifier: MainSearchTableViewCell.identifier)
    }
    
    func configureNavigationItem() {
        navigationItem.title = "\(UserDefaultManager.shaerd.userNickname)님의 새싹쇼핑"
        searchBar.delegate = self
        
    }
}


