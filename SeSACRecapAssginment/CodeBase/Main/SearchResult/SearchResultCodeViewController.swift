//
//  SearchResultCodeViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/30/24.
//

import UIKit
import Kingfisher
import Alamofire

enum sortWay: String, CaseIterable {
    case sim
    case date
    case asc
    case dsc
    
    var sortList: String {
        switch self {
        case .sim:
            " 정확도 "
        case .date:
            " 날짜순 "
        case .asc:
            " 가격높은순 "
        case .dsc:
            " 가격낮은순 "
        }
    }
}

class SearchResultCodeViewController: BaseViewController {
    
    let mainView = SearchResultView()
    
    override func loadView() {
        self.view = mainView
    }
    let viewModel = NerworkViewModel()

    var list: [Item] = []
    
    var userFind: String = ""
    var sort = ""
    var start = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigation()
        bindData()
    }
    
    func bindData() {
        viewModel.outputData.bind { _ in
            self.mainView.searchResultCollectionView.reloadData()
        }
    }
    
    override func configureView() {
        for button in mainView.sortButton {
            button.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
        }
        
        viewModel.inputViewDidLoadTrigger.value = ()
        
        ShoppingSessionManager.shared.request(type: Shopping.self, text: userFind, sort: sortWay.sim.rawValue, start: String(start), completionHandler: { value, error in
            if error == nil {
                guard let value = value else { return }
                self.mainView.amountLabel.text = "\(value.total)개의 검색 결과"
                
                self.list = value.items
                self.sort = sortWay.sim.rawValue
                self.shopping = value
                self.mainView.searchResultCollectionView.reloadData()
            } else {
                guard let error = error else { return }
                switch error {
                case SeSACError.noData: print("데이터 없음")
                case SeSACError.failedRequset: print("잘못된 요청")
                case SeSACError.invaildResponse: print("응답 잘못됨 이게머지")
                case SeSACError.invaildData: print("잘못된 데이터")
                default: print("알 수 없음")
                }
            }
        })
    }
    @objc func sortButtonClicked(_ sender: UIButton) {
        start = 1
        
        for button in mainView.sortButton {
            if button.tag == sender.tag {
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .black
            }
        }
        
        manager.callRequest(text: userFind, sort: sortWay.allCases[sender.tag].rawValue, start: String(start)) { value in
            self.sort = self.sort
            self.list = value.items
            self.mainView.searchResultCollectionView.reloadData()
            self.shopping = value
        }
    }
}

extension SearchResultCodeViewController {
    func configureNavigation() {
        navigationItem.title = userFind

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    @objc func backButtonClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchResultCodeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCodeCollectionViewCell.identifier, for: indexPath) as! SearchResultCodeCollectionViewCell
        
        let data = list[indexPath.row]
        
        cell.configureCell(data: data)
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    @objc func likeButtonClicked(sender: UIButton) {
        var like = UserDefaultManager.shaerd.userLike
        let productId = list[sender.tag].productID
        
        if !UserDefaultManager.shaerd.userLike.contains(productId) {
            like.append(productId)
            UserDefaultManager.shaerd.userLike = like
        } else {
            if let index = UserDefaultManager.shaerd.userLike.firstIndex(of: productId) {
                like.remove(at: index)
                UserDefaultManager.shaerd.userLike = like
            }
        }
        mainView.searchResultCollectionView.reloadItems(at: [IndexPath(row: sender.tag, section: 0)])
    }
}

extension SearchResultCodeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if viewModel.outputData.value.count - 3 == item.row && isEnd(start: start, count: 30, data: shopping ) == false {
                
                start += 30
                viewModel.
                
                ShoppingSessionManager.shared.request(type: Shopping.self, text: userFind, sort: sort, start: String(start)) { value, error in
                    if error == nil {
                        guard let value = value else { return }
                        
                        if self.start == 1 {
                            self.list = value.items
                        } else {
                            self.list.append(contentsOf: value.items)
                        }
                        
                        self.mainView.searchResultCollectionView.reloadData()
                        
                        if self.start == 1 {
                            self.mainView.searchResultCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                        }
                        
                    } else {
                        guard let error = error else { return }
                        switch error {
                        case SeSACError.noData: print("데이터 없음")
                        case SeSACError.failedRequset: print("잘못된 요청")
                        case SeSACError.invaildResponse: print("응답 잘못됨 이게머지")
                        case SeSACError.invaildData: print("잘못된 데이터")
                        default: print("알 수 없음")
                        }
                    }
                }
            }
        }
    }
    
    func isEnd(start: Int, count:Int, data: Shopping) -> Bool {
        if (count * start) == data.total {
            return true
        }
        return false
    }
}

extension SearchResultCodeViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "SearchDetail", bundle: nil)
        let vc = sb.instantiateViewController(identifier: SearchDetailViewController.identifier) as! SearchDetailViewController
        let data = viewModel.outputData.value[indexPath.item]
        let url = "https://msearch.shopping.naver.com/product/\(data.productID)"
        
        vc.urlString = url
        vc.userFind = userFind
        vc.userLike = data.productID
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureCollectionView() {
        mainView.searchResultCollectionView.delegate = self
        mainView.searchResultCollectionView.dataSource = self
        mainView.searchResultCollectionView.prefetchDataSource = self
    }
}
