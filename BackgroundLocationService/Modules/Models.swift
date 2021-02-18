//
//  Models.swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 21/01/2021.
//

import Foundation
import CoreLocation

class MyLocation {
    
    var latitude: String
    var longitude: String
    
    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(dictionary:[String:Any]) {
        self.latitude = dictionary[Constants.keys.latitudeKey] as? String ?? ""
        self.longitude = dictionary[Constants.keys.longitudeKey] as? String ?? ""
    }
    
    func getCLLocation() -> CLLocation? {
        guard let latitude = Double(latitude), let longitude = Double(longitude) else { return nil }
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func convertToDict() -> [String:Any] {
        var dict:[String:Any] = [:]
        
        dict[Constants.keys.latitudeKey] = self.latitude
        dict[Constants.keys.longitudeKey] = self.longitude
        
        return dict
    }
}
