//
//  MapView-ViewModel.swift
//  VehicleAssessment
//
//  Created by Tejas Dubal on 22/02/22.
//

import Foundation
import MapKit

protocol MapViewViewModelProtocol {
    func getVehicles()
    func getDecodedLocation(coordinates: CLLocationCoordinate2D?, location: @escaping (String) -> Void)
}
class MapViewViewModel {
    
    var mapViewController: MapViewControllerProtocol?
    
    init(mapViewController: MapViewController) {
        self.mapViewController = mapViewController
    }
}

extension MapViewViewModel: MapViewViewModelProtocol {
    func getVehicles() {
        MapViewViewInteractor.getVehicles() {
            vehicles in
            self.mapViewController?.recievedVehiclesData(vehicles: vehicles)
        }
    }
    
    func getDecodedLocation(coordinates: CLLocationCoordinate2D?, location: @escaping (String) -> Void) {
        
        Geocode.geocode(latValue: coordinates?.latitude, lngValue: coordinates?.longitude) {
            address in
            location(address)
        }
    }
}
