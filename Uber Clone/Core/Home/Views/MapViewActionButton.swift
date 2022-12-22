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
    @Binding var showLocationSearchView: Bool
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                showLocationSearchView.toggle()
            }
        } label: {
            // When we are showing the 'LocationSearchView', the button will be a left arrow - otherwise, it will be a menu icon.
            Image(systemName: showLocationSearchView ? "arrow.left" : "line.3.horizontal")
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
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(showLocationSearchView: .constant(true))
    }
}
