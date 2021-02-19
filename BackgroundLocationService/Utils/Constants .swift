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
        static let fireStoreUsers = "users"
    }
    
    struct Strings {
        static let stringMsg: String = "Please go to settings and allow this app to access your location."
        static let changePermissionsMsg: String = "Please change location permission to always"
        static let logOutMsgTitle: String = "Couldn't sign out"
        static let logOutMsgBody = "Sorry, there is a problem signing you out"
        static let stopLocationTitle = "Are you sure?"
        static let stopLocationMsg = "don't stop and go, stay with us!"
        static let okStr = "OK"
        static let yesStr = "Yes"
        static let nopeStr = "Nope"
        static let switchToAlwaysPerm: String = "Please allow always location permission 📍"
        static let takeMeToSettings:String = "Take me to settings 🎉"
        static let stayHere:String = "I'll stay here"
        static let locationIsOff:String = "Location is off 😥"
        static let somethingWentWrong = "Something went wrong 😰"
        static let errorLogIn = "We are sorry, we have trouble signing you in right now"
    }
    
    struct keys {
        static let longitudeKey = "longitude"
        static let latitudeKey = "latitude"
    }
    
    struct design {
        static let loadingAnimColor = UIColor(hex : "#EDBACC") ?? UIColor.systemPink
    }
    
    static let mainStoryboard = "Main"
    static let homeVcId = "homeVc"
    static let loginVcId = "loginVc"
    static let meterDistanceFilter = 20.0 //20 meters
}
