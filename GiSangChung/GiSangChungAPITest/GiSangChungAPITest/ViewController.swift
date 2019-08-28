//
//  ViewController.swift
//  GiSangChungAPITest
//
//  Created by eunji on 27/08/2019.
//  Copyright © 2019 eunji. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    
    let serviceKey = "LeBnEReXhgadmPwRkbb0aHyqsiTTsIQIOIqz1%2Bmh3w%2FsCjiHXizoS3Cc3440XU6R%2BwL6p%2FRYtucB3RPqsADMMQ%3D%3D"
    let kmaPath = "http://newsky2.kma.go.kr/service/SecndSrtpdFrcstInfoService2/ForecastGrib"
    let base_date = Date().getBaseDate()
    let base_time = Date().getBaseTime()
    var nx = 60
    var ny = 127
    let numOfRows = "5"
    let pageNo = "1"
    let type = "json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        manager.delegate = self
        manager.distanceFilter = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func urlSession() {
        
        let urlString = kmaPath + "?ServiceKey=\(serviceKey)"
        
        let parameters: Parameters = [
            "base_date" : "20190828",
            "base_time" : "0630",
            "nx" : nx,
            "ny" : ny,
            "numOfRows" : numOfRows,
            "pageNo" : pageNo,
            "_type" : type
        ]
        let url = URL(string: urlString)!
        
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString).responseJSON { (response) in
            guard let jsonObject = response.result.value as? [String:Any] else {
                print("failed")
                return
            }
            
            print(jsonObject)

            let weather = WeatherVO.init(jsonObject)
            
            guard weather.getWeatherData() else { return }
            let weatherData = weather.weatherData
            
            print("WeatherData:", weatherData)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        let location = locations[locations.count - 1]
        
        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        
        convertToAddress(coordinate: location)
        
        let convert = LambertProjection()
        (nx, ny) = convert.convertToGrid(lon: longitude, lat: latitude)
        
        print("grid 변환 값 : \(nx), \(ny)")
        print("degree 변환 값 : \(longitude), \(latitude)")
        print("===========================")
        
        urlSession()
        
    }
    
    func convertToAddress(coordinate: CLLocation) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(coordinate) { (placemarks, error) in
            guard let placemark = placemarks?.first, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                
                guard let country = placemark.country, let state = placemark.administrativeArea, let city = placemark.locality, let address = placemark.thoroughfare else {
                    return
                }
                
                print(country)
                print(state)
                print(city)
                print(address)
            }
        }
    }


}


extension String {
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)!
        return text
    }
}

