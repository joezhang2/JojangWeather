//
//  StringToWeatherIcon.swift
//  JojangWeather
//
//  Created by Joseph Zhang on 1/5/17.
//  Copyright © 2017 Joseph Zhang. All rights reserved.
//

import Foundation

struct OpenWeatherMapIcon {
    static func convert(condition: Int) ->String {
        let symbol: String
        let id = (condition/100)
        
        switch id {
        // Thunderstorms
        case 2 : symbol = "\u{f01e}"
        // Drizzle
        case 3 : symbol = "\u{f01c}"
        // Rain
        case 5 : symbol = "\u{f019}"
        // Snow
        case 6 : symbol = "\u{f01b}"
        // Poor visibility
        case 7 :
            // Tornado
            if condition == 781{
                symbol = "\u{f056}"
            }
            // Mist
            else{
                symbol = "\u{f082}"
            }
        // Clouds
        case 8 :
            // Clear sky
            if condition == 800{
                symbol = "\u{f00d}"
            }
            // Overcast
            else{
                symbol = "\u{f041}"
            }
        // Extreme
        case 9 :
            // Tornado
            if condition == 900{
                symbol = "\u{f056}"
            }
            // Hurricane/Tropical storm
            else if condition == 901 || condition == 902 || condition == 962{
                symbol = "\u{f073}"
            }
            // Cold
            else if condition == 903{
                symbol = "\u{f076}"
            }
            // Hot
            else if condition == 904{
                symbol = "\u{f072}"
            }
            // Windy
            else if condition == 905{
                symbol = "\u{f050}"
            }
            // Hail
            else if condition == 906{
                symbol = "\u{f015}"
            }
            // Calm
            else if condition == 951{
                symbol = "\u{f00d}"
            }
            // Breeze
            else if condition <= 955{
                symbol = "\u{f021}"
            }
            // High wind
            else if condition <= 959{
                symbol = "\u{f050}"
            }
            // Storm
            else {
                symbol = "\u{f01e}"
            }
        default : symbol = "\u{f07b}"
        }
        return symbol
    }
}

struct ApixuIcon {
    static func convert(condition: Int) ->String {
        let symbol: String
        
        switch condition {
        // Sunny
        case 1000 : symbol = "\u{f00d}"

        // Cloudy
            // Partly Cloudy
        case 1003 : symbol = "\u{f041}"
            // Cloudy
        case 1006 : symbol = "\u{f041}"
            // Overcast
        case 1009 : symbol = "\u{f041}"
        // Fog
            // Mist
        case 1030 : symbol = "\u{f014}"
            // Fog
        case 1135 : symbol = "\u{f014}"
            // Freezing fog
        case 1147 : symbol = "\u{f014}"
        
        // Light Rain
            // Patchy rain nearby
        case 1063 : symbol = "\u{f01c}"
            // Patchy light drizzle
        case 1150 : symbol = "\u{f01c}"
            // Light drizzle
        case 1153 : symbol = "\u{f01c}"
            // Patchy light rain
        case 1180 : symbol = "\u{f01c}"
            // Light rain
        case 1183 : symbol = "\u{f01c}"
            // Light rain shower
        case 1240 : symbol = "\u{f01c}"
        
        // Storm showers
            //Moderate or heavy rain shower
        case 1243 : symbol = "\u{f01d}"
            // Patchy light rain in area with thunder
        case 1273 : symbol = "\u{f01d}"
        
        // Thunderstorm
            // Thundery outbreaks in nearby
        case 1087 : symbol = "\u{f01e}"
            // Heavy rain at times
        case 1192 : symbol = "\u{f01e}"
            // Heavy rain
        case 1195 : symbol = "\u{f01e}"
            // Torrential rain shower
        case 1246 : symbol = "\u{f01e}"
            // Moderate or heavy rain in area with thunder
        case 1276 : symbol = "\u{f01e}"
        
        // Snow
            // Patchy snow nearby
        case 1066 : symbol = "\u{f01b}"
            // Patchy sleet nearby
        case 1069 : symbol = "\u{f01b}"
            // Patchy freezing drizzle nearby
        case 1072 : symbol = "\u{f01b}"
            // Blowing snow
        case 1114  : symbol = "\u{f01b}"
            // Blizzard
        case 1117 : symbol = "\u{f01b}"
            // Patchy light snow in area with thunder
        case 1279 : symbol = "\u{f01b}"
            // Moderate or heavy snow in area with thunder
        case 1282 : symbol = "\u{f01b}"
            // Freezing drizzle
        case 1168 : symbol = "\u{f01b}"
            // Heavy freezing drizzle
        case 1171 : symbol = "\u{f01b}"
            // Light freezing rain
        case 1198 : symbol = "\u{f01b}"
            // Moderate or heavy freezing rain
        case 1201 : symbol = "\u{f01b}"
            // Light sleet
        case 1204 : symbol = "\u{f01b}"
            // Moderate or heavy sleet
        case 1207 : symbol = "\u{f01b}"
            // Patchy light snow
        case 1210 : symbol = "\u{f01b}"
            // Light snow
        case 1213 : symbol = "\u{f01b}"
            // Patchy moderate snow
        case 1216 : symbol = "\u{f01b}"
            // Moderate snow
        case 1219 : symbol = "\u{f01b}"
            // Patchy heavy snow
        case 1222 : symbol = "\u{f01b}"
            // Heavy snow
        case 1225 : symbol = "\u{f01b}"
            // Ice pellets
        case 1237 : symbol = "\u{f01b}"
            // Light sleet showers
        case 1249 : symbol = "\u{f01b}"
            // Moderate or heavy sleet showers
        case 1252 : symbol = "\u{f01b}"
            //Light snow showers
        case 1255 : symbol = "\u{f01b}"
            // Moderate or heavy snow showers
        case 1258 : symbol = "\u{f01b}"
            // Light showers of ice pellets
        case 1261 : symbol = "\u{f01b}"
            //Moderate or heavy showers of ice pellets
        case 1264 : symbol = "\u{f01b}"
        
        // N/A
        default : symbol = "\u{f07b}"
        }
        return symbol
    }
}
