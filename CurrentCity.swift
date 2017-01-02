//
//  CurrentCity.swift
//  JojangWeather
//
//  Created by Joseph Zhang on 12/30/16.
//  Copyright © 2016 Joseph Zhang. All rights reserved.
//

import Foundation

struct CurrentCity {
    var longitude: Double
    var latitude: Double
    var cityId: String!
    var cityName: String
    var citiesJson: JSON
    
    init(longitude: Double, latitude: Double, cityName: String){
        self.longitude = longitude
        self.latitude = latitude
        self.cityName = cityName
        
        // Load json file of US cities as a Swifty Json object
        var jsonData: Data?
        if let file = Bundle.main.path(forResource: "city.list.us", ofType: "json") {
            jsonData = try? Data(contentsOf: URL(fileURLWithPath: file))
        }
        let jsonString = String(data: jsonData!, encoding: .utf8)
        let dataFromString = jsonString?.data(using: .utf8)
        citiesJson = JSON(data: dataFromString!)
    }
    
    func lookUpCityId() throws -> String{
        var curCityId: String!
        let cityIds = searchByCityName()
        
        if cityIds.count == 0{
            throw CityNotFound.cityNotInList
        }
        
        if cityIds.count == 1{
            for city in cityIds{
                curCityId = city.value.id
            }
        }
        else{
            curCityId = findCityIdFromDuplicates(cityList: cityIds)
        }
        
        return curCityId
    }
    
    func searchByCityName()->[String: (id: String, lon: Double, lat: Double)]{
        //var tempCity: String
        var cityIds = [String: (id: String, lon: Double, lat: Double)]()
        
        for (key, data) in citiesJson{
            if data["name"].string == cityName{
                if let id = data["_id"].int, let lon = data["coord"]["lon"].double, let lat = data["coord"]["lat"].double{
                    cityIds.updateValue((String(id), lon, lat), forKey: key)
                }
            }
        }
        return cityIds
    }
    
    func findCityIdFromDuplicates(cityList: [String: (id: String, lon: Double, lat: Double)])->String{
        var shortestDistance = Double.greatestFiniteMagnitude
        var curDistance: Double
        var closestCityId: String!
        
        for city in cityList{
            curDistance = calculateDistanceToCurentCity(lon: city.value.lon, lat: city.value.lat)
            if curDistance < shortestDistance{
                shortestDistance = curDistance
                closestCityId = city.value.id
            }
        }
        return closestCityId
    }
    
    func searchByCoordinates()->String{
        var shortestDistance = Double.greatestFiniteMagnitude
        var curDistance: Double
        var closestCityId: String!
        
        for (_, data) in citiesJson{
            if let id = data["_id"].int, let lon = data["coord"]["lon"].double, let lat = data["coord"]["lat"].double{
                curDistance = calculateDistanceToCurentCity(lon: lon, lat: lat)
                if curDistance < shortestDistance{
                    shortestDistance = curDistance
                    closestCityId = String(id)
                }

            
            }
        }
        return closestCityId
    }
    
    func calculateDistanceToCurentCity(lon: Double, lat: Double) -> Double{
        var dist = pow(lon-longitude, 2.0)
        dist += pow(lat-latitude, 2.0)
        dist = dist.squareRoot()
        
        return dist
    }
    
    
}

enum CityNotFound: Error{
    case cityNotInList
}

