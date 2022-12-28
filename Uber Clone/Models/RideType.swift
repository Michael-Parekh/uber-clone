//
//  RideType.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/25/22.
//

import Foundation

// Utilize a data model to represent the different ride options (e.g. UberX) and make the UI dynamic.
// Using an enumeration wraps all of the values we need into one structure, thereby improving scalability (if we add/remove values, we will get an error everywhere that needs to be updated).
enum RideType: Int, CaseIterable, Identifiable {
    // The 'CaseIterable' protocol enables us to wrap all of the cases into an array (so that we can loop through it later).
    case uberX
    case black
    case uberXL
    
    var id: Int { return rawValue }
    
    var description: String {
        switch self {
        case .uberX: return "UberX"
        case .black: return "UberBlack"
        case .uberXL: return "UberXL"
        }
    }
    
    var imageName: String {
        switch self {
        case .uberX: return "uber-x"
        case .black: return "uber-black"
        case .uberXL: return "uber-x"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .uberX: return 5
        case .black: return 20
        case .uberXL: return 10
        }
    }
    
    // The only two place where we have access to the user location in the app are the 'LocationManager' and 'UberMapViewRepresentable'. However, we do not want to publish any values from the 'UberMapViewRepresentable' (its purpose is to mainly listen for updates, not update anything).
    func computePrice(for distanceInMeters: Double) -> Double {
        let distanceInMiles = distanceInMeters / 1600
        
        switch self {
        case .uberX: return distanceInMiles * 1.5 + baseFare
        case .black: return distanceInMiles * 2.0 + baseFare
        case .uberXL: return distanceInMiles * 1.75 + baseFare
        }
    }
}
