//
//  SearchDetailViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/21/24.
//

import UIKit
import WebKit

class SearchDetailViewController: UIViewController {
    
    var urlString: String = "url"
    var userFind: String = ""
    var userLike: String = ""
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWeb()
        configureNavigation()
    }
}
extension SearchDetailViewController {
    func configureWeb() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            webView.load(request)
        }
    }
}

extension SearchDetailViewController {
    func configureNavigation() {
        navigationItem.title = userFind
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: UserDefaultManager.shaerd.userLike.contains(userLike) ? "heart.fill" : "heart"),
            style: .plain,
            target: self,
            action: #selector(rightButtonClicked))
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.title = ""

    }
    
    @objc func rightButtonClicked(_ sender: UIButton) {
        var like = UserDefaultManager.shaerd.userLike
        print(#function)
        if !UserDefaultManager.shaerd.userLike.contains(userLike) {
            like.append(userLike)
            UserDefaultManager.shaerd.userLike = like
        } else {
            if let index = UserDefaultManager.shaerd.userLike.firstIndex(of: userLike) {
                like.remove(at: index)
                UserDefaultManager.shaerd.userLike = like
            }
        }
        isClicked()
    }
    
    func isClicked() {
        let image = UserDefaultManager.shaerd.userLike.contains(userLike) ? "heart.fill" : "heart"
        
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: image)
    }
}
