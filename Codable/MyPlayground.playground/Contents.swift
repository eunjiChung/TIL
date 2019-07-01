//: Playground - noun: a place where people can play
// Postman이 뭐지?
// API 요청하는 가장 단순한 방법

import UIKit
import PlaygroundSupport


// list에 json 배열이 있지만, 이렇게만 하면 자동으로 다 파싱함
// But, 만약 Optional타입인 애가 들어온다면? -> 구조체 인스턴스 타입을 Optional로 바꿔준다
struct BookList: Codable {
    let code: Int
    let list: [Book]
}

// serializable을 위해 Codable 채택
struct Book: Codable {
    let id: Int
    let title: String
    let desc: String?
    let pubYear: Int
    
    // 인스턴스 네이밍을 뜻대로 하고싶을때, 열거형을 만들고 알아서 매칭되도록 한다
    // 다른건 이름이 동일하지만 빼먹지 않고 써줘야한다****
    // Azure로 postman에 게시. postman에서 playground로 파싱
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case desc
        case pubYear = "pub_year"
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true

let urlStr = "https://fastcampus.azurewebsites.net/api/books"

// String을 url로 만드는 중...
if let url = URL(string: urlStr) {
    // 세션은 프로그램과 서버 사이의 데이터통신을 전담해주는 애
    let session = URLSession(configuration: .default)
    
    // completionHandler
    let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
        if let error = error {
            print(error)
        } else {
            // 정상적인 응답을 받았다면 "Hello:)"라는 바이너리 데이터가 담겨있을 것
            // Binary? Int? String?
            
            // But 실제로 내려오는 데이터는 모두 json -> 얘네도 다 binary
            // binary -> json -> class, 구조체로 변환(serialization, deserialization)
            // json은 string으로 바꾸면 추출하기 어려움. 때문에 구조체로 변환
            if let responseData = data {
                // 데이터를 늘 Binary에서 문자열로 인코딩해주고, 그 뒤에 다른 형 변환
//                let str = String(data: responseData, encoding: .utf8)
//                let num = Int(str!)
//                print(str)
//                print(num)
                
                
                
                // JSON 파싱하는 가장 기본적인 방법
                let decoder = JSONDecoder()
                
                do {
                    // decode(from: ) -> Decoder를 통해서 직렬화할 구조체 이름.self(구조체 타입), json이 담긴 데이터 전달
                    // 파싱완료된다면 result에 Book 인스턴스 저장
                    let result = try decoder.decode(BookList.self, from: responseData)
                    dump(result) // 실제로 구조체로 나오는지 확인. dump?????
                } catch {
                    print("error")
                }
            }
        }
        
        // 얘를 호출해주면 Playground를 조절해서 마지막에 string이 출력된다
        PlaygroundPage.current.finishExecution()
    })
    
    task.resume() // 실제로 요청됨 -> 얘를 프로젝트에서 실행하면 결과가 나옴 -> 하지만 지금은 Playground라서 먼저 끝나버림
}


