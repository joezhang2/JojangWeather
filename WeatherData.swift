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
    
    // Overwrites the array of Weather structs with data from the arrays
    //  To do: Check that the array sizes match? Or is it safe to assume the user will do that?
    mutating func setForecast(conditions: [String], temperature: [String], timeUnits: [String]) {
        fiveTimeUnitsForecast.removeAll()
        
        var day: Weather = Weather(weatherCondition: "null", temperature: "0.0°", time: "null")
        
        for index in 0 ... numForecasts-1{
            day = Weather(weatherCondition: conditions[index], temperature: temperature[index], time: timeUnits[index])
            fiveTimeUnitsForecast.append(day)
        }
    }
    
    // Update weather data using the corresponding API
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
            (cond, temp, time) = parseHourlyData(data: jsonData)
            setForecast(conditions: cond, temperature: temp, timeUnits: time)
        }
    }
    
    
    // Get weather data from API
    func retrieveData(curLocation: CLLocation, cityName: String, daily:Bool = false)throws->JSON{
        var urlString: String
        var json: JSON!
        // Modify url to for the corresponding APIs
        if daily{
            urlString = owmBaseUrl + "/daily" + "?lat=\(curLocation.coordinate.latitude)&lon=\(curLocation.coordinate.longitude)&APPID=" + owmKey + "&units=imperial"
        }
        else{
            urlString = apixuBaseUrl + apixuKey + "&q=\(curLocation.coordinate.latitude),\(curLocation.coordinate.longitude)&days=2"
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
    
    // Parse the daily weather json and arrays of weather data
    func parseDailyData(data: JSON) ->([String], [String], [String]){
        var conditions = [String]()
        var temperature = [String]()
        var timeUnits = [String]()
        
        for index in 0 ... numForecasts-1{
            // Convert date from yyyy-MM-dd to day of week
            let date = NSDate(timeIntervalSince1970: data["list"][index]["dt"].double!)
            let formatter  = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
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
            
            // Save the forecasted temperature
            temperature.append("\(data["list"][index]["temp"]["day"].double!)°")
            
            // Convert the weather condition into the corresponding weather icon
            let symbol = OpenWeatherMapIcon.convert(condition: (data["list"][index]["weather"][0]["id"].int!))
            conditions.append(symbol)
        }
        
        return (conditions, temperature, timeUnits)
    }
    
    func parseHourlyData(data: JSON) ->([String], [String], [String]){
        var conditions = [String]()
        var temperature = [String]()
        var timeUnits = [String]()
        let formatter  = DateFormatter()
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        // Check if data from tomorrow is needed
        //  Forecasted data is returned in arrays of 24 forecasts per day. So if
        //  the current time is 10 pm, data for tomorrow would be needed as well.
        let hour = Calendar.current.component(.hour, from: Date())
        var endingPoint = 0
        
        if(hour+numForecasts-1 <= 23){
                endingPoint = hour + numForecasts-1
        }
        else{
            endingPoint = 23
        }
        
        // Get data for today
        for index in hour ... endingPoint{
            // Convert the time into the hour
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let date = formatter.date(from: data["forecast"]["forecastday"][0]["hour"][index]["time"].string!)
            formatter.dateFormat = "hh:mm a"
            timeUnits.append(formatter.string(from: date!))
            
            // Save the forecasted temperature
            temperature.append("\(data["forecast"]["forecastday"][0]["hour"][index]["temp_f"].double!)°")
            
            // Convert the weather condition into the corresponding weather icon
            let symbol = ApixuIcon.convert(condition: (data["forecast"]["forecastday"][0]["hour"][index]["condition"]["code"].int!))
            conditions.append(symbol)
        }
        
        // Get data for tomorrow if needed
        if(hour+numForecasts-1 > 23){
            endingPoint = hour + numForecasts - 1 - 24
            for index in 0 ... endingPoint{
                // Convert the time into the hour
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let date = formatter.date(from: data["forecast"]["forecastday"][1]["hour"][index]["time"].string!)
                formatter.dateFormat = "hh:mm a"
                timeUnits.append(formatter.string(from: date!))
                
                // Save the forecasted temperature
                temperature.append("\(data["forecast"]["forecastday"][1]["hour"][index]["temp_f"].double!)°")
                
                // Convert the weather condition into the corresponding weather icon
                let symbol = ApixuIcon.convert(condition: (data["forecast"]["forecastday"][1]["hour"][index]["condition"]["code"].int!))
                conditions.append(symbol)
            }
        }
        
        return (conditions, temperature, timeUnits)
    }
    
    
}

enum BadUrlError: Error {
    case badUrl
    case badData
}
