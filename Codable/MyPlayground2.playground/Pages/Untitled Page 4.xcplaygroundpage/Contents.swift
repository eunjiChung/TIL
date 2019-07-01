//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let urlStr = "https://fastcampus.azurewebsites.net/api/number"

if let url = URL(string: urlStr) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
        if let error = error {
            print(error)
        } else {
            if let responseData = data {
                // 데이터 가공은 최종적으로 받아서 하기
                let str = String(data: responseData, encoding: .utf8)
                let num = Int(str!)
                print(num)
            }
        }
        
        PlaygroundPage.current.finishExecution()
    })
    
    task.resume()
}




