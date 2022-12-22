//
//  LocationSearchView.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/21/22.
//

import SwiftUI

struct LocationSearchView: View {
    
    @State private var startLocationText = ""
    @State private var destinationLocationText = ""
    @StateObject var viewModel = LocationSearchViewModel()
    
    var body: some View {
        VStack {
            // H-Stack for the header view (start/destination text inputs).
            HStack {
                // Indicator icons for start/destination.
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                }
                
                // Text input fields in the header.
                VStack {
                    TextField("Current location", text: $startLocationText)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    
                    // Provide the 'LocationSearchViewModel' with the query fragment (so that we can get autocomplete results).
                    TextField("Where to?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            
            // 'ScrollView' for the list view (list of potential addresses).
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { result in
                        // Pass in dynamic address data for the 'LocationSearchResultCell' view.
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                    }
                }
            }
        }
        .background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
    }
}
