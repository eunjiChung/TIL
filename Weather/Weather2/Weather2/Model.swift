//
//  Model.swift
//  Weather2
//
//  Created by CHUNGEUNJI on 2018. 3. 27..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Forecast {
    let date : Date
    let skyName : String
    let skyCode : String
    let temperature : Double
}

struct WeatherSummary {
    let skyName: String
    let skyCode: String
    let tempCurrent : Double
    let tempMax : Double
    let tempMin : Double
    
    init?(json: JSON) {
        print(json)
        
        guard let info = json["weather"]["minutely"][0].dictionary else { fatalError() }
        guard let name = info["sky"]?["name"].string else { fatalError() }
        skyName = name
        guard let code = info["sky"]?["code"].string else { fatalError() }
        skyCode = code
        
        guard let temp = info["temperature"]?.dictionary else { fatalError() }
        guard let tCurrent = temp["tc"]?.string else { fatalError() }
        tempCurrent = Double(tCurrent) ?? 0.0
        guard let tMax = temp["tmax"]?.string else { fatalError() }
        tempMax = Double(tMax) ?? 0.0
        guard let tMin = temp["tmin"]?.string else { fatalError() }
        tempMin = Double(tMin) ?? 0.0
    }
}































