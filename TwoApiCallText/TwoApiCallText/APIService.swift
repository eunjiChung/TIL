//
//  APIService.swift
//  TwoApiCallText
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation

class APIService {
    
    func GETRequest(path: String,
                    query: String,
                    success: @escaping (Any) -> (),
                    failure: @escaping (Error) -> ())
    {
        
        
        guard let url = UrlForRequest(path, query) else { return }
        
        let dataTask = URLSession(configuration: .default).dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            {
                success(data)
            } else if let error = error {
                failure(error)
            }
        })
        
        dataTask.resume()
    }
    
    fileprivate func UrlForRequest(_ path: String,
                                   _ keyword: String) -> URLRequest? {
        var urlComponents = URLComponents(string: path)!
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: keyword),
            URLQueryItem(name: "size", value: "\(5)")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        let header = ["Authorization": "KakaoAK 3ca11558f438d6e3d4b0c00c6ab93450"]
        
        for (key, value) in header {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
