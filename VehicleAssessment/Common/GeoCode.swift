//
//  GeoCode.swift
//  VehicleAssessment
//
//  Created by Tejas Dubal on 24/02/22.
//

import Foundation
import MapKit

class Geocode {

    static func geocode(latValue: Double?, lngValue: Double?, address: @escaping (String) -> Void) {
        lazy var geocoder = CLGeocoder()
        
        guard let lat = latValue else { return }
        guard let lng = lngValue else { return }

        // Create Location
        let location = CLLocation(latitude: lat, longitude: lng)

        // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error) {
                location in
                address(location)
            }
        }

        // Update View
    }
    
    private static func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?, address: @escaping (String) -> Void) {
        // Update View
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            print("Unable to Find Address for Location")

        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                print(placemark.compactAddress as Any)
                
                address(placemark.compactAddress ?? "")
            } else {
                print("No Matching Addresses Found")
            }
        }
    }
}

extension CLPlacemark {

    var compactAddress: String? {
        if let name = name {
            var result = name

            if let street = thoroughfare {
                result += ", \(street)"
            }

            if let city = locality {
                result += ", \(city)"
            }

            if let country = country {
                result += ", \(country)"
            }

            return result
        }

        return nil
    }

}
