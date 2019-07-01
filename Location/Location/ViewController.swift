//
//  ViewController.swift
//  Location
//
//  Created by CHUNGEUNJI on 2018. 2. 28..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit
// 위치와 관련된 애들 연동하는 프레임워크
import CoreLocation

class ViewController: UIViewController {
    
    // CoreLocation와 관련된 건 CL로 시작
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 사용자에게 GPS 사용 허가 요청(두 개가 있는데 얘는 언제 쓴다고...?)
        // Delegate로 허가된건지 판단
        // UI가 아니기 때문에 Delegate를 코드로 직접 연결 후, 밑에 extension
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        // 얘는 왜 갑자기 바꿔줬지? ㅜㅜㅜㅜ
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            updateLocation()
        default:
            print("unavailable")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



extension ViewController: CLLocationManagerDelegate {
//    lovsyion > insta 아이디로 좋을듯...
    
    // iOS가 지역이 바뀔때마다 알려줌 (?)
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // 측정된 위치가 배열로 넘어온다
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 최신 위치정보 바인딩
        if let current = locations.last {
            print(current.coordinate.latitude, current.coordinate.longitude)
            manager.stopUpdatingLocation()  // 꼭 멈춰준다!
        }
    }
    
    
    // 상태를 전달
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            // 사용자가 앱을 실행할 때만 GPS 사용 -> 단, Info.plist에서 Location 추가해줘야함(사용 용도에 맞아야하고, 사용자가 보기에 혼란을 주지 않아야 함)
        case .authorizedWhenInUse:
            updateLocation()
        default:
            // 나중엔 에러처리 다 해주어야 됨
            print("unavailable")
        }
    }
}





























