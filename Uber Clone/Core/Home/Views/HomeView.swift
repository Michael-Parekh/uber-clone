//
//  HomeView.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/18/22.
//

import SwiftUI

// The 'HomeView' will be very complex. To keep scalability in mind, extract functionality to as many sub-views as possible. 
struct HomeView: View {
    
    // We need to add a tap gesture to the 'LocationSearchActivationView'. This boolean property will determine whether or not that view is shown.
    @State private var showLocationSearchView = false
    
    var body: some View {
        // Utilize a Z-Stack to place the 'LocationSearchActivationView' search bar on top of the map view.
        ZStack(alignment: .top) {
            UberMapViewRepresentable()
                .ignoresSafeArea()
            
            // Presentation logic on which view to show based on the 'showLocationSearchView' state (when the state changes, the view redraws itself).
            if showLocationSearchView {
                LocationSearchView(showLocationSearchView: $showLocationSearchView)
            } else {
                LocationSearchActivationView()
                    .padding(.top, 72)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showLocationSearchView.toggle()
                        }
                    }
            }
            
            // Because 'showLocationSearchView' is a binding variable in the 'MapViewActionButton', whenever it changes the state will change here as well (properties are bound together).
            MapViewActionButton(showLocationSearchView: $showLocationSearchView)
                .padding(.leading)
                .padding(.top, 4)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
