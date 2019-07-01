//
//  ViewController.swift
//  Weather1
//
//  Created by CHUNGEUNJI on 2018. 3. 26..
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
    
    // Location관리자
    lazy var locationManagaer : CLLocationManager = {
       let m = CLLocationManager()
        m.delegate = self
        return m
    }()
    
    lazy var df = DateFormatter()
    
    var summary : WeatherSummary?
    var forecast = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        listTableView.backgroundColor = UIColor.clear
        // ???
        listTableView.separatorStyle = .none
        listTableView.estimatedRowHeight = 100 //??
        listTableView.rowHeight = UITableViewAutomaticDimension //??
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationLabel.text = "업데이트 중..."
        
        // 위치 서비스가 가능한지 여부 조사
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined :
                locationManagaer.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse :
                updateCurrentLocation()
            case .denied, .restricted :
                show(message: "위치 서비스 사용불가!!!!!!!")
            }
        } else {
            show(message: "위치 서비스 사용불가!!!!!!!")
        }
    }
    
    func fetchSummary(coordinate : CLLocationCoordinate2D) {
        // 뒤에 붙은거??
        let urlStr = "https://api2.sktelecom.com/weather/current/minutely?version=1&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=\(appKey)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        guard let url = URL(string: urlStr) else { fatalError() }
        
        Alamofire.request(url, method: .get).responseJSON { [weak self] (response) in
            guard response.result.isSuccess else { return }
            guard let data = response.result.value as? [String: Any] else { return }
            
            let json = JSON(data)
            guard let summary = WeatherSummary(json: json) else { return }
            self?.summary = summary
            
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
            }
        }
    }
    
    
    func fetchForecast(coordinate : CLLocationCoordinate2D) {
        let urlStr = "https://api2.sktelecom.com/weather/forecast/3days?version=1&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=\(appKey)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        guard let url = URL(string: urlStr) else { fatalError() }
        
        Alamofire.request(url, method: .get).responseJSON { [weak self] (response) in
            
            guard response.result.isSuccess else { return }
            guard let data = response.result.value as? [String: Any] else { return }
            
            let json = JSON(data)
            // 옵셔널이 안되는것?
            let fcast = json["weather"]["forecast3days"][0]["fcst3hour"]
            print(fcast)
            // ??? 새로 하려고??
            self?.forecast.removeAll()
            
            let comps = Calendar.current.dateComponents([.month, .day, .hour], from: Date())
            guard let now = Calendar.current.date(from: comps) else { return }
            
            var hour = 4
            while hour <= 64 {
                // 나중에 실행해주는것
                defer {
                    hour += 3
                }
                
                guard let sky = fcast["sky"].dictionary else { continue }
                guard let skyName = sky["name\(hour)hour"]?.string, skyName.count > 0 else { continue }
                guard let skyCode = sky["code\(hour)hour"]?.string, skyCode.count > 0 else { continue }
                guard let temp = fcast["temperature"].dictionary?["temp\(hour)hour"]?.string else { continue }
                let dbl = Double(temp) ?? 0.0
               //???h
                let dt = now.addingTimeInterval(TimeInterval(hour * 3600))
                
                let newData = Forecast(date: dt, skyName: skyName, skyCode: skyCode, temperature: dbl)
                self?.forecast.append(newData)
            }
            
            // 왜 굳이 메인스레드에서 reload?
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
            }
        }
    }
    
    
    var topInset : CGFloat = 0.0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if topInset == 0.0 {
            let first = IndexPath(row: 0, section: 0)
            if let cell = listTableView.cellForRow(at: first) {
                topInset = listTableView.frame.height - cell.frame.height
                listTableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
            }
        }
    }
}



extension ViewController : UITableViewDataSource {
    // ????
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
                cell.weatherImageView.image = UIImage(named: data.skyCode)
                cell.statusLabel.text = data.skyName
                cell.minMaxLabel.text = "최대 \(data.tempMax)º~최소 \(data.tempMin)º"
                cell.currentTemperatureLabel.text = "\(data.tempCurrent)º"
                
                cell.indicator.isHidden = true
            } else {
                cell.indicator.isHidden = false
            }
            
            cell.weatherImageView.isHidden = !cell.indicator.isHidden
            cell.statusLabel.isHidden = !cell.indicator.isHidden
            cell.minMaxLabel.isHidden = !cell.indicator.isHidden
            cell.currentTemperatureLabel.isHidden = !cell.indicator.isHidden
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell") as! ForecastTableViewCell
        
        let target = forecast[indexPath.row]
        
        df.dateFormat = "M.d (E)"
        cell.dateLabel.text = df.string(for: target.date)
        
        df.dateFormat = "HH:mm"
        cell.timeLabel.text = df.string(for: target.date)
        
        cell.weatherImageView.image = UIImage(named: target.skyCode)
        
        cell.statusLabel.text = target.skyName
        cell.temperatureLabel.text = "\(target.temperature)º"
        
        return cell
        
    }
    
    
}





extension ViewController : CLLocationManagerDelegate {
    // 지역정보 업데이트시키기
    func updateCurrentLocation() {
        locationManagaer.startUpdatingLocation()
    }
    
    // Auth관리
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            updateCurrentLocation()
        default:
            break
        }
    }
    
    
    // Location 업데이트할 경우, 상세정보 받아서 입력
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            // 지리적 지역정보를 이름으로 바꿔준다
            let decoder = CLGeocoder()
            // decoder로 reverseLocation
            decoder.reverseGeocodeLocation(loc, completionHandler: { [weak self] (placemarks, error) in
                // 지역정보 배열 place를 가져옴
                print(placemarks)
                
                if let place = placemarks?.first {
                    print(place)
                    if let gu = place.locality, let dong = place.subLocality {
                        self?.locationLabel.text = "\(gu) \(dong)"
                    } else {
                        //??
                        self?.locationLabel.text = place.name
                    }
                }
            })
            
            // 지역 정보를 받아와서, 그 지역의 2D 정보를 패치한다
            fetchSummary(coordinate: loc.coordinate)
            fetchForecast(coordinate: loc.coordinate)
        }
        
        locationManagaer.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}






















