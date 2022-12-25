//
//  HomeView.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/18/22.
//

import SwiftUI

// The 'HomeView' will be very complex. To keep scalability in mind, extract functionality to as many sub-views as possible. 
struct HomeView: View {
    
    // We need to add a tap gesture to the 'LocationSearchActivationView'. This map state property will determine whether or not that view is shown (defaulted to 'noInput').
    @State private var mapState = MapViewState.noInput
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Utilize a Z-Stack to place the 'LocationSearchActivationView' search bar on top of the map view.
            ZStack(alignment: .top) {
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                // Presentation logic on which view to show based on the map view state (when the state changes, the view redraws itself).
                if mapState == MapViewState.searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                } else if mapState == MapViewState.noInput {
                    LocationSearchActivationView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .searchingForLocation
                            }
                        }
                }
                
                // Because 'showLocationSearchView' is a binding variable in the 'MapViewActionButton', whenever it changes the state will change here as well (properties are bound together).
                MapViewActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top, 4)
            }
            
            // This ZStack is where we present the ride request view at the bottom of the screen.
            if mapState == .locationSelected {
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
