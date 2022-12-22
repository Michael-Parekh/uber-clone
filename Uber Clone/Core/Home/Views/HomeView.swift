//
//  HomeView.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/18/22.
//

import SwiftUI

// The 'HomeView' will be very complex. To keep scalability in mind, extract functionality to as many sub-views as possible. 
struct HomeView: View {
    var body: some View {
        // Utilize a Z-Stack to place the 'LocationSearchActivationView' search bar on top of the map view.
        ZStack(alignment: .top) {
            UberMapViewRepresentable()
                .ignoresSafeArea()
            
            LocationSearchActivationView()
                .padding(.top, 72)
            
            MapViewActionButton()
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
