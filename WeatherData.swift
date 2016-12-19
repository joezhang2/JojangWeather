//
//  WeatherData.swift
//  JojangWeather
//
//  Created by Joseph Zhang on 12/13/16.
//  Copyright © 2016 Joseph Zhang. All rights reserved.
//

import Cocoa
import Foundation


struct Forecast {
    var weatherCondition: String
    var temperature: Double
    
    init(weatherCondition: String, temperature: Double){
        self.weatherCondition = weatherCondition
        self.temperature = temperature
    }
}

struct WeatherData {
    var fiveDayForecast: [Forecast] = [Forecast](repeating: Forecast(weatherCondition: "Null", temperature: 0.0), count: 5 )
    
    mutating func setForecast(conditions: [String], temperature: [Double]) {
        fiveDayForecast.removeAll()
        var day: Forecast = Forecast(weatherCondition: "null", temperature: 0.0)
        for (cond, temp) in zip(conditions, temperature) {
            day = Forecast(weatherCondition: cond, temperature: temp)
            fiveDayForecast.append(day)
        }
    }
}

/*
class WeatherData: NSObject {

}
*/
