//
//  ViewController.swift
//  JojangWeather
//
//  Created by Joseph Zhang on 10/4/16.
//  Copyright © 2016 Joseph Zhang. All rights reserved.
//

import Cocoa
import CoreLocation

class ViewController: NSViewController, CLLocationManagerDelegate, NSTableViewDelegate, NSTableViewDataSource{
    
    var requestLocationServicesAlert = NSAlert()
    lazy var geocoder = CLGeocoder()
    var locationManager = CLLocationManager()
    
    let country = "USA"
    let numberRows = 3
    
    var currentLocation: CLLocation!
    var cityFound = false
    var semaphore = DispatchSemaphore(value: 1)
    
    
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var cityLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    var forecastData = Forecast()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prompt user for location services during the first time app is used. If denied
        //  the user will have to change the permissions on their own.
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
        }
        
        // Determine the user's location automatically
        userSetLocation(self)
        
        // Initialize table with dummy data
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsColumnSelection = false
        tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyle.none
        self.tableView.reloadData()
    }
    
    @IBAction func updateDailyForecast(_ sender: Any) {
        // Use semaphore as data may not come immediately to prevent the user from
        //  updating the hourly forecast before the daily forecast has finished
        semaphore.wait()
        if !cityFound{
            let title = "Missing location data"
            let message = "Please enter a location or automatically get the location"
            displayErrorMessage(title: title, message: message)
        }
        else{
            do{
                try forecastData.updateForecast(curLocation: currentLocation, cityName: cityLabel.stringValue.components(separatedBy: ",")[0], daily: true)
            }
            catch{
                let title = "Error getting forecast"
                let message = "Something went wrong :("
                displayErrorMessage(title: title, message: message)
            }
            tableView.reloadData()
        }
        semaphore.signal()
    }
    
    @IBAction func updateHourlyForecast(_ sender: Any) {
        // Use semaphore as data may not come immediately to prevent the user from
        //  updating the daily forecast before the hourly forecast has finished
        semaphore.wait()
        if !cityFound{
            let title = "Missing location data"
            let message = "Please enter a location or automatically get the location"
            displayErrorMessage(title: title, message: message)
        }
        else{
            do{
                try forecastData.updateForecast(curLocation: currentLocation, cityName: cityLabel.stringValue.components(separatedBy: ",")[0])
            }
            catch{
                let title = "Error getting forecast"
                let message = "Something went wrong :("
                displayErrorMessage(title: title, message: message)
            }
            tableView.reloadData()
        }
        semaphore.signal()
        
    }
    
    // Use location services to retrieve geographic coordinates and city and state of
    //  current location
    @IBAction func autoSetLocation(_ sender: Any) {
        // Check if user granted allowed access
        
        // lookUpCityAndState runs asynchronously, so need to wait for it to finish
        semaphore.wait()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            // Update get user's location
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
            currentLocation = locationManager.location
            
            lookUpCityAndState(location: currentLocation)
        }
        else{
            let title = "Need location services"
            let message = "Please enable location services so the current location can be automatically looked up."
            displayErrorMessage(title: title, message: message)
        }
        semaphore.signal()
    }
    
    // User the macOS geocoder to get the city and state using the location manager
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
                // Update manaual set location field for clarity
                self.cityTextField.stringValue = self.cityLabel.stringValue
                self.cityFound = true
            }
            else {
                let title = "Error"
                let message = "Problem with the data received from geocoder"
                self.displayErrorMessage(title: title, message: message)
            }
        })
    }
    
    // Helper function to display an error message
    func displayErrorMessage(title: String, message: String){
        // Sets the city found flag to false
        cityFound = false
        
        requestLocationServicesAlert.messageText = title
        requestLocationServicesAlert.informativeText = message
        requestLocationServicesAlert.runModal()
    }
    
    // Take data the user entered to get geographic coordinates for the weather
    @IBAction func userSetLocation(_ sender: AnyObject) {
        // lookUpCityAndState runs asynchronously, so need to wait for it to finish
        semaphore.wait()
        cityLabel.stringValue = cityTextField.stringValue
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
            //print(self.currentLocation.coordinate.longitude, self.currentLocation.coordinate.latitude)
        }

        semaphore.signal()
    }
    
    // Helper function for the reverse geocode lookup
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if (error != nil) {
            //print("Unable to Forward Geocode Address (\(error))")
            let title = "Unable to find coordinates for address"
            let message = "City and or state is not found"
            displayErrorMessage(title: title, message: message)
        }
        else {
            if let location = placemarks?[0].location {
                currentLocation = location
                cityFound = true
                
            } else {
                let title = "Unable to find coordinates for address"
                let message = "No data on location"
                displayErrorMessage(title: title, message: message)
            }
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return numberRows
    }
    
    // Load table with data
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        var text = ""
        
        for index in 0 ... tableView.tableColumns.count-1{
            if tableColumn == tableView.tableColumns[index]{
                // Row for the time: hourly or daily
                if row == 0{
                    text = forecastData.fiveTimeUnitsForecast[index].time
                }
                // Row for the forecasted temperature
                else if row == 1{
                    text = forecastData.fiveTimeUnitsForecast[index].temperature
                }
                // Row for the weather condition
                else{
                    text = forecastData.fiveTimeUnitsForecast[index].weatherCondition
                }
            }
        }
        return text
    }
}
