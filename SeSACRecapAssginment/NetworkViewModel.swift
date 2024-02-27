//
//  NetworkViewModel.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 2/27/24.
//

import Foundation
import Alamofire

class NerworkViewModel {
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputText
    var inputSort
    var inputStart
    var outputData: Observable<[Item]> = Observable([])
 
    init() {

        inputViewDidLoadTrigger.bind { _ in
            self.callRequest(text: <#String#>, sort: <#String#>, start: <#String#>, completionHandler: <#(Shopping) -> Void#>)
        }
    }
    
    private func callRequest(text: String, sort: String, start: String, completionHandler: @escaping (Shopping) -> Void) {
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
