//
//  Model.swift
//  Weather4
//
//  Created by CHUNGEUNJI on 2018. 3. 29..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Forecast {
    let date : Date
    let skyName : String
    let skyCode : String
    let temp : Double
}

struct WeatherSummary {
    let skyName : String
    let skyCode : String
    let tempCurrent : Double
    let tempMax : Double
    let tempMin : Double
    
    init?(json: JSON) {
        print(json)
        
        guard let data = json["weather"]["minutely"][0].dictionary else { fatalError() }
        
        guard let sky = data["sky"]?.dictionary else { fatalError() }
        guard let name = sky["name"]?.string else { fatalError() }
        skyName = name
        guard let code = sky["code"]?.string else { fatalError() }
        skyCode = code
        
        guard let temp = data["temperature"]?.dictionary else { fatalError() }
        guard let tc = temp["tc"]?.string else { fatalError() }
        tempCurrent = Double(tc) ?? 0.0
        guard let tmax = temp["tmax"]?.string else { fatalError() }
        tempMax = Double(tmax) ?? 0.0
        guard let tmin = temp["tmin"]?.string else { fatalError() }
        tempMin = Double(tmin) ?? 0.0
    }
}
