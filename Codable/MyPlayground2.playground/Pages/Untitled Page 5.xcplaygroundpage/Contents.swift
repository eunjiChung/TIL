//: [Previous](@previous)

import Foundation
import PlaygroundSupport

// Serialize를 위해 Codable Type
// JSON을 받을 객체 생성
struct Book: Codable {
    let id: Int
    let title: String
    let desc: String
    let pubYear: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case desc
        case pubYear = "pub_year"
    }
}


PlaygroundPage.current.needsIndefiniteExecution = true

let urlStr = "https://fastcampus.azurewebsites.net/api/book/1"

if let url = URL(string: urlStr) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
        if let error = error {
            print(error)
        } else {
            if let responseData = data {
                // JSON Parsing
                let decoder = JSONDecoder()
                
                do {
                    // decoder로 전달되는 Data 객체를 result에 저장
                    // 첫번째 객체 타입, from 어떤 data인지
                    let result = try decoder.decode(Book.self, from: responseData)
                    print("???")
                    dump(result) //????
                } catch {
                    print("error")
                }
            }
        }
        
        PlaygroundPage.current.finishExecution()
    })
    
    task.resume()
}









