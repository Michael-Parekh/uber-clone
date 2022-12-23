//
//  Uber_CloneApp.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/18/22.
//

import SwiftUI

@main
struct Uber_CloneApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            // 'environmentObject' will allow us to utilize a singular instance of the view model across multiple places in the app ('UberMapViewRepresentable' and 'LocationSearchView').
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
