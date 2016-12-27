//
//  WeatherData.swift
//  JojangWeather
//
//  Created by Joseph Zhang on 12/13/16.
//  Copyright © 2016 Joseph Zhang. All rights reserved.
//

import Cocoa
import CoreLocation


let owmKey: String = "5b9d4a06a07a8a29f234cb9dd91cb2c4"

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
    
    init() {
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
    
}


class WeatherForecast: NSObject {
    var curData = Forecast()
    lazy var geocoder = CLGeocoder()
    
    override init(){
        
    }
    

    /*
    func getLocation() -> CLLocation{
        
        let locationManager = CLLocationManager()
        var currentLocation: CLLocation!
        
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == CLAuthorizationStatus.restricted || authStatus == CLAuthorizationStatus.denied {
            print("Sorry, location is not permited, you need to enable it in System Preferences")
            exit(1)
        }
        
        if CLLocationManager.locationServicesEnabled() != true {
            print("Sorry, location not supported")
            exit(2)
        }
        locationManager.startUpdatingLocation()
        
        currentLocation = locationManager.location
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.stopUpdatingLocation()
        
        let text1: String = "\(currentLocation.coordinate.longitude)"
        let text2: String = "\(currentLocation.coordinate.latitude)"
        print(text1)
        print(text2)
        return currentLocation
        
    }*/
    /*
    func lookUpCity(){
        /*
        var jsonData: Data?
        
        if let file = Bundle.main.path(forResource: "city.list.us", ofType: "json") {
            jsonData = try? Data(contentsOf: URL(fileURLWithPath: file))
        } else {
            print("Fail")
        }
        let jsonString = String(data: jsonData!, encoding: .utf8)
        let dataFromString = jsonString?.data(using: .utf8)
        let json3 = JSON(data: dataFromString!)
        print("jsonData:\(json3)")
        */
        //let location: CLLocation! = getLocation()
        let text1: String = "\(location.coordinate.longitude)"
        let text2: String = "\(location.coordinate.latitude)"
        print(text1)
        print(text2)
        
    }*/
}

