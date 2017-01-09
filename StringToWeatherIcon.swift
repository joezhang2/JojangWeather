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
            
        /*
        case "day200": symbol = "\u{f010}"
        case "day201": symbol = "\u{f010}"
        case "day202": symbol = "\u{f010}"
        case "day210": symbol = "\u{f005}"
        case "day211": symbol = "\u{f005}"
        case "day212": symbol = "\u{f005}"
        case "day221": symbol = "\u{f005}"
        case "day230": symbol = "\u{f010}"
        case "day231": symbol = "\u{f010}"
        case "day232": symbol = "\u{f010}"
        case "day300": symbol = "\u{f00b}"
        case "day301": symbol = "\u{f00b}"
        case "day302": symbol = "\u{f008}"
        case "day310": symbol = "\u{f008}"
        case "day311": symbol = "\u{f008}"
        case "day312": symbol = "\u{f008}"
        case "day313": symbol = "\u{f008}"
        case "day314": symbol = "\u{f008}"
        case "day321": symbol = "\u{f00b}"
        case "day500": symbol = "\u{f00b}"
        case "day501": symbol = "\u{f008}"
        case "day502": symbol = "\u{f008}"
        case "day503": symbol = "\u{f008}"
        case "day504": symbol = "\u{f008}"
        case "day511": symbol = "\u{f006}"
        case "day520": symbol = "\u{f009}"
        case "day521": symbol = "\u{f009}"
        case "day522": symbol = "\u{f009}"
        case "day531": symbol = "\u{f00e}"
        case "day600": symbol = "\u{f00a}"
        case "day601": symbol = "\u{f0b2}"
        case "day602": symbol = "\u{f00a}"
        case "day611": symbol = "\u{f006}"
        case "day612": symbol = "\u{f006}"
        case "day615": symbol = "\u{f006}"
        case "day616": symbol = "\u{f006}"
        case "day620": symbol = "\u{f006}"
        case "day621": symbol = "\u{f00a}"
        case "day622": symbol = "\u{f00a}"
        case "day701": symbol = "\u{f009}"
        case "day711": symbol = "\u{f062}"
        case "day721": symbol = "\u{f0b6}"
        case "day731": symbol = "\u{f063}"
        case "day741": symbol = "\u{f003}"
        case "day761": symbol = "\u{f063}"
        case "day762": symbol = "\u{f063}"
        case "day781": symbol = "\u{f056}"
        case "day800": symbol = "\u{f00d}"
        case "day801": symbol = "\u{f000}"
        case "day802": symbol = "\u{f000}"
        case "day803": symbol = "\u{f000}"
        case "day804": symbol = "\u{f00c}"
        case "day900": symbol = "\u{f056}"
        case "day902": symbol = "\u{f073}"
        case "day903": symbol = "\u{f076}"
        case "day904": symbol = "\u{f072}"
        case "day906": symbol = "\u{f004}"
        case "day957": symbol = "\u{f050}"
            
        case "night200": symbol = "\u{f02d}"
        case "night201": symbol = "\u{f02d}"
        case "night202": symbol = "\u{f02d}"
        case "night210": symbol = "\u{f025}"
        case "night211": symbol = "\u{f025}"
        case "night212": symbol = "\u{f025}"
        case "night221": symbol = "\u{f025}"
        case "night230": symbol = "\u{f02d}"
        case "night231": symbol = "\u{f02d}"
        case "night232": symbol = "\u{f02d}"
        case "night300": symbol = "\u{f02b}"
        case "night301": symbol = "\u{f02b}"
        case "night302": symbol = "\u{f028}"
        case "night310": symbol = "\u{f028}"
        case "night311": symbol = "\u{f028}"
        case "night312": symbol = "\u{f028}"
        case "night313": symbol = "\u{f028}"
        case "night314": symbol = "\u{f028}"
        case "night321": symbol = "\u{f02b}"
        case "night500": symbol = "\u{f02b}"
        case "night501": symbol = "\u{f028}"
        case "night502": symbol = "\u{f028}"
        case "night503": symbol = "\u{f028}"
        case "night504": symbol = "\u{f028}"
        case "night511": symbol = "\u{f026}"
        case "night520": symbol = "\u{f029}"
        case "night521": symbol = "\u{f029}"
        case "night522": symbol = "\u{f029}"
        case "night531": symbol = "\u{f02c}"
        case "night600": symbol = "\u{f02a}"
        case "night601": symbol = "\u{f0b4}"
        case "night602": symbol = "\u{f02a}"
        case "night611": symbol = "\u{f026}"
        case "night612": symbol = "\u{f026}"
        case "night615": symbol = "\u{f026}"
        case "night616": symbol = "\u{f026}"
        case "night620": symbol = "\u{f026}"
        case "night621": symbol = "\u{f02a}"
        case "night622": symbol = "\u{f02a}"
        case "night701": symbol = "\u{f029}"
        case "night711": symbol = "\u{f062}"
        case "night721": symbol = "\u{f0b6}"
        case "night731": symbol = "\u{f063}"
        case "night741": symbol = "\u{f04a}"
        case "night761": symbol = "\u{f063}"
        case "night762": symbol = "\u{f063}"
        case "night781": symbol = "\u{f056}"
        case "night800": symbol = "\u{f02e}"
        case "night801": symbol = "\u{f022}"
        case "night802": symbol = "\u{f022}"
        case "night803": symbol = "\u{f022}"
        case "night804": symbol = "\u{f086}"
        case "night900": symbol = "\u{f056}"
        case "night902": symbol = "\u{f073}"
        case "night903": symbol = "\u{f076}"
        case "night904": symbol = "\u{f072}"
        case "night906": symbol = "\u{f024}"
        default: symbol = "\u{f050}"
        */
        }
        return symbol
    }
}
