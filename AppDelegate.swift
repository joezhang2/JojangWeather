//
//  AppDelegate.swift
//  JojangWeather
//
//  Created by Joseph Zhang on 10/4/16.
//  Copyright © 2016 Joseph Zhang. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var mainWindow: NSWindow!
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Save a reference to the controller window with buttons and data
        // First element in the array is the dialog prompting for location services, so
        //  save the second element as the main window
        mainWindow = NSApplication.shared().windows[1]
    }
    
    // In case the user presses the "x-button", by clicking on the icon in the dock, the
    //  can restore the application
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag{
            mainWindow.makeKeyAndOrderFront(nil)
        }
        
        return true
    }
}
