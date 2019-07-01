//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

struct BookList: Codable {
    let code: Int
    let list: [Book]
}

struct Book: Codable {
    let id: Int
    let title: String
    let desc: String
    let pub_year: Int
}


PlaygroundPage.current.needsIndefiniteExecution = true


let urlStr = "https://fastcampus.azurewebsites.net/api/books"

if let url = URL(string: urlStr) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
        if let error = error {
            print(error)
        } else {
            if let responseData = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(BookList.self, from: responseData)
                    dump(result)
                } catch {
                    print("error")
                }
            }
        }
        
        PlaygroundPage.current.finishExecution()
    })
    task.resume()
}



























