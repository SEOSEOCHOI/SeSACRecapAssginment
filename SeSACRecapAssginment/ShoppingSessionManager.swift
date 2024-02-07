//
//  ShoppingSessionManager.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 2/6/24.
//

import Foundation

enum SeSACError: Error {
    case failedRequset
    case noData
    case invaildResponse
    case invaildData
}

class ShoppingSessionManager {
    static let shared = ShoppingSessionManager()
    typealias CompletionHandler<T: Decodable> = ((T)?, SeSACError?) -> Void
    
    func request<T: Decodable>(type: T.Type, text: String, sort: String, start: String, completionHandler: @escaping CompletionHandler<T>) {
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        /* 1번째 방법
         let url = URL(string: "https://openapi.naver.com/v1/search/shop.json?query=\(query!)&sort=\(sort)&display=30&start=\(start)")
         
         guard let url = url else { return }
         
         var urlRequest = URLRequest(url: url)
         urlRequest.httpMethod = "GET"
         urlRequest.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
         urlRequest.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
         
         */
        

        let scheme = "https"
        let host = "openapi.naver.com"
        let path = "/v1/search/shop.json"
        
        var component = URLComponents()
        
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
        URLQueryItem(name: "query", value: query),
        URLQueryItem(name: "sort", value: sort),
        URLQueryItem(name: "display", value: "30"),
        URLQueryItem(name: "start", value: start)
        ]
        
        guard let url = component.url else { return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        urlRequest.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("네트워크 통신 실패")
                    completionHandler(nil, .failedRequset)
                    return
                }
                
                guard let data = data else {
                    print("통신 성공, 데이터 미전송")
                    completionHandler(nil, .noData)
                return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("통신 성공, 응답값 X")
                    completionHandler(nil, .invaildResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("통신은 성공했지만, 올바른 값이 오지 않은 상태.")
                    completionHandler(nil, .invaildResponse)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(result, nil)
                    dump(result)
                } catch {
                    print(error)
                    completionHandler(nil, .invaildData)
                }
            }
        }.resume()
    }
}
