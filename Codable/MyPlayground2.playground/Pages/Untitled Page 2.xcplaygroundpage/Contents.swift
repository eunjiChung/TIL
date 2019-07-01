//: [Previous](@previous)

import Foundation
import PlaygroundSupport


PlaygroundPage.current.needsIndefiniteExecution = true

let urlStr = "https://fastcampus.azurewebsites.net/api/string"

if let url = URL(string: urlStr) {
    let session = URLSession(configuration: .default)
    
    let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
        if let error = error {
            print(error)
        } else {
            if let responseData = data {
                let str = String(data: responseData, encoding: .utf8)
                print(str)
            }
        }
        
        // ????
        PlaygroundPage.current.finishExecution()
    })
    
    task.resume()
}























