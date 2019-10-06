//
//  ViewController.swift
//  Concurrency
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - SK Weather Planet API
public let skWPSixDaysAPI                       =   "https://apis.openapi.sk.com/weather/forecast/6days"
public let skWPThreeDaysAPI                     =   "https://apis.openapi.sk.com/weather/forecast/3days"
public let skDebugAppKey                        =   "cd0c9c72-6e32-4181-9291-9340adb8d0dc"


class ViewController: UIViewController {

    let dispatchGroup = DispatchGroup()
    let dispatchQueue = DispatchQueue.global()
    var latitude: Double = 37.51151
    var longitude: Double = 127.0967
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("========START!!===========")
        
        callBeforeFirst()
        callSecond()
        
        dispatchGroup.notify(queue: dispatchQueue) {
            print("=======================Done!")
        }
    }
    
    func callFirst(_ success: @escaping ([String: Any]) -> (), _ failure: @escaping (Error) -> ()) {
        guard let url = URL(string: skWPThreeDaysAPI + "?appKey=\(skDebugAppKey)&lat=\(latitude)&lon=\(longitude)") else { return }
        
        dispatchGroup.enter()
        dispatchQueue.async {
            Alamofire.request(url).responseJSON { (response) in
                if response.result.isSuccess {
                    if let result = response.result.value as? [String:Any] {
                        success(result)
                    }
                } else {
                    if let error = response.result.error {
                        failure(error)
                    }
                }
            }
            
        }
    }
    
    func callBeforeFirst() {
        callFirst({ (result) in
            print("Done First \(result)")
            self.dispatchGroup.leave()
        }) { (error) in
            print("Error \(error.localizedDescription)")
        }
    }
    
    func callSecond() {
        guard let url = URL(string: skWPSixDaysAPI + "?appKey=\(skDebugAppKey)&lat=\(latitude)&lon=\(longitude)") else { return }
        
        dispatchGroup.enter()
        dispatchQueue.async {
            Alamofire.request(url).responseJSON { (response) in
                if response.result.isSuccess {
                    if let result = response.result.value as? [String:Any] {
                        print("2 Result \(result)")
                        self.dispatchGroup.leave()
                    }
                }
            }
            
        }
    }
    


}

