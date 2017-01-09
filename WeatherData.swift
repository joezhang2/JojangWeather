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
let owmBaseUrl = "http://api.openweathermap.org/data/2.5/forecast"
let apixuKey = "305d95d0b4b04418864232101170301"
let apixuBaseUrl = "https://api.apixu.com/v1/forecast.json?key="

struct Weather {
    var weatherCondition: String
    var temperature: String
    var time: String
    
    init(weatherCondition: String, temperature: String, time: String){
        self.weatherCondition = weatherCondition
        self.temperature = temperature
        self.time = time
    }
}

struct Forecast {
    var fiveTimeUnitsForecast: [Weather]
    let numForecasts = 5
    
    init() {        
        fiveTimeUnitsForecast = [Weather](repeating: Weather(weatherCondition: "Null", temperature: "0.0°", time: "Null day"), count: numForecasts )
    }
    
    mutating func setForecast(conditions: [String], temperature: [String], timeUnits: [String]) {
        fiveTimeUnitsForecast.removeAll()
        var day: Weather = Weather(weatherCondition: "null", temperature: "0.0°", time: "null")
        for index in 0 ... numForecasts-1{
            day = Weather(weatherCondition: conditions[index], temperature: temperature[index], time: timeUnits[index])
            fiveTimeUnitsForecast.append(day)
        }
    }
    
    mutating func updateForecast(curLocation: CLLocation, cityName: String, daily:Bool = false) throws {
        let jsonData: JSON!
        let cond: [String]
        let temp: [String]
        let time: [String]
        
        do{
            jsonData = try retrieveData(curLocation: curLocation, cityName: cityName, daily: daily)
            
        }catch {
            throw BadUrlError.badUrl
        }
        if daily{
            (cond, temp, time) = parseDailyData(data: jsonData)
            setForecast(conditions: cond, temperature: temp, timeUnits: time)
        }
        else{
            
        }
    }
    
    func retrieveData(curLocation: CLLocation, cityName: String, daily:Bool = false)throws->JSON{
        var urlString: String
        var json: JSON!
        //"?id=4887398&APPID=5b9d4a06a07a8a29f234cb9dd91cb2c4"
        if daily{
            urlString = owmBaseUrl + "/daily" + "?lat=\(curLocation.coordinate.latitude)&lon=\(curLocation.coordinate.longitude)&APPID=" + owmKey + "&units=imperial"
            print(urlString)
        }
        else{
            urlString = apixuBaseUrl + apixuKey + "&q=\(curLocation.coordinate.latitude),\(curLocation.coordinate.longitude)&days=1"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                json = JSON(data: data)
            }
        }
        
        if json["city"] != JSON.null || json["location"] != JSON.null{
            return json
        }
        else {
            throw BadUrlError.badUrl
        }
    }
    
    func parseDailyData(data: JSON) ->([String], [String], [String]){
        var conditions = [String]()
        var temperature = [String]()
        var timeUnits = [String]()
        
        for index in 0 ... numForecasts-1{
            
            let date = NSDate(timeIntervalSince1970: data["list"][index]["dt"].double!)
            let formatter  = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            //guard let curDate = formatter.date(from: date) else { return nil }
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: date as Date)
            let dayOfweek: String
            
            switch weekDay {
            case 0:
                dayOfweek = "Sun"
            case 1:
                dayOfweek = "Mon"
            case 2:
                dayOfweek = "Tue"
            case 3:
                dayOfweek = "Wed"
            case 4:
                dayOfweek = "Thr"
            case 5:
                dayOfweek = "Fri"
            default:
                dayOfweek = "Sat"
            }
            
            timeUnits.append(dayOfweek)
            
            temperature.append("\(data["list"][index]["temp"]["day"].double!)°")
            
            let symbol = OpenWeatherMapIcon.convert(condition: (data["list"][index]["weather"][0]["id"].int!))
            //print(data["list"][index]["weather"][0]["main"].string)
            //print(symbol)
            conditions.append(symbol)
        }
        
        return (conditions, temperature, timeUnits)
    }
    func convertToDayOfWeek(){
        
    }
}

enum BadUrlError: Error {
    case badUrl
    case badData
}
