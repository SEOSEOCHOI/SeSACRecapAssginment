//
//  SearchResultCodeViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/30/24.
//

import UIKit
import Kingfisher
import Alamofire

class SearchResultCodeViewController: UIViewController {
    
    enum sortWay: String, CaseIterable {
        case sim
        case date
        case asc
        case dsc
    }
    
    let sortDictionaty = [
        sortWay.sim.rawValue : " 정확도 ",
        sortWay.date.rawValue : " 날짜순 ",
        sortWay.asc.rawValue : " 가격낮은순 ",
        sortWay.dsc.rawValue : " 가격높은순 "
    ]
    
    lazy var sortWayList = sortDictionaty.sorted { $1.value < $0.value }
        
    var shopping = Shopping(total: 0, start: 0, display: 0, items:[])
    var list: [Item] = []
    
    var userFind: String = ""
    var sort = ""
    var start = 1
    
    let searchResultCollectionView: UICollectionView = {
       let view = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        view.register(SearchResultCodeCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCodeCollectionViewCell.identifier)
        return view
    }()
    let amountLabel = UILabel()
    let sortButton: [SortButton] = [
    SortButton(),
    SortButton(),
    SortButton()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("화면 이동")
        navigationItem.title = userFind
        configureHierarchy()
        configureConstraints()
        configureView()
        configureCollectionView()
        configureNavigation()
        searchResultCollectionView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        searchResultCollectionView.reloadData()
    }
    
}

extension SearchResultCodeViewController {
    func configureNavigation() {
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
    
    func configureHierarchy() {
        view.addSubview(searchResultCollectionView)
        view.addSubview(amountLabel)
        sortButton.forEach { button in
            view.addSubview(button)
        }
    }
    
    func configureConstraints() {
        searchResultCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        ShoppingSessionManager.shared.request(type: Shopping.self, text: userFind, sort: sortWay.sim.rawValue, start: String(start), completionHandler: { value, error in
            if error == nil {
                guard let value = value else { return }
                self.amountLabel.text = "\(value.total)개의 검색 결과"
                
                self.list = value.items
                self.sort = sortWay.sim.rawValue
                self.shopping = value
                self.searchResultCollectionView.reloadData()
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
        
        amountLabel.font = .systemFont(ofSize: 13)
        amountLabel.textColor = UIColor(named: Color.PointColor.rawValue)

        for count in 0 ... sortButton.count - 1 {
            sortButton[count].tag = count
            sortButton[count].setTitle("\(sortWayList[count].value)", for: .normal)
        }
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
        searchResultCollectionView.reloadItems(at: [IndexPath(row: sender.tag, section: 0)])
    }
}

extension SearchResultCodeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            
            if list.count - 3 == item.row && isEnd(start: start, count: 30, data: shopping ) == false {
                
                start += 30
                
                ShoppingSessionManager.shared.request(type: Shopping.self, text: userFind, sort: sort, start: String(start)) { value, error in
                    if error == nil {
                        guard let value = value else { return }
                        
                        if self.start == 1 {
                            self.list = value.items
                        } else {
                            self.list.append(contentsOf: value.items)
                        }
                        
                        self.searchResultCollectionView.reloadData()
                        
                        if self.start == 1 {
                            self.searchResultCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
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

// MARK: CollectionView Logic + Layout
extension SearchResultCodeViewController {
    // TODO: 화면 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "SearchDetail", bundle: nil)
        let vc = sb.instantiateViewController(identifier: SearchDetailViewController.identifier) as! SearchDetailViewController
        let data = list[indexPath.row]
        let url = "https://msearch.shopping.naver.com/product/\(data.productID)"
        
        vc.urlString = url
        vc.userFind = userFind
        vc.userLike = data.productID
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    static func setCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let cellWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.4)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    func configureCollectionView() {
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.prefetchDataSource = self
        
        searchResultCollectionView.register(SearchResultCodeCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCodeCollectionViewCell.identifier)
    }
}
