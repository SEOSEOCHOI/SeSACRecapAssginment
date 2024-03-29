//
//  ShoppingAPIManager.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/20/24.
//

import Foundation
import Alamofire

struct ShoppingAPIManager {
    
//    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
//    
//    var outputLabelData = Observable("")
//    var outputMarketData: Observable<[Shopping]> = Observable([])
//    
//    init() {
//        print("ViewModel init")
//        inputViewDidLoadTrigger.bind { _ in
//            self.callRequest(text: <#T##String#>, sort: <#T##String#>, start: <#T##String#>, completionHandler: <#T##(Shopping) -> Void#>)
//        }
//    }
//    
    func callRequest(text: String, sort: String, start: String, completionHandler: @escaping (Shopping) -> Void) {
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query!)&sort=\(sort)&display=30&start=\(start)"

        let headers: HTTPHeaders = [
            "X-Naver-Client-Id":APIKey.clientID,
            "X-Naver-Client-Secret":APIKey.clientSecret
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let success):
                
                print("success")
                completionHandler(success.self)
            case .failure(let failure):
                print(failure)
            }
        }
  
    }
}
