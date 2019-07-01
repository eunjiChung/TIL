//
//  Model.swift
//  Weather3
//
//  Created by CHUNGEUNJI on 2018. 3. 28..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Forecast {
    let date: Date
    let skyName: String
    let skyCode: String
    let temp: Double
}


struct WeatherSummary {
    let skyName: String
    let skyCode: String
    let tempCurrent: Double
    let tempMax: Double
    let tempMin: Double
    
    init?(json: JSON) {
        print(json)
        
        guard let data = json["weather"]["minutely"][0].dictionary else { fatalError() }
        guard let name = data["sky"]?["name"].string else { fatalError() }
        skyName = name
        guard let code = data["sky"]?["code"].string else { fatalError() }
        skyCode = code
        guard let temperature = data["temperature"]?.dictionary else { fatalError() }
        guard let tc = temperature["tc"]?.string else { fatalError() }
        tempCurrent = Double(tc) ?? 0.0
        guard let tMax = temperature["tmax"]?.string else { fatalError() }
        tempMax = Double(tMax) ?? 0.0
        guard let tMin = temperature["tmin"]?.string else { fatalError() }
        tempMin = Double(tMin) ?? 0.0
    }
}



















