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
}
