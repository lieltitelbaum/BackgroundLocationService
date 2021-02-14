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
    
    @discardableResult
    private static func goToSettings() -> Bool {
        if let openSettingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(openSettingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(openSettingsUrl, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(openSettingsUrl)
            }
            return true
        } else {
            print("Failed getting url: \(UIApplication.openSettingsURLString)")
        }
        return false
    }
    
    static func tellUserTogoToSettings(msg: String = Constants.Strings.stringMsg) {
        let missingLocationPermissionsAnnouncement = msg
        UIAlertController.makeAlert(title: "Oops", message: missingLocationPermissionsAnnouncement).withAction(UIAlertAction(title: "Go to Settings", style: UIAlertAction.Style.default, handler: { _ in
            goToSettings()
        })).withAction(UIAlertAction(title: "No, thanks...", style: UIAlertAction.Style.cancel, handler: nil))
        .show()
    }
    
    
    static func setupRootVC(window: UIWindow) {
        if !FirebaseHelper.isUserLoggedIn {
            let vc = UIStoryboard(name: Constants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.loginVcId)
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
        else {
            let vc = UIStoryboard(name: Constants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.homeVcId)
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
    }
    
    static func setFontLbl(lbl: UILabel?) {
        guard let lbl = lbl else {return}
        lbl.font = Constants.design.primaryFont
    }
    
}
