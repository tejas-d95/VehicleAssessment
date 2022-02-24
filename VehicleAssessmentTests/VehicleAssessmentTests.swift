//
//  VehicleAssessmentTests.swift
//  VehicleAssessmentTests
//
//  Created by Tejas Dubal on 22/02/22.
//

import XCTest
@testable import VehicleAssessment

class VehicleAssessmentTests: XCTestCase {
    
    var sut: MapViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = MapViewController()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        sut = nil
        try super.tearDownWithError()

    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // Test case to check if all cars have latitude and longitude
    func testForLatAndLng() {
        let data = Helper.readLocalJSONFile(forName: "vehicles_data")
        
        if data == nil {
            XCTFail("Problem while reading JSON file")
        }
        
        if let vehicles = Helper.decodeData(data: data, type: [VehicleModel].self){
            let _ = vehicles.map { model in
                if (model.lat == nil || model.lng == nil) {
                    XCTFail("Some of the cars does not have valid latitude and longitude")
                }
            }
        } else {
            XCTFail("Problem while decoding vehicles JSON data")
        }
        
        
    }
}
