//
//  LocationManager.swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 21/01/2021.
//

import Foundation
import UIKit
//import OnGestureSwift
import CoreLocation
//import SDWebImage
import FirebaseFirestore

class Utils {
    
    static let shared: Utils = Utils()
    let locationManager: CLLocationManager
    
    private init() {
        locationManager = CLLocationManager()
    }
    static func getLocation() -> MyLocation? {
        //        if let coordinate = HomeViewController.shared?.userLocationOnMap {
        //            return MiniMapLocation(latitude: "\(coordinate.latitude)", longitude: "\(coordinate.longitude)")
        //        }
        //
        //        return nil
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            if let currentLoc = shared.locationManager.location {
                return MyLocation(latitude: "\(currentLoc.coordinate.latitude)", longitude: "\(currentLoc.coordinate.longitude)")
            }
        }
        
        return nil
    }
    
    static func hasLocationAccess()->Bool {
        if (CLLocationManager.locationServicesEnabled()) {
            
            if ([CLAuthorizationStatus.authorizedAlways].contains(CLLocationManager.authorizationStatus() )) {
                return true
            } else {
                return false
            }
        }
        return false
    }
}
