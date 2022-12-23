//
//  LocationSearchViewModel.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/22/22.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    // 'MKLocalSearchCompletion' is a fully formed address string that completes a partial address string.
    // @Published is one of the property wrappers in SwiftUI that allows us to trigger a view redraw whenever changes occur.
    @Published var results = [MKLocalSearchCompletion]()
    // Because there is no selected location initially, make it optional. If the user selects something, populate the property.
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        // Everytime we set the 'queryFragment' (everytime the input text field changes), execute this code.
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    // MARK: - Helpers
    
    // This helper function will enable us to select/set a location in the actual 'LocationSearchView'.
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location search failed with error \(error.localizedDescription)")
                return
            }
            
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            self.selectedLocationCoordinate = coordinate
            
            print("DEBUG: Location coordinates \(coordinate)")
        }
    }
    
    // 'MKLocalSearchCompletion' does not give coordinate data - it only contains the address string. So, we need to search for it and generate a real location object.
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        // Search using the full address.
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        // Because the search takes time, it utilizes a completion handler / callback.
        search.start(completionHandler: completion)
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    // A search is executed based on the given query fragment. Once it completes, it calls this function.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
