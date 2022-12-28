//
//  MapViewActionButton.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/21/22.
//

import SwiftUI

struct MapViewActionButton: View {
    
    // Add a binding variable (https://developer.apple.com/documentation/swiftui/binding) to change the state of the button based on the user actions.
    // This is a binding property - everytime we initialize the view, we need to pass in the boolean to determine what to show.
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        // Align to the leading (left) edge using 'frame'.
    }
    
    // We need to create a separate function for the button because it performs a different action based on which screen the user is currently at.
    func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
            print("DEBUG: No input")
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected, .polylineAdded:
            // If the user hits the button on the location selected screen, go back to the home view (default 'noInput' state).
            mapState = .noInput
            // Everytime we exit the 'locationSelected' state, we wipe out the previous location so that we do not draw a polyline to it as well. 
            viewModel.selectedUberLocation = nil
        }
    }
    
    // When we are showing the 'LocationSearchView', the button will be a left arrow - otherwise, it will be a menu icon.
    func imageNameForState(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected, .polylineAdded:
            return "arrow.left"
        default:
            return "line.3.horizontal"
        }
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput))
    }
}
