//
//  ViewController.swift
//  Weather3
//
//  Created by CHUNGEUNJI on 2018. 3. 28..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit
// 위치관련 연동하는 프레임워크. 얘랑 관련된 애들은 CL로 시작
import CoreLocation
import Alamofire
import SwiftyJSON

extension UIViewController {
    func show(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var listTableView: UITableView!
    
    var summary : WeatherSummary?
    var forecast = [Forecast]()
    
    lazy var df = DateFormatter()
    
    lazy var locationManager : CLLocationManager = {
       let m = CLLocationManager()
        // Delegate로 사용자 위치사용 허가 판단
        m.delegate = self
        return m
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Table이 높이조절을 못해서 써주는것
        listTableView.estimatedRowHeight = 100
        listTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationLabel.text = "Updating Location..."
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined :
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                updateCurrentLocation()
            case .denied, .restricted:
                show(message: "위치 서비스 사용불가")
            }
        } else {
            show(message: "위치 서비스 사용불가")
        }
    }
    
    var topInset : CGFloat = 0.0
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if topInset == 0.0 {
            let first = IndexPath(row: 0, section: 0)
            if let cell = listTableView.cellForRow(at: first) {
                // ???? 이 계산은 무엇...?
                topInset = listTableView.frame.height - cell.frame.height
                listTableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    func fetchSummary(coordinate: CLLocationCoordinate2D) {
        let urlStr = "https://api2.sktelecom.com/weather/current/minutely?version=1&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=\(appKey)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // fatalError()일 때랑 return 해줄때의 차이???
        // continue는 오직 루프에서만 사용가능
        guard let url = URL(string: urlStr) else { fatalError() }
        
        Alamofire.request(url, method: .get).responseJSON { [weak self] (response) in
            guard response.result.isSuccess else { fatalError() }
            guard let data = response.result.value  as? [String: Any] else { fatalError() }
            
            let json = JSON(data)
            guard let summary = WeatherSummary(json: json) else { fatalError() }
            self?.summary = summary
            
            // 왜 스레드로 하는지?
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
            }
        }
    }
    
    
    func fetchForecast(coordinate: CLLocationCoordinate2D) {
        let urlStr = "https://api2.sktelecom.com/weather/forecast/3days?version=1&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=\(appKey)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        guard let url = URL(string: urlStr) else { fatalError() }
        Alamofire.request(url, method: .get).responseJSON { [weak self] (response) in
            // 다음부터는 if문으로 하기!!!!!
            guard response.result.isSuccess else { fatalError() }
            
            guard let data = response.result.value as? [String: Any] else { fatalError() }
            let json = JSON(data)
            guard let fcast = json["weather"]["forecast3days"][0]["fcst3hour"].dictionary else { fatalError() }
            guard let sky = fcast["sky"]?.dictionary else { fatalError() }
            self?.forecast.removeAll()
            
            var hour = 4
            while hour < 64 {
                defer {
                    hour += 3
                }
                
                guard let name = sky["name\(hour)hour"]?.string else { continue }
                guard let code = sky["code\(hour)hour"]?.string else { continue           }
                guard let temp = fcast["temperature"]?["temp\(hour)hour"].string else { continue }
                let dbl = Double(temp) ?? 0.0
                let dt = Date()
                
                let newData = Forecast(date: dt, skyName: name, skyCode: code, temp: dbl)
                self?.forecast.append(newData)
            }
            
            // 다른 스레드로 정보를 업데이트해야해서?
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
            }
        }
    }
}



extension ViewController : UITableViewDataSource {
    // section과 row의 차이?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return forecast.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell") as! SummaryTableViewCell
            
            if let data = summary {
                print("성공=================")
                cell.weatherImageView.image = UIImage(named: data.skyCode)
                cell.statusLabel.text = data.skyName
                cell.minMaxLabel.text = "\(data.tempMin)º ~ \(data.tempMax)º"
                cell.tempLabel.text = "\(data.tempCurrent)º"
                
                cell.indicator.isHidden = true
            } else {
                print("실패=================")
                cell.indicator.isHidden = false
            }
            
            cell.weatherImageView.isHidden = !cell.indicator.isHidden
            cell.statusLabel.isHidden = !cell.indicator.isHidden
            cell.minMaxLabel.isHidden = !cell.indicator.isHidden
            cell.tempLabel.isHidden = !cell.indicator.isHidden
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell") as! ForecastTableViewCell
        
        let target = forecast[indexPath.row]
        df.dateFormat = "M.d.E"
        cell.dateLabel.text = df.string(for: target.date)
        df.dateFormat = "HH:mm"
        cell.timeLabel.text = df.string(for: target.date)
        cell.weatherImageView.image = UIImage(named: target.skyCode)
        cell.statusLabel.text = target.skyName
        cell.tempLabel.text = "\(target.temp)"
        
        return cell
    }
    
    
}



extension ViewController : CLLocationManagerDelegate {
    // 지역이 바뀔때마다 알려줌
    func updateCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // 위치 업데이트하기
    // 측정된 위치가 배열로 넘어온다
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 최신 위치정보를 바인딩
        // 1. location 첫번째를 받아온다
        if let loc = locations.first {
            // 2. decoder 선언
            let decoder = CLGeocoder()
            // 3. 지역정보를 변환할 메소드를 이용
            decoder.reverseGeocodeLocation(loc, completionHandler: { [weak self] (placemark, error) in
                // 4. 받아온 지역 마크 배열의 첫번째를 받아온다
                if let place = placemark?.first {
                    // 5. 구와 동 정보를 받아서 locationLabel에 삽입
                    if let gu = place.locality, let dong = place.subLocality {
                        self?.locationLabel.text = "\(gu) \(dong)"
                    } else {
                        self?.locationLabel.text = place.name
                    }
                }
            })
            
            fetchSummary(coordinate: loc.coordinate)
            fetchForecast(coordinate: loc.coordinate)
        }
        
        // 꼭 멈춰준다
        locationManager.stopUpdatingLocation()
    }
    
    
    // status가 바뀌면 auth 확인하려고...
    // 상태를 전달
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        // .authorizedWhenInUse : 사용자가 앱을 사용할때에만 GPS사용
            // 반드시 Info.plist로 Location 관리해줘야됨
        case .authorizedAlways, .authorizedWhenInUse:
            updateCurrentLocation()
            // 에러처리를 다 해주어야 함
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}




























