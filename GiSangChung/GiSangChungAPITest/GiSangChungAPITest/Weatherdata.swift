//
//  Weatherdata.swift
//  GiSangChungAPITest
//
//  Created by eunji on 28/08/2019.
//  Copyright © 2019 eunji. All rights reserved.
//

import Foundation

struct WeatherData {
    // 초단기실황
    var t1h = "" // 기온
    var rn1 = "" // 1시간 강수량
    var sky = "" // 하늘 상태
    var uuu = "" // 동서바람성분
    var vvv = "" // 남북바람성분
    var reh = "" // 습도
    var pty = "" // 강수형태
    var lgt = "" // 낙뢰
    var vec = "" // 풍향
    var wsd = "" // 풍속
}

class WeatherVO {
    
    private var jsonObject: [String:Any]
    lazy var weatherData = WeatherData()
    
    init(_ jsonObject: [String:Any]) {
        self.jsonObject = jsonObject
    }
    
    func getWeatherData() -> Bool {
        convertToData()
        return true
    }
    
    // json 객체를 배열형태로 반환하는 메서드
    private func checkJsonObject(jsonObject: [String: Any]) -> [[String: Any]]? {
        
        guard let resObject = jsonObject["response"] as? [String: Any] else {
            return nil
        }
        guard let bodyObject = resObject["body"] as? [String: Any] else {
            return nil
        }
        guard let itemsObject = bodyObject["items"] as? [String: Any] else {
            return nil
        }
        guard let itemArray = itemsObject["item"] as? [[String: Any]] else {
            return nil
        }
        
        return itemArray
    }
    
    
    // api로부터 받아온 데이터를 weatherData로 변환하는 메서드
    private func convertToData() {
        
        var dataDic = [String: String]()
        
        guard let itemArray = checkJsonObject(jsonObject: jsonObject) else { return }
        
        for item in itemArray {
            guard let category = item["category"] as? String else { return }
            guard let value = item["obsrValue"] else { return }
            
            
            switch category {
            case "T1H":
                dataDic["T1H"] = String(describing: value)
                
            case "RN1":
                dataDic["RN1"] = String(describing: value)
                
            case "SKY":
                dataDic["SKY"] = String(describing: value)
                
            case "UUU":
                dataDic["UUU"] = String(describing: value)
                
            case "VVV":
                dataDic["VVV"] = String(describing: value)
                
            case "REH":
                dataDic["REH"] = String(describing: value)
                
            case "PTY":
                dataDic["PTY"] = String(describing: value)
                
            case "LGT":
                dataDic["LGT"] = String(describing: value)
                
            case "VEC":
                dataDic["VEC"] = String(describing: value)
                
            case "WSD":
                dataDic["WSD"] = String(describing: value)
                
            default:
                ()
            }
        }
        
        
        for (key, value) in dataDic {
            
            switch key {
            case "T1H":     // 현재 온도
                weatherData.t1h = "\(value)ºC"
                
            case "RN1":     // 강수량
                
                guard let value = Double(value) else {
                    return
                }
                if value == 0 {
                    weatherData.rn1 = "0mm"
                } else if value <= 1 {
                    weatherData.rn1 = "1mm 미만"
                } else if value <= 5 {
                    weatherData.rn1 = "1 ~ 4mm"
                } else if value <= 10 {
                    weatherData.rn1 = "5 ~ 9mm"
                } else if value <= 20 {
                    weatherData.rn1 = "10 ~ 19mm"
                } else if value <= 40 {
                    weatherData.rn1 = "20 ~ 39mm"
                } else if value <= 70 {
                    weatherData.rn1 = "40 ~ 69mm"
                } else if value == 100 {
                    weatherData.rn1 = "70mm 이상"
                }
                
            case "SKY":     // 하늘상태
                if value == "1" {
                    weatherData.sky = "맑음"
                } else if value == "2" {
                    weatherData.sky = "구름조금"
                } else if value == "3" {
                    weatherData.sky = "구름많음"
                } else if value == "4" {
                    weatherData.sky = "흐림"
                }
                
            case "UUU":     // 동서바람성분
                weatherData.uuu = "\(value)"
                
            case "VVV":     // 남북바람성분
                weatherData.vvv = "\(value)"
                
            case "REH":     // 현재 습도
                weatherData.reh = "\(value)%"
                
            case "PTY":     // 강수형태
                if value == "0" {
                    weatherData.pty = "없음"
                } else if value == "1" {
                    weatherData.pty = "비"
                } else if value == "2" {
                    weatherData.pty = "비/눈"
                } else if value == "3" {
                    weatherData.pty = "눈"
                }
                
            case "LGT":     // 낙뢰
                if value == "0" {
                    weatherData.lgt = "없음"
                } else {
                    weatherData.lgt = "있음"
                }
                
            case "VEC":     // 풍향
                let vec = Int((Double(value)! + 22.5 * 0.5) / 22.5)
                if vec == 0 {
                    weatherData.vec = "북"
                } else if vec == 1 {
                    weatherData.vec = "북북동"
                } else if vec == 2 {
                    weatherData.vec = "북동"
                } else if vec == 3 {
                    weatherData.vec = "동동"
                } else if vec == 12 {
                    weatherData.vec = "서"
                } else if vec == 13 {
                    weatherData.vec = "서북서"
                } else if vec == 14 {
                    weatherData.vec = "북서"
                } else if vec == 15 {
                    weatherData.vec = "북북서"
                } else if vec == 16 {
                    weatherData.vec = "북"
                }
                
            case "WSD":     // 풍속
                weatherData.wsd = "\(value)m/s"
                
            default:
                ()
            }
        }
    }
}
