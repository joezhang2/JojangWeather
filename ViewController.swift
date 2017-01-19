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
    
    var statusBar = NSStatusBar.system()
    var statusBarItem : NSStatusItem = NSStatusItem()
    
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
    @IBOutlet weak var dataTable: NSScrollView!
    @IBOutlet weak var headerView: NSTableHeaderView!
    
    
    @IBOutlet weak var unit1: NSTableColumn!
    
    var forecastData = Forecast()

    override func awakeFromNib() {
        //Add statusBarItem
        statusBarItem = statusBar.statusItem(withLength: -1)
        statusBarItem.title = "n/a"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
        }
        userSetLocation(self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsColumnSelection = false
        tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyle.none
        self.tableView.reloadData()
        
    }
    
    @IBAction func updateDailyForecast(_ sender: Any) {
        semaphore.wait()
        if !cityFound{
            let title = "Missing location data"
            let message = "Please enter a location or automatically get the location"
            displayErrorMessage(title: title, message: message)
        }
        else{
            print("ay daily")
            do{
                try forecastData.updateForecast(curLocation: currentLocation, cityName: cityLabel.stringValue.components(separatedBy: ",")[0], daily: true)
            }
            catch{
                let title = "Error getting forecast"
                let message = "Something went wrong :("
                displayErrorMessage(title: title, message: message)
            }
            print("lmao")
            tableView.reloadData()
        }
        semaphore.signal()
    }
    
    @IBAction func updateHourlyForecast(_ sender: Any) {
        semaphore.wait()
        if !cityFound{
            let title = "Missing location data"
            let message = "Please enter a location or automatically get the location"
            displayErrorMessage(title: title, message: message)
        }
        else{
            print("ay hourly")
            do{
                try forecastData.updateForecast(curLocation: currentLocation, cityName: cityLabel.stringValue.components(separatedBy: ",")[0])
            }
            catch{
                let title = "Error getting forecast"
                let message = "Something went wrong :("
                displayErrorMessage(title: title, message: message)
            }
            print("lmao")
            tableView.reloadData()
        }
        semaphore.signal()
        
    }
    
    
    // Tries to use location services to retrieve the latitue and longitude of the current position
    @IBAction func autoSetLocation(_ sender: Any) {
        // Check if user granted allowed access
        semaphore.wait()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            // Update get user's location
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
            currentLocation = locationManager.location
            
            lookUpCityAndState(location: currentLocation)
            //print(currentLocation.coordinate.longitude, currentLocation.coordinate.latitude)
        }
        else{
            let title = "Need location services"
            let message = "Please enable location services so the current location can be automatically looked up."
            displayErrorMessage(title: title, message: message)
        }
        semaphore.signal()
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
    
    
    func displayErrorMessage(title: String, message: String){
        cityFound = false
        
        requestLocationServicesAlert.messageText = title
        requestLocationServicesAlert.informativeText = message
        requestLocationServicesAlert.runModal()
    }
    
    @IBAction func userSetLocation(_ sender: AnyObject) {
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
            print(self.currentLocation.coordinate.longitude, self.currentLocation.coordinate.latitude)
        }

        semaphore.signal()
    }
    
    
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
    
   
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        var text = ""
        
        for index in 0 ... tableView.tableColumns.count-1{
            if tableColumn == tableView.tableColumns[index]{
                if row == 0{
                    text = forecastData.fiveTimeUnitsForecast[index].time
                }
                else if row == 1{
                    text = forecastData.fiveTimeUnitsForecast[index].temperature
                }
                else{
                    //view.textField?.font = NSFont(name: "Weather Icons", size: 16)
                    //view.textField?.stringValue = forecastData.fiveTimeUnitsForecast[index].weatherCondition
                    //return view
                    //cityLabel?.font = NSFont(name: "Weather Icons", size: 16)
                    //cityLabel.stringValue = "strong-wind" //"\u{f029}"
                    text = forecastData.fiveTimeUnitsForecast[index].weatherCondition

                }
            }
        }
        return text
    }
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    // Status bar
    
}
