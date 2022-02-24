//
//  MapView-ViewInteractor.swift
//  VehicleAssessment
//
//  Created by Tejas Dubal on 24/02/22.
//

import Foundation

class MapViewViewInteractor {
    static func getVehicles(vehicles: @escaping ([VehicleModel]?) -> Void) {
        guard let vehiclesData = Helper.readLocalJSONFile(forName: Constants.vehicleJSONFile) else {
            return
        }
        
        guard let response = Helper.decodeData(data: vehiclesData, type: [VehicleModel].self) else {
            return
        }
        vehicles(response)
    }
}
