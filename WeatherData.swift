//
//  WeatherData.swift
//  JojangWeather
//
//  Created by Joseph Zhang on 12/13/16.
//  Copyright © 2016 Joseph Zhang. All rights reserved.
//

import Cocoa
import CoreLocation


let owmKey = "5b9d4a06a07a8a29f234cb9dd91cb2c4"
let baseUrl = "http://api.openweathermap.org/data/2.5/forecast"

struct Weather {
    var weatherCondition: String
    var temperature: Double
    
    init(weatherCondition: String, temperature: Double){
        self.weatherCondition = weatherCondition
        self.temperature = temperature
    }
}

struct Forecast {
    var fiveDayForecast: [Weather]
    var curLocation: CLLocation
    var cityName: String
    
    init(curLocation: CLLocation, cityName: String) {
        self.curLocation = curLocation
        self.cityName = cityName        
        fiveDayForecast = [Weather](repeating: Weather(weatherCondition: "Null", temperature: 0.0), count: 5 )
    }
    
    mutating func setForecast(conditions: [String], temperature: [Double]) {
        fiveDayForecast.removeAll()
        var day: Weather = Weather(weatherCondition: "null", temperature: 0.0)
        for (cond, temp) in zip(conditions, temperature) {
            day = Weather(weatherCondition: cond, temperature: temp)
            fiveDayForecast.append(day)
        }
    }
    
    func retrieveData(daily:Bool = false){
        let urlString = "?id=4887398&APPID=5b9d4a06a07a8a29f234cb9dd91cb2c4"
        
        print("trying")
        if let url = URL(string: urlString) {
            print("1st layer")
            print(url)
            
            
            if let data = try? Data(contentsOf: url) {
                print("inside")
                let json = JSON(data: data)
                print("jsonData:\(json)")
                
            }
            
            print("done")
        }

    }
}


