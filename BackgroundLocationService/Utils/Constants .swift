//
//  Constants .swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 21/01/2021.
//

import Foundation
import UIKit

class Constants {
    
    struct firebasePaths {
        static let fireStoreLocationCollection = "usersLocation"
        static let fireStoreUsers = "users"
    }
    
    struct Strings {
        static let stringMsg: String = "Please go to settings and allow this app to access your location."
        static let changePermissionsMsg: String = "Please change location permission to always"
    }
    
    struct keys {
        static let longitudeKey = "longitude"
        static let latitudeKey = "latitude"
    }
    
    struct design {
        static let continueLoginColor = UIColor(hex :"#00ADFF") ?? UIColor.white
    }
    
    static let mainStoryboard = "Main"
    static let homeVcId = "homeVc"
    static let loginVcId = "loginVc"
    static let meterDistanceFilter = 20.0 //20 meters
}
