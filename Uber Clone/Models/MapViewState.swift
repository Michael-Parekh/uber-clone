//
//  MapViewState.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/24/22.
//

import Foundation

// The map view is complex and has many potential states. We need to create an enumeration to help manage the map view state and update the user interface accordingly.
// The benefit of using an enumeration over many different boolean properties is that it keeps flexibility/scalability in mind (it will let us know what needs to be updated when cases are added/removed). 
enum MapViewState {
    case noInput
    case searchingForLocation
    case locationSelected
}
