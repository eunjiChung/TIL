//
//  ViewController.swift
//  Next
//
//  Created by CHUNGEUNJI on 2018. 2. 26..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit
import Alamofire

struct BookList: Codable {
    let code: Int
    let list: [Book]
}

struct Book: Codable {
    let id: Int
    let title: String
    let desc: String?
    let pubYear: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case desc
        case pubYear = "pub_year"
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlStr = "https://fastcampus.azurewebsites.net/api/books"
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        // Alamofire 프레임워크 이용한 세션요청
        Alamofire.request(url).responseData { (response) in
            if response.result.isSuccess {
                if let data = response.value {
                    let decoder = JSONDecoder()
                    
                    do {
                        let result = try decoder.decode(BookList.self, from: data)
                        dump(result)
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




































