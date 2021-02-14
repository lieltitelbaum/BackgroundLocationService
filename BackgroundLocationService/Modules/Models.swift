//
//  Models.swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 21/01/2021.
//

import Foundation
import CoreLocation

class MyLocation: Hashable {
    
    var latitude: String
    var longitude: String
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(dictionary:[String:Any]) {
        self.latitude = dictionary[Constants.keys.latitudeKey] as? String ?? ""
        self.longitude = dictionary[Constants.keys.longitudeKey] as? String ?? ""
    }
    
    static func == (lhs: MyLocation, rhs: MyLocation) -> Bool {
        return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude)
    }
    
//    convenience init?(dict: RawJsonFormat?) {
//        guard let lat = dict?["latitude"] as? String,let long = dict?["longitude"] as? String else {
//            return nil
//        }
//
//        self.init(latitude:lat,longitude:long)
//    }
    
    func getCLLocation() -> CLLocation? {
        guard let latitude = Double(latitude), let longitude = Double(longitude) else { return nil }
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    func convertToDict() -> [String:Any] {
        var dict:[String:Any] = [:]
        
        dict[Constants.keys.latitudeKey] = self.latitude
        dict[Constants.keys.longitudeKey] = self.longitude
        
        return dict
    }
}
