//
//  UberLocation.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/28/22.
//

import CoreLocation

// Create a custom data model so that we have access to the name of the destination in the 'RideRequestView'.
struct UberLocation {
    // THe name of the given location (e.g. "Starbucks").
    let title: String
    let coordinate: CLLocationCoordinate2D
}
