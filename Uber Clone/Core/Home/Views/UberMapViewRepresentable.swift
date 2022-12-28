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
    // Do NOT publish values from this structure because it will cause a retain cycle. For example, if we update a property on the 'locationViewModel' (which we are also observing), it would trigger the listener in this structure and cause an endless cycle.
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    @Binding var mapState: MapViewState
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
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            // If a location is selected, convert the 'selectedLocation' string to a location object. In order to generate annotations on our map, we need more data.
            if let coordinate = locationViewModel.selectedUberLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
            break
        case .polylineAdded:
            // Do not do anything in the 'polylineAdded' state (so that we do not keep adding the annotation to the map once the polyline is already drawn).
            break
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
        var currentRegion: MKCoordinateRegion?
        
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
            
            self.currentRegion = region
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
        }
        
        // This helper function will help us configure the polyline using the destination route.
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate,
                                                         to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                
                // Shrink the map view to fit the region of the polyline when the ride request card is opened (the height of the 'RideRequestView' card is ~500px).
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        // Function to help clear the map view and remove existing routes (remove all annotations/overlays and recenter).
        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}
