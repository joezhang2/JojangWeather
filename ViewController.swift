//
//  ViewController.swift
//  JojangWeather
//
//  Created by Joseph Zhang on 10/4/16.
//  Copyright © 2016 Joseph Zhang. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    
    @IBOutlet weak var locationLabel: NSTextFieldCell!
    
    @IBOutlet weak var locationValue: NSTextField!
    
    @IBAction func locationSetButton(_ sender: Any) {
        locationLabel.stringValue = locationValue.stringValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

