//
//  ViewController.swift
//  JojangWeather
//
//  Created by Joseph Zhang on 10/4/16.
//  Copyright © 2016 Joseph Zhang. All rights reserved.
//

import Cocoa
import CoreLocation

class ViewController: NSViewController, CLLocationManagerDelegate {
    let country:String = "USA"
    var requestLocationServicesAlert: NSAlert!
    lazy var geocoder = CLGeocoder()
    var locationManager = CLLocationManager()
    var city: CurrentCity!
    var cityFound = false
    
    @IBOutlet weak var cityTextField: NSTextField!
    
    @IBOutlet weak var cityLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        city = CurrentCity(longitude: 0, latitude: 0, cityName: "ha")
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
        }
    }

    
    @IBAction func updateWeather(_ sender: Any) {
        print("ay")
        retrieveData(cityId: "4887398")
        print("lmao")
    }
    
    
    // Tries to use location services to retrieve the latitue and longitude of the current position
    @IBAction func autoSetLocation(_ sender: Any) {
        var currentLocation: CLLocation!
        
        // Check if user granted allowed access
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            
            // Update get user's location
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
            currentLocation = locationManager.location
            
            city = CurrentCity(longitude: currentLocation.coordinate.longitude, latitude: currentLocation.coordinate.latitude, cityName: "Chicago")
            var cityId: String!
            
            do{
                try cityId = city.lookUpCityId()
            }catch CityNotFound.cityNotInList {
                print("not found")
            }catch {
                print("other")
            }
            
            print(cityId)
        }
            
        else{
            requestLocationServicesAlert = NSAlert()
            requestLocationServicesAlert.messageText = "Need location services"
            requestLocationServicesAlert.informativeText = "Please enable location services so the current location can be automatically looked up."
            requestLocationServicesAlert.runModal()
        }
        
    }
    
    
    @IBAction func handleCity(_ sender: AnyObject) {
        //cityLabel.stringValue = cityTextField.stringValue
        
        let locationData = cityTextField.stringValue.components(separatedBy: ",")
        
        
        let city: String = locationData[0]
        let state: String = locationData[1]
        
        let address = "\(country), \(state), \(city)"
        
        
        // Geocode Address String
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        cityLabel?.font = NSFont(name: "Weather Icons", size: 16)
        cityLabel.stringValue = "\u{f029}"
        
    }
    
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        //geocodeButton.isHidden = false
        //activityIndicatorView.stopAnimating()
        
        if (error != nil) {
            //print("Unable to Forward Geocode Address (\(error))")
            cityLabel.stringValue = "Unable to Find Location for Address"
            
        } else {
            print("hi")
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                cityLabel.stringValue = "\(coordinate.latitude), \(coordinate.longitude)"
            } else {
                cityLabel.stringValue = "No Matching Location Found"
            }
        }
        
    }
    
    func retrieveData(cityId: String){
        let urlString = "http://api.openweathermap.org/data/2.5/forecast?id=4887398&APPID=5b9d4a06a07a8a29f234cb9dd91cb2c4"
        
    
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

    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }*/

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}

