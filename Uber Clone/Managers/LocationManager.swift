//
//  LocationManager.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/18/22.
//

import CoreLocation

// Requests the user's current location.
// 'Info.plist' also needs to be updated to explain to the user why their location data is being used ('NSLocationWhenInUseUsageDescription').
class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        // Gives us the most accurate location possible for the given user.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// We need to set up delegate functions.
extension LocationManager: CLLocationManagerDelegate {
    // This function updates the user's location in the app.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
        locationManager.stopUpdatingLocation()
    }
}
