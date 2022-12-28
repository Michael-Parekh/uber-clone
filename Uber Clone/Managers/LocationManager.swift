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
    // Identical to how an environment object works, we need to create a shared instance of this 'LocationManager' so that it can be used across multiple surfaces in the app.
    static let shared = LocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        // Gives us the most accurate location possible for the given user.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // This function updates the user's location in the app.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.userLocation = location.coordinate
        // The purpose of the 'LocationManager' is to request permissions from the user and get their location one time, before our 'mapView' handles the rest of the location updates (this application does not require constant pinging of location as that is inefficient).
        locationManager.stopUpdatingLocation()
    }
}
