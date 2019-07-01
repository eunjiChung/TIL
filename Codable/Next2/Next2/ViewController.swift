
import UIKit
import Alamofire

class ViewController: UIViewController {
    
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
        
        let urlStr = "https://fastcampus.azurewebsites.net/api/books"
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        // completionHandler == responseData
        Alamofire.request(url).responseData { (response) in
            if response.result.isSuccess {
                // response.value = Data Type을 넘겨준다
                // decoder로 Data Type을 BookList Type으로
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











