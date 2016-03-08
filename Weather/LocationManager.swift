//
//  LocationManager.swift
//  eBayWeather
//
//  Created by Adnan Aftab on 2/26/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func locationDidUpdate(service: LocationManager, location: CLLocation)
}
/**
 * This location manager class, which update other class about user location via delegate method
 * We can also do Notification for information
 */
class LocationManager : NSObject {

    var delegate : LocationManagerDelegate?
    lazy var coreLocationManager =  CLLocationManager()

    override init() {
        super.init()
        coreLocationManager.delegate = self
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestLocation() {
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.requestLocation()
    }

}
extension LocationManager : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            print("Current location: \(location)")
            delegate?.locationDidUpdate(self, location: location);
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
}