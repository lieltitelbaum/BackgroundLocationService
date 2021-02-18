//
//  LocationManager.swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 21/01/2021.
//

import Foundation
import UIKit
import CoreLocation
import FirebaseFirestore
import NVActivityIndicatorView

class Utils {
    
    static let shared: Utils = Utils()
    public typealias CallbackClosure<T> = ((T) -> Void)
    
    static func hasLocationAccess(vc: UIViewController, manager: CLLocationManager, completion: @escaping CallbackClosure<Bool>) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("Utils/ user chose authorizedAlways")
            completion(true)
        case .notDetermined:
            print("Utils/ user chose notDetermined")
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
            print("Utils/ user chose authorizedWhenInUse")
        //                tellUserTogoToSettings(vc: vc, msg: Constants.Strings.changePermissionsMsg)
        default:
            tellUserTogoToSettings(vc: vc)
            completion(false)
        }
    }
    
    @discardableResult
    private static func goToSettings() -> Bool {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            print("Failed getting setting url")
            return false
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
            return true
        }
        else {
            return false
        }
    }
    
    
    static func tellUserTogoToSettings(vc:UIViewController ,msg: String = Constants.Strings.stringMsg) {
        let alert = UIAlertController(title: "Location is off 😥", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Take me to settings 🎉", style: .default, handler: { (_) in
            goToSettings()
        }))
        alert.addAction(UIAlertAction(title: "I'll stay here", style: UIAlertAction.Style.cancel, handler: nil))
        vc.present(alert, animated: true)
    }
    
    static func setupRootViewController(window: UIWindow) {
        let nav = UINavigationController()
        var vc = UIViewController()
        if !FirebaseHelper.isUserLoggedIn {
            vc = UIStoryboard(name: Constants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.loginVcId)
            print("Set LoginVc to root vc")
        }
        else {
            vc = UIStoryboard(name: Constants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.homeVcId)
            print("Set homeVc to root vc")
        }
        nav.viewControllers = [vc]
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
    
}
