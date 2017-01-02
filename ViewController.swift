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
    var requestLocationServicesAlert = NSAlert()
    lazy var geocoder = CLGeocoder()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var cityFound = false
    
    @IBOutlet weak var cityTextField: NSTextField!
    
    @IBOutlet weak var cityLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
        }
    }

    @IBAction func updateWeather(_ sender: Any) {
        print("ay")
        
        print("lmao")
    }
    
    
    // Tries to use location services to retrieve the latitue and longitude of the current position
    @IBAction func autoSetLocation(_ sender: Any) {
        // Check if user granted allowed access
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            // Update get user's location
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
            currentLocation = locationManager.location
            
            lookUpCityAndState(location: currentLocation)
            print(currentLocation.coordinate.longitude, currentLocation.coordinate.latitude)
        }
        else{
            let title = "Need location services"
            let message = "Please enable location services so the current location can be automatically looked up."
            displayErrorMessage(title: title, message: message)
        }
    }
    
    
    func lookUpCityAndState(location: CLLocation){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                let title = "Failed to lookup"
                let message = "Reverse geocoder failed with error: \(error?.localizedDescription)"
                self.displayErrorMessage(title: title, message: message)
            }
            if let pm = placemarks{
                let curLocation = pm[0]
                self.cityLabel.stringValue = "\(curLocation.locality!), \(curLocation.administrativeArea!)"
                self.cityFound = true
            }
            else {
                let title = "Error"
                let message = "Problem with the data received from geocoder"
                self.displayErrorMessage(title: title, message: message)
            }
        })
    }
    
    
    func displayErrorMessage(title: String, message: String){
        cityFound = false
        
        requestLocationServicesAlert.messageText = title
        requestLocationServicesAlert.informativeText = message
        requestLocationServicesAlert.runModal()
    }
    
    @IBAction func handleCity(_ sender: AnyObject) {
        //cityLabel.stringValue = cityTextField.stringValue
        
        let locationData = cityTextField.stringValue.components(separatedBy: ",")
        
        if locationData.count != 2{
            let title = "Wrong format"
            let message = "Enter (City name), (State initials)"
            displayErrorMessage(title: title, message: message)
        }
        
        let city: String = locationData[0]
        let state: String = locationData[1]
        
        let address = "\(country), \(state), \(city)"
        
        // Geocode Address String
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
            print(self.currentLocation.coordinate.longitude, self.currentLocation.coordinate.latitude)
        }
        
        //
        //cityLabel?.font = NSFont(name: "Weather Icons", size: 16)
        //cityLabel.stringValue = "\u{f029}"
        
    }
    
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if (error != nil) {
            //print("Unable to Forward Geocode Address (\(error))")
            let title = "Unable to find coordinates for address"
            let message = "City and or state is not found"
            displayErrorMessage(title: title, message: message)
        }
        else {
            /*if let placemarks = placemarks, placemarks.count > 0 {
                currentLocation = placemarks[0].location
                print(currentLocation.coordinate)
            }
            else {
                let title = "No placemarks on map"
                let message = "Need to pin a spot on map first"
                displayErrorMessage(title: title, message: message)
            }*/
            if let location = placemarks?[0].location {
                let coordinate = location.coordinate
                currentLocation = location
                cityLabel.stringValue = "\(coordinate.latitude), \(coordinate.longitude)"
                cityFound = true
                
            } else {
                let title = "Unable to find coordinates for address"
                let message = "No data on location"
                displayErrorMessage(title: title, message: message)
            }
        }
        
    }
    
    func retrieveData(){
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

