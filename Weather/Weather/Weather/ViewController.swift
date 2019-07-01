// 앞으로 화면별로 Class를 그룹핑
//
// 숙제(회사가서 두 가지 방식을 모두 쓰게 될 것)
// 1. SwiftyJSON을 이용
// 2. JSONDecoder를 이용
//

import UIKit
import CoreLocation
import Alamofire
// 받은 JSON을 SwiftyJSON을 이용해 가공한다 -> Parsing이 더 단순해짐
import SwiftyJSON


struct Summary {
    let skyCode: String
    let skyName: String
    let minTemp: Double
    let maxTemp: Double
    let currentTemp: Double
    
    // failable initializer
    // 받은 날씨정보를 json으로 바꾼다음에 이 생성자로 리턴해줄 것
    init?(json: JSON) {
        // 1. weather 키를 뽑아낸다
        // json도 dict의 일종. 만약 SwiftyJSON의 도움을 안받으면 타입캐스팅을 매번 해야하지만, 이제 도움을 받아서 더 편하게...(json.dictionary)
        guard let weatherDict = json["weather"].dictionary else {
            fatalError("parsing error")
        }
        
        // 2. 또 minutely 뽑기
        // (), []는 모두 배열 -> 따라서 minutely도 배열
        // {}는 dictionary
        // 뒤에 array로 타입캐스팅해주는 것도 SwiftyJSON으로... + Optional Chaining
        
        guard let minutely = weatherDict["minutely"]?.array?.first else {
            fatalError("parsing error")
        }
        
        guard let sky = minutely["sky"].dictionary else {
            fatalError("parsing error")
        }
        
        // 타입변환 : "\()" 얘랑 as? 랑의 차이는...?
//        guard let code = sky["code"]?.string  else {
//            fatalError("parsing error")
//        }
        
        
        // *******************************
        // swifty json 쓰면 연쇄적으로 []을 쓸 수 있다
        // 위의 코드를 이렇게 단순화 시킬 수 있음!!!!!!
        // minutely가 배열이니까, 0번째 요소를 뽑아주는 것도 포함
        guard let code = json["weather"]["minutely"][0]["sky"]["code"].string  else {
            fatalError("parsing error")
        }
        skyCode = code
        
        
//        // Swifty JSON으로 바꾸기
//        guard let name = sky["name"]?.string else {
//            fatalError("parsing error")
//        }
        guard let name = json["weather"]["minutely"][0]["sky"]["name"].string else {
                    fatalError("parsing error")
                }
        skyName = name
        
        guard let tcStr = json["weather"]["minutely"][0]["temperature"]["tc"].string, let tc = Double(tcStr) else {
            fatalError("parsing error")
        }
        currentTemp = tc
        
        guard let tmaxStr = json["weather"]["minutely"][0]["temperature"]["tmax"].string, let tmax = Double(tmaxStr) else {
            fatalError("parsing error")
        }
        maxTemp = tmax
        
        guard let tminStr = json["weather"]["minutely"][0]["temperature"]["tmin"].string, let tmin = Double(tminStr) else {
            fatalError("parsing error")
        }
        minTemp = tmin
    }
}

struct Forecast {
    let skyCode: String
    let skyName: String
    let temp: Double
    let date: Date
    
    // 생성자를 적용하지 않음
}


class ViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    // 위에 만든 객체
    var summary: Summary?
    var forecastList = [Forecast]()
    
    let formatter = DateFormatter()
    
    // 지연 저장 속성(lazy) => manager가 호출될 때 해당 인스턴스가 생성됨
    // 아까 Location 코드랑 비슷하지만, manager와 초기화가 붙어있는 코드이기 때문
    // 앞으로는 가능하다면 이 클로저 패턴을 쓰기
    // 현재는 빈 껍데기
    lazy var manager: CLLocationManager = {
        let m = CLLocationManager()
        // GPS의 정확도를 설정
        // 우리는 날씨앱이기 때문에, GPS의 정확도가 그렇게 높지않아도 된다 -> 정확도가 높을수록 바떼리를 많이 잡아먹는다
        m.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        // Delegate 연결
        m.delegate = self
        return m
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableview가 객체들에 맞춰서 높이 조절을 잘 못해서
        // 다시 코드에서 높이를 맞춰줘야 한다
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = 100
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            updateLocation()
        default:
            print("eoor miss")
        }
    }
    
    
    
    // 얘를 가지고 tableview의 위쪽 여백을 지정
    // tableview 높이 - topMargin
    var topMargin: CGFloat = 0.0
    
    // 얘는 순서를 무시하고, 계산한 동적 높이를 얻을 수 있다 ** 이게 중요
    // 다만, 반복적으로 호출되므로 한번만 계산하도록 flag 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if topMargin < 1.0 {
            // tableview의 첫번째 셀
            let first = IndexPath(row: 0, section: 0)
            if let cell = listTableView.cellForRow(at: first) {
                topMargin = cell.frame.height
//                print(topMargin)
                
                // 테이블 뷰 위의 여백 지정
                listTableView.contentInset = UIEdgeInsets(top: listTableView.frame.height - topMargin, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    
    func fetchForecast(with coordinate: CLLocationCoordinate2D) {
        let urlStr = "https://api2.sktelecom.com/weather/forecast/3days?version=1&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=cd0c9c72-6e32-4181-9291-9340adb8d0dc"
        
        guard let url = URL(string: urlStr) else {
            fatalError("invalid url")
        }
        
        
        
        self.forecastList.removeAll()
        
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                if let dict = response.result.value as? [String: Any] {
                    let json = JSON(dict)
                    
                    // 어차피 하나 있으니 array 대신 first
                    // 코드 접기 : option + cmd + left key
                    // 얘네를 다시 JSON encoder로도 바꿔보기
                    if let forcastDict = json["weather"]["forecast3days"][0]["fcst3hour"].dictionary {
                        var hour = 4
                        var date = Date()
                        
                        
                        while hour < 67 {
                            // defer문 : 연기하다. 코드의 실행을 연기한다.
                            // 이 코드는 이 위치에서 실행되는게 아니라 '예약'된다.
                            // 실행은 while문이 매 회차 실행될때마다 마지막에 작동됨
                            defer {
                                hour += 3
                            }
                            
                            guard let skyCode = forcastDict["sky"]?["code\(hour)hour"].string else {
                                // ""이 있어서 continue가 실행되기도 했다
                                continue
                            }
                            
                            guard let skyName = forcastDict["sky"]?["name\(hour)hour"].string else {
                                continue
                            }
                            
                            // 현재시간 + 3시간
                            // addingTimeInterval은 초 기준
                            // 얘를 좀 더 개선시킬 수 있다
                            date = date.addingTimeInterval(3600 * 3)
                            
                            guard let tempStr = forcastDict["temperature"]?["temp\(hour)hour"].string else {
                                continue
                            }
                            
                            // 이렇게 하면 무한루프는 발생하지 않는다
                            let temp = Double(tempStr) ?? 0.0
                            
                            let data = Forecast(skyCode: skyCode, skyName: skyName, temp: temp, date: date)
                            self.forecastList.append(data)
                            
                        }
                    }
                    
                }
            } else {
                fatalError("Fail")
            }
            
            self.listTableView.reloadData()
        }
    }
    
    
    // SummaryCell 자료를 뽑아내는 것
    func fetchSummary(with coordinate: CLLocationCoordinate2D) {
        // 1. urlStr에 현재 앱의 경도와 위도를 넣어준다(String interpolation을 통해)
        let urlStr = "https://api2.sktelecom.com/weather/current/minutely?version=1&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=cd0c9c72-6e32-4181-9291-9340adb8d0dc"
        
        guard let url = URL(string: urlStr) else {
            fatalError("invalid url")
        }
        
        // 3. Alamofire를 이용해서 JSON 가져올 것
        // 기본적으로 GET (????)
        // 타입이 Any이지만, Dictionary로 전달됨
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                // response.result.value가 Any형이니까 Dict로 바인딩
                if let dict = response.result.value as? [String: Any] {
//                    print(dict)
                    // 받은 정보를 Summary 객체 생성자가 가공하도록 넘겨줌
                    let json = JSON(dict)
                    if let summary = Summary(json: json) {
                        
                        // Tableview는 summary로 부터 data를 가져옴
                        self.summary = summary
                        print("====1")
                        self.listTableView.reloadData()
                        
                        // dump는 print보다 자세히 출력한다
                        dump(summary)
                    } else {
                        fatalError("fail")
                    }
                }
            } else {
                fatalError("Fail")
            }
        }
    }
}




extension ViewController : UITableViewDataSource {
    
    // TableView를 두 개 section으로 나눔
    // 1. Summary Cell
    // 2. Forecast Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1 // 여백을 위해 dummy cell 리턴
        }
        
        return forecastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell") as! SummaryTableViewCell
            
            // API에서 얻어온 날씨 정보를 셀에 바인딩
            // Postman의 JSON 구조에서 필요한 요소만 쏙쏙 뽑아낸다
            // 날씨정보(summary data)는 위에서 가공해줌
            // 그리고 셀에 넣는다
            if let data = summary {
                cell.weatherImageView.image = UIImage(named: data.skyCode)
                cell.skyNameLabel.text = data.skyName
                cell.minMaxLabel.text = "최소 \(data.minTemp)℃ 최대 \(data.maxTemp)℃"
                cell.tempLabel.text = "\(data.currentTemp)℃"
            }
            
            return cell
        } else if indexPath.section == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "dummy")!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell") as! ForecastTableViewCell
        
        let target = forecastList[indexPath.row]
        cell.skyImageView.image = UIImage(named: target.skyCode)
        cell.skyNameLabel.text = target.skyName
        cell.tempLabel.text = "\(target.temp)℃"
        
        formatter.dateFormat = "M.d (E)"
        cell.dateLabel.text = formatter.string(for: target.date)
        // 똑같은데? 재사용?
        formatter.dateFormat = "HH:00"
        cell.timeLabel.text = formatter.string(for: target.date)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 우리는 section을 두개 쓸거니까 return 2
        return 3
    }
    
}




extension ViewController: CLLocationManagerDelegate {
    func updateLocation() {
        // GPS에서 새로운 위치를 업데이트
        manager.startUpdatingLocation()
    }
    
    // 얘가 현재 위치를 새로 업데이트할 때 호출되는 애(?)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // current = 현재 지역 하나 바인딩
        if let current = locations.last {
            
            // 업데이트로 현재 위치가 리턴될때, 날씨 정보를 가져온다 *****
            self.fetchSummary(with: current.coordinate)
            self.fetchForecast(with: current.coordinate)
            
            // 위도와 경도를 지역 코딩해주어야 -시/-동이 나타난다
            // **지역코딩하는 법
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(current, completionHandler: { (list, error) in
                if let error = error {
                    print(error)
                } else {
                    // 동일 좌표에 주소가 여러개가 올 수 있기 때문에 list(배열) parameter가 오는 것
                    // 그래서 그 중에 하나만 가져온다(자료형: CLPlaceMark)
                    if let first = list?.first {
                        // 원하는 주소로 가공하는 과정
                        // locality : 구, sublocality : 동
                        // 미국 주소를 따르기 때문에 우리나라 주소로 바인딩 해줘야 함
                        if let gu = first.locality, let dong = first.subLocality {
//                            print(gu, dong)
                            
                            // 기존에 영어로 나오지만, 그건 핸드폰 언어 설정이 영어라서...
                            // 한글로 바꾸려면 Edit Scheme에서 언어와 지역을 설정해준다!!!!
                            self.titleLabel.text = "\(gu) \(dong)"
                        } else {
//                            print(first.name)
                            // nil corelacing(?) operator
                            self.titleLabel.text = first.name ?? "알 수 없음"
                        }
                    }
                }
            })
        }
        
        // 바데리를 아끼기 위해 업데이트를 멈춰줌
        manager.stopUpdatingLocation()
    }
    
    // 요청 변경사항에 따라서 얘가 호출
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            updateLocation()
        default:
            print("error")
        }
    }
}



































