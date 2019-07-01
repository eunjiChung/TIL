//
//  ViewController.swift
//  Weather4
//
//  Created by CHUNGEUNJI on 2018. 3. 29..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit
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
    var forecastList = [Forecast]()
    
    lazy var df = DateFormatter()
    
    lazy var locationManager : CLLocationManager = {
        let m = CLLocationManager()
        m.delegate = self
        return m
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        listTableView.estimatedRowHeight = 100
        listTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                updateCurrentLocation()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                show(message: "위치서비스 사용불가!!!!1")
            }
        } else {
            show(message: "위치서비스 사용불가!!")
        }
    }
    
    
    var topInset : CGFloat = 0.0
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // **** 완벽이해 *****
        if topInset == 0.0 {
            let first = IndexPath(row: 0, section: 0)
            if let cell = listTableView.cellForRow(at: first) {
                topInset = listTableView.frame.height - cell.frame.height
                listTableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    func fetchSummary(coordinate : CLLocationCoordinate2D) {
        let urlStr = "https://api2.sktelecom.com/weather/current/minutely?version=1&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=\(appKey)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        if let url = URL(string: urlStr) {
            Alamofire.request(url, method: .get).responseJSON(completionHandler: { [weak self] (response) in
                if response.result.isSuccess {
                    if let data = response.result.value as? [String: Any] {
                        let json = JSON(data)
                        guard let summary = WeatherSummary(json: json) else { fatalError() }
                        self?.summary = summary
                        
                        // ******** 메인스레드에서 테이블 리로드
                        DispatchQueue.main.async {
                            self?.listTableView.reloadData()
                        }
                    } else {
                        print("data 응답없음")
                    }
                } else {
                    print("responseJSON 응답없음")
                }
            })
        }
    }

    func fetchForecast(coordinate: CLLocationCoordinate2D) {
        let urlStr = "https://api2.sktelecom.com/weather/forecast/3days?version=1&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=\(appKey)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        guard let url = URL(string: urlStr) else { fatalError() }
        forecastList.removeAll()
        
        Alamofire.request(url, method: .get).responseJSON { [weak self] (response) in
            if response.result.isSuccess {
                if let data = response.result.value as? [String: Any] {
                    let json = JSON(data)
                    print(json)
                    
                    guard let fcast = json["weather"]["forecast3days"][0]["fcst3hour"].dictionary else { fatalError() }
                    guard let sky = fcast["sky"]?.dictionary else { fatalError() }
                    
                    var hour = 4
                    while hour < 67 {
                        defer { hour += 3 }
                        
                        guard let name = sky["name\(hour)hour"]?.string else { continue }
                        guard let code = sky["code\(hour)hour"]?.string else { continue }
                        guard let temp = fcast["temperature"]!["temp\(hour)hour"].string else { continue }
                        let dbl = Double(temp) ?? 0.0
                        let date = Date().addingTimeInterval(3600 * 3)
                        
                        let newData = Forecast(date: date, skyName: name, skyCode: code, temp: dbl)
                        self?.forecastList.append(newData)
                    }
                } else {
                    print("data 받기 실패")
                }
            } else {
                print("response is Not SUCCESS")
            }
            
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
            }
        }
        
        
        
    }
}

extension ViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return forecastList.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell") as! SummaryTableViewCell
            
            if let data = summary {
                cell.weatherImageView.image = UIImage(named: data.skyCode)
                cell.statusLabel.text = data.skyName
                cell.minMaxLabel.text = "최소\(data.tempMin)º / 최대\(data.tempMax)º"
                cell.tempLabel.text = "\(data.tempCurrent)º"
                
                cell.indicator.isHidden = true
            } else {
                cell.indicator.isHidden = false
            }
            
            cell.weatherImageView.isHidden = !cell.indicator.isHidden
            cell.statusLabel.isHidden = !cell.indicator.isHidden
            cell.minMaxLabel.isHidden = !cell.indicator.isHidden
            cell.tempLabel.isHidden = !cell.indicator.isHidden
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell") as! ForecastTableViewCell
            
            let target = forecastList[indexPath.row]
            df.dateFormat = "M.d.E"
            cell.dateLabel.text = df.string(for: target.date)
            df.dateFormat = "HH:00"
            cell.timeLabel.text = df.string(for: target.date)
            cell.weatherImageView.image = UIImage(named: target.skyCode)
            cell.statusLabel.text = target.skyName
            cell.tempLabel.text = "\(target.temp)º"
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dummy")!
        return cell
    }
    
    
}



extension ViewController : CLLocationManagerDelegate {
    func updateCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            let decoder = CLGeocoder()
            decoder.reverseGeocodeLocation(loc, completionHandler: { [weak self] (placemark, error) in
                if let error = error {
                    print(error)
                } else {
                    if let place = placemark?.first {
                        if let gu = place.locality, let dong = place.subLocality {
                            self?.locationLabel.text = "\(gu) \(dong)"
                        } else {
                            self?.locationLabel.text = place.name
                        }
                    }
                }
            })
            
            fetchSummary(coordinate: loc.coordinate)
            fetchForecast(coordinate: loc.coordinate)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    // 상태 변화에 따라 auth 체크
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            updateCurrentLocation()
        default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 에러처리를 어떻게....?
    }
}


























