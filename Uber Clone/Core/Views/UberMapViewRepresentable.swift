//
//  UberMapViewRepresentable.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/18/22.
//

import SwiftUI
import MapKit

// A UIViewRepresentable is a wrapper for a UIKit view that you use to integrate that view into your SwiftUI view hierarchy.
// Because we need complex map functionality like annotations and routes, we need to use UIKit's map (instead of SwiftUI's).

struct UberMapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    let locationManager = LocationManager()
    
    // Configure the MapView.
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    // This function is in charge of updating the view when we want to do something (e.g. draw a polyline when the user selects a location).
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    // Return a custom 'MapCoordinator' object that we created.
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}


extension UberMapViewRepresentable {
    
    // We can conform to the 'MKMapViewDelegate' protocol that has all of the functions we need in order to perform the complex operations in our map view (this custom coordinator allows us to pull in functionality from UIKit).
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewRepresentable
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        // Tells the delegate that the location of the user was changed/updated.
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            // 'span' is the zoom that we want to perform on the given 'center'.
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            parent.mapView.setRegion(region, animated: true)
        }
    }
}
