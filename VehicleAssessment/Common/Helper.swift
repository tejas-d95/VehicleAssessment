//
//  Helper.swift
//  VehicleAssessment
//
//  Created by Tejas Dubal on 22/02/22.
//

import Foundation
import UIKit
import MapKit

class Helper {
    static func readLocalJSONFile(forName name: String) -> Data? {
        if let url = Bundle.main.url(forResource: name, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    return data
                } catch {
                    print("error:\(error)")
                }
            }
            return nil
    }
    
    
    static func decodeData<T: Decodable>(data: Data?, type: T.Type) -> T? {
        if let data = data {
            do {
                let decoderJson = try  JSONDecoder().decode(T.self, from: data)
                return decoderJson
            }catch let error {
                print(error)
                return nil
            }
        }else {
            return nil
        }
    }
    
}
