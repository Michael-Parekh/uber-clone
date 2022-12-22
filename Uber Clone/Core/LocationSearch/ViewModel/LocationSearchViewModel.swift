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
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        // Everytime we set the 'queryFragment' (everytime the input text field changes), execute this code.
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    // A search is executed based on the given query fragment. Once it completes, it calls this function.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
