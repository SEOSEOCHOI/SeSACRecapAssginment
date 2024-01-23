//
//  searchDetailViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/20/24.
//

import UIKit
import Kingfisher
import Alamofire

class SearchResultViewController: UIViewController {
    
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
    
    let manager = ShoppingAPIManager()
    
    var shopping = Shopping(total: 0, start: 0, display: 0, items:[])
    var list: [Item] = []
    
    var userFind: String = ""
    var sort = ""
    var start = 1
    
    @IBOutlet var searchResultCollectionView: UICollectionView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var sortButton: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = userFind
        
        configureView()
        configureCollectionView()
        setCollectionViewLayout()
        configureNavigation()
        searchResultCollectionView.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        searchResultCollectionView.reloadData()
    }
    
    @IBAction func sortButtonClicked(_ sender: UIButton) {
        start = 1
        
        for button in sortButton {
            if button.tag == sender.tag {
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .black
            }
        }
        
        
        manager.callRequest(text: userFind, sort: sortWayList[sender.tag].key, start: String(start)) { value in
            self.sort = self.sortWayList[sender.tag].key
            self.list = value.items
            self.searchResultCollectionView.reloadData()
            self.shopping = value
        }
    }
}

extension SearchResultViewController {
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
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "mainSearchTabBarController") as! UITabBarController
        
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func configureView() {
        manager.callRequest(text: userFind, sort: sortWay.sim.rawValue, start: String(start)) { value in
            self.amountLabel.text = "\(value.total)개의 검색 결과"
            
            self.list = value.items
            self.sort = sortWay.sim.rawValue
            self.shopping = value
            self.searchResultCollectionView.reloadData()
        }
        
        amountLabel.font = .systemFont(ofSize: 13)
        amountLabel.textColor = UIColor(named: Color.PointColor.rawValue)
        
        for count in 0 ... sortButton.count - 1 {
            sortButton[count].tag = count
            sortButton[count].setTitle("\(sortWayList[count].value)", for: .normal)
            sortButton[count].tintColor = .white
            sortButton[count].layer.borderWidth = 1
            sortButton[count].layer.cornerRadius = sortButton[count].bounds.width * 0.3
            sortButton[count].layer.borderColor = UIColor.white.cgColor
            sortButton[count].titleLabel?.font = .boldSystemFont(ofSize: 15)
        }
    }
}


extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        
        // TODO: value name 정리 / conf igurecell / awake
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

// TODO: pagenation
extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            
            if list.count - 3 == item.row && isEnd(start: start, count: 30, data: shopping ) == false {
        
                start += 30
                
                manager.callRequest(text: userFind, sort: sort, start: String(start)) { value in
                    if self.start == 1 {
                        self.list = value.items
                        } else {
                        self.list.append(contentsOf: value.items)
                    }
                    
                    self.searchResultCollectionView.reloadData()
                    
                    if self.start == 1 {
                        self.searchResultCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
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
extension SearchResultViewController {
    // MARK: 화면 이동
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
    
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let cellWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.4)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        
        searchResultCollectionView.collectionViewLayout = layout
    }
    
    func configureCollectionView() {
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.prefetchDataSource = self
        
        let xib = UINib(nibName: SearchResultCollectionViewCell.identifier, bundle: nil)
        searchResultCollectionView.register(xib, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
}


