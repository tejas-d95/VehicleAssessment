//
//  VehicleModel.swift
//  VehicleAssessment
//
//  Created by Tejas Dubal on 22/02/22.
//

import Foundation
import MapKit

struct VehicleModel: Codable {

    let id: Int
    let isActive: Bool
    let isAvailable: Bool
    let lat: Double?
    let licensePlateNumber: String
    let lng: Double?
    let pool: String
    let remainingMileage: Int
    let remainingRangeInMeters: Int
    let transmissionMode: String
    let vehicleMake: String
    let vehiclePic: String
    let vehiclePicAbsoluteUrl: String
    let vehicleType: String
    let vehicleTypeId: Int

    var vAnnotation: VehicleAnnotation?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case isActive = "is_active"
        case isAvailable = "is_available"
        case lat = "lat"
        case licensePlateNumber = "license_plate_number"
        case lng = "lng"
        case pool = "pool"
        case remainingMileage = "remaining_mileage"
        case remainingRangeInMeters = "remaining_range_in_meters"
        case transmissionMode = "transmission_mode"
        case vehicleMake = "vehicle_make"
        case vehiclePic = "vehicle_pic"
        case vehiclePicAbsoluteUrl = "vehicle_pic_absolute_url"
        case vehicleType = "vehicle_type"
        case vehicleTypeId = "vehicle_type_id"
    }
   
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        isAvailable = try values.decodeIfPresent(Bool.self, forKey: .isAvailable) ?? false
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        licensePlateNumber = try values.decodeIfPresent(String.self, forKey: .licensePlateNumber) ?? ""
        lng = try values.decodeIfPresent(Double.self, forKey: .lng)
        pool = try values.decodeIfPresent(String.self, forKey: .pool) ?? ""
        remainingMileage = try values.decodeIfPresent(Int.self, forKey: .remainingMileage) ?? 0
        remainingRangeInMeters = try values.decodeIfPresent(Int.self, forKey: .remainingRangeInMeters) ?? 0
        transmissionMode = try values.decodeIfPresent(String.self, forKey: .transmissionMode) ?? ""
        vehicleMake = try values.decodeIfPresent(String.self, forKey: .vehicleMake) ?? ""
        vehiclePic = try values.decodeIfPresent(String.self, forKey: .vehiclePic) ?? ""
        vehiclePicAbsoluteUrl = try values.decodeIfPresent(String.self, forKey: .vehiclePicAbsoluteUrl) ?? ""
        vehicleType = try values.decodeIfPresent(String.self, forKey: .vehicleType) ?? ""
        vehicleTypeId = try values.decodeIfPresent(Int.self, forKey: .vehicleTypeId) ?? 0
        vAnnotation = VehicleAnnotation(id: id, title: vehicleMake, locationName: "", coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat ?? 37.78162643367698), longitude: CLLocationDegrees(lng ?? -122.39407822716785)))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(isAvailable, forKey: .isAvailable)
        try container.encode(lat, forKey: .lat)
        try container.encode(licensePlateNumber, forKey: .licensePlateNumber)
        try container.encode(lng, forKey: .lng)
        try container.encode(pool, forKey: .pool)
        try container.encode(remainingMileage, forKey: .remainingMileage)
        try container.encode(remainingRangeInMeters, forKey: .remainingRangeInMeters)
        try container.encode(transmissionMode, forKey: .transmissionMode)
        try container.encode(vehicleMake, forKey: .vehicleMake)
        try container.encode(vehiclePic, forKey: .vehiclePic)
        try container.encode(vehiclePicAbsoluteUrl, forKey: .vehiclePicAbsoluteUrl)
        try container.encode(vehicleType, forKey: .vehicleType)
        try container.encode(vehicleTypeId, forKey: .vehicleTypeId)
    }

}

class VehicleAnnotation: NSObject, MKAnnotation {
    let id: Int
    let title: String?
    var locationName: String?
    let coordinate: CLLocationCoordinate2D
  init(
    id: Int,
    title: String?,
    locationName: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.id = id
    self.title = title
    self.locationName = locationName
    self.coordinate = coordinate

    super.init()
  }

      var subtitle: String? {
        return locationName
      }
    
    var image: UIImage {
        return UIImage.init(named: "carAnnotation")!
    }
}

class VehicleAnnotationView: MKAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let vehicleAnnotation = newValue as? VehicleAnnotation else {
        return
      }

      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

      image = vehicleAnnotation.image
        
        
        
        let detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.font = detailLabel.font.withSize(12)
        detailLabel.text = vehicleAnnotation.locationName
        detailCalloutAccessoryView = detailLabel
        
    }
  }
}
