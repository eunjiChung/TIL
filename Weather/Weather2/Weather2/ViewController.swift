//
//  ViewController.swift
//  Weather2
//
//  Created by CHUNGEUNJI on 2018. 3. 27..
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
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    lazy var locationManager : CLLocationManager = {
       let m = CLLocationManager()
        m.delegate = self
        return m
    }()
    
    lazy var df = DateFormatter()

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
            case .notDetermined:
                // 리퀘스트를 날린다
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                updateCurrentLocation()
            case .denied, .restricted:
                show(message: "위치서비스 사용불가")
            }
        } else {
            show(message: "위치서비스 이용불가")
        }
    }
    
    var summary : WeatherSummary?
    var forecast = [Forecast]()
    
    func fetchSummary(coordinate : CLLocationCoordinate2D) {
        let urlStr = "https://api2.sktelecom.com/weather/current/minutely?version=1&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=\(appKey)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        guard let url = URL(string: urlStr) else { fatalError() }
        
        Alamofire.request(url, method: .get).responseJSON { [weak self] (response) in
            
            guard response.result.isSuccess else { fatalError() }
            // value라는걸 어떻게 알지?
            guard let data = response.result.value as? [String: Any] else { fatalError() }
            
            let json = JSON(data)
            guard let summary = WeatherSummary(json: json) else { fatalError() }
            self?.summary = summary
            
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
            }
        }
    }
    
    
    func fetchForecast(coordinate: CLLocationCoordinate2D) {
        let urlStr = "https://api2.sktelecom.com/weather/forecast/3days?version=1&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=\(appKey)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        guard let url = URL(string: urlStr) else { fatalError() }
        
        Alamofire.request(url, method: .get).responseJSON { [weak self] (response) in
            guard response.result.isSuccess else { fatalError() }
            guard let data = response.result.value as? [String: Any] else { fatalError() }
            
            let json = JSON(data)
            guard let fcast = json["weather"]["forecast3days"][0]["fcst3hour"].dictionary else { fatalError() }
            self?.forecast.removeAll()
            
            var hour = 4
            
            while hour < 64 {
                defer {
                    hour += 3
                }
                
                guard let sky = fcast["sky"]?.dictionary else { continue }
                // 왜 FatalError()로 하면 에러나지...? 
                guard let skyName = sky["name\(hour)hour"]?.string, skyName.count > 0 else { continue }
                guard let skyCode = sky["code\(hour)hour"]?.string, skyCode.count > 0 else { continue }
                guard let temp = fcast["temperature"]?["temp\(hour)hour"].string else { continue }
                let dbl = Double(temp) ?? 0.0
                
                let comp = Calendar.current.dateComponents([.month, .day, .hour], from: Date())
                guard let now = Calendar.current.date(from: comp) else { return }
                let dt = now.addingTimeInterval(TimeInterval(hour * 3600))
                
                let newData = Forecast(date: dt, skyName: skyName, skyCode: skyCode, temperature: dbl)
                self?.forecast.append(newData)
            }
            
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
            }
        }
    }
    
    
    
    
    
    var topInset: CGFloat = 0.0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if topInset == 0.0 {
            // ??? 무엇의?
            let first = IndexPath(row: 0, section: 0)
            if let cell = listTableView.cellForRow(at: first) {
                // ???? 어떻게 계산한거?
                topInset = listTableView.frame.height - cell.frame.height
                // 스크롤할때 view?
                listTableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            }
        }
    }
}


extension ViewController : UITableViewDataSource {
    
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
        
        // table의 section과 row?
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell") as! SummaryTableViewCell
            
            
            if let data = summary {
                cell.weatherImageView.image = UIImage(named: data.skyCode)
                cell.statusLabel.text = data.skyName
                cell.minMaxLabel.text = "최소\(data.tempMin)º ~ 최대\(data.tempMax)º"
                cell.currentTempLabel.text = "\(data.tempCurrent)º"
                
                cell.indicator.isHidden = true
            } else {
                cell.indicator.isHidden = false
            }
            
            cell.weatherImageView.isHidden = !cell.indicator.isHidden
            cell.statusLabel.isHidden = !cell.indicator.isHidden
            cell.minMaxLabel.isHidden = !cell.indicator.isHidden
            cell.currentTempLabel.isHidden = !cell.indicator.isHidden
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell") as! ForecastTableViewCell
        
        let target = forecast[indexPath.row]
        df.dateFormat = "M.d(E)"
        cell.dateLabel.text = df.string(for: target.date)
        df.dateFormat = "HH:mm"
        cell.timeLabel.text = df.string(for: target.date)
        
        cell.weatherImageView.image = UIImage(named: target.skyCode)
        cell.statusLabel.text = target.skyName
        cell.tempLabel.text = "\(target.temperature)"
        
        return cell
        
    }
    
    
}






extension ViewController : CLLocationManagerDelegate {
    func updateCurrentLocation() {
        // 업데이트 시작
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            let decoder = CLGeocoder()
            decoder.reverseGeocodeLocation(loc, completionHandler: { [weak self] (placemark, error) in
                if let place = placemark?.first {
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
        
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            updateCurrentLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

























