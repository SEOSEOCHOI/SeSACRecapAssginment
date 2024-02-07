//
//  MainSearchViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/28/24.
//

#Preview {
    MainSearchCodeViewController()
}

import UIKit
import SnapKit

class MainSearchCodeViewController: UIViewController {
    
    lazy var searchList: [String] = UserDefaultManager.shaerd.userSearch
    
    let searchBar = UISearchBar()
    let backView = UIView()
    let recentLabel = UILabel()
    let deleteButton = UIButton()
    let searchTableView = UITableView()
    let blankImageView = UIImageView()
    let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.backgroundColor = .white
        setBackgroundColor()
        
        configureHierarchy()
        configureView()
        configureConstraints()
        
        configureNavigationItem()
        configureTableView()
    }
}

extension MainSearchCodeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: MainSearchCodeTableViewCell.identifier, for: indexPath) as! MainSearchCodeTableViewCell

        
        cell.configureCell(data: searchList[indexPath.row])
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteCellClicked), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteCellClicked(sender: UIButton) {
        searchList.remove(at: sender.tag)
        UserDefaultManager.shaerd.userSearch = searchList
        searchTableView.reloadData()
        isEmptySearchList()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        // TODO: 화면이동
        print(indexPath)
        let sb = UIStoryboard(name: "SearchResult", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as! SearchResultViewController
        
        
        vc.userFind = searchList[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}



extension MainSearchCodeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let item = searchBar.text else { return }
        var isDuplicate = false
        
        if !UserDefaultManager.shaerd.userSearch.isEmpty {
            for data in 0 ... UserDefaultManager.shaerd.userSearch.count - 1 {
                if UserDefaultManager.shaerd.userSearch[data].lowercased() == item.lowercased() {
                    isDuplicate = true
                    searchList.remove(at: data)
                    searchList.insert(item, at: 0)
                }
            }
        } else {
            searchList.insert(item, at: 0)
            isDuplicate = true
        }

        if !isDuplicate {
            searchList.insert(item, at: 0)
        }
        UserDefaultManager.shaerd.userSearch = searchList
        
        isEmptySearchList()
        
        searchTableView.reloadData()
        
        searchBar.text = ""
        

        let vc = SearchResultCodeViewController()
        
        vc.userFind = item
        print("화면전환")
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainSearchCodeViewController {
    func configureNavigationItem() {
        navigationItem.title = "\(UserDefaultManager.shaerd.userNickname)님의 새싹쇼핑"
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        searchBar.delegate = self
    }
    
    func configureTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(MainSearchCodeTableViewCell.self, forCellReuseIdentifier: MainSearchCodeTableViewCell.identifier)
    }
    
    func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(backView)
        backView.addSubview(recentLabel)
        backView.addSubview(deleteButton)
        view.addSubview(searchTableView)
        view.addSubview(blankImageView)
        view.addSubview(statusLabel)

    }
    
    func configureView() {
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        
        isEmptySearchList()
        
        blankImageView.image = .empty
        blankImageView.contentMode = .scaleAspectFit
        
        statusLabel.text = "최근 검색어가 없어요"
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        statusLabel.font = .boldSystemFont(ofSize: 17)
        
        backView.backgroundColor = .clear
        recentLabel.text = "최근 검색"
        recentLabel.font = .boldSystemFont(ofSize: 15)
        
        deleteButton.setTitle("모두 지우기", for: .normal)
        deleteButton.setTitleColor(UIColor(named: Color.PointColor.rawValue), for: .normal)
        deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    func isEmptySearchList() {
        print(#function)
        if UserDefaultManager.shaerd.userSearch.isEmpty {
            backView.isHidden = true
            searchTableView.isHidden = true
            blankImageView.isHidden = false
            statusLabel.isHidden = false
        } else {
            blankImageView.isHidden = true
            statusLabel.isHidden = true
            backView.isHidden = false
            searchTableView.isHidden = false
        }
    }
    
    func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        blankImageView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(blankImageView.snp.width)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(blankImageView)
            make.top.equalTo(blankImageView.snp.bottom).offset(-20)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(50)
        }
        recentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalTo(backView).inset(10)
        }
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalTo(backView).inset(10)
        }
        searchTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(backView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func deleteButtonClicked() {
        searchList.removeAll()
        UserDefaultManager.shaerd.userSearch = searchList
        isEmptySearchList()
        searchTableView.reloadData()
    }
}
