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
    }
    
    struct design {
        static let primaryFont: UIFont = UIFont(name: "ProximaNova-Bold", size: 18) ?? UIFont()
    }
    
    struct keys {
        static let longitudeKey = "longitude"
        static let latitudeKey = "latitude"

    }
    
    static let mainStoryboard = "Main"
    static let homeVcId = "homeVc"
    static let loginVcId = "loginVc"
    static let meterDistanceFilter = 20 //20 meters
}
