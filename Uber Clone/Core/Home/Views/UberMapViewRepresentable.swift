//
//  UberMapViewRepresentable.swift
//  Uber Clone
//
//  Created by Michael Parekh on 12/18/22.
//

import SwiftUI
import MapKit

// A 'UIViewRepresentable' is a wrapper for a UIKit view that you use to integrate that view into your SwiftUI view hierarchy.
// Because we need complex map functionality like annotations and routes, we need to use UIKit's map (instead of SwiftUI's).
struct UberMapViewRepresentable: UIViewRepresentable {
    let mapView = MKMapView()
    let locationManager = LocationManager()
    // We need a 'StateObject' that will allow us to observe changes on the view model. Whenever the 'selectedLocation' property gets populated, the 'updateUIView' function will get triggered.
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    // Configure the MapView.
    func makeUIView(context: Context) -> some UIView {
        // The 'UberMapViewRepresentable' protocol does not know about the map view delegate (all of that is handled through the coordinator).
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    // This function is in charge of updating the view when we want to do something (e.g. draw a polyline when the user selects a location).
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Convert the 'selectedLocation' string to a location object. In order to generate annotations on our map, we need more data.
        if let coordinate = locationViewModel.selectedLocationCoordinate {
            context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
            context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
        }
    }
    
    // Return a custom 'MapCoordinator' object that we created.
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}


extension UberMapViewRepresentable {
    // We can conform to the 'MKMapViewDelegate' protocol, which has all of the functions we need in order to perform the complex operations in our map view (this custom coordinator allows us to pull in functionality from UIKit).
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        // MARK: - Properties
        
        let parent: UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        
        // MARK: - Lifecycle
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        // MARK: - MKMapViewDelegate
        
        // Tells the delegate that the location of the user was changed/updated.
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            // 'span' is the zoom that we want to perform on the given 'center'.
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            parent.mapView.setRegion(region, animated: true)
        }
        
        // Delegate method that is needed to tell the map view how to draw the overlay.
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        // MARK: - Helpers
        
        // This function will help us add a destination annotation to the map when a location is selected.
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            // Remove the previous annotations from the map view.
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            // Makes the pin larger.
            parent.mapView.selectAnnotation(anno, animated: true)
            
            // Adjust the region of the map view to include both the current location and destination annotation.
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        // This helper function will help us configure the polyline using the destination route.
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            
            getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
            }
        }
        
        // Get the user's route from the current location to the destination. This route will be used to generate a polyline.
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                                 to destination: CLLocationCoordinate2D,
                                 completion: @escaping(MKRoute) -> Void) {
            let userPlacemark = MKPlacemark(coordinate: userLocation)
            let destPlacemark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destPlacemark)
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                if let error = error {
                    print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                    return
                }
                
                // Get the first possible route because it is usually the fastest.
                guard let route = response?.routes.first else { return }
                completion(route)
            }
        }
    }
}
