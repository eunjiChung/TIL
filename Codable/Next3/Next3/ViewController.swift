//
//  ViewController.swift
//  Next3
//
//  Created by CHUNGEUNJI on 2018. 3. 29..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    // Codable? 무슨 타입?
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


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let urlStr = "https://fastcampus.azurewebsites.net/api/books"
        guard let url = URL(string: urlStr) else { return }
        
        Alamofire.request(url).responseData { [weak self] (response) in
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

}




















