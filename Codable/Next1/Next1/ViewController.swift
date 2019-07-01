
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
    
    
    // ********** //
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
        
        // 원래 session -> task -> completionHandler로 했는데,
        // 여기서는 Alamofire.request.responseData로 전부 처리
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

}

