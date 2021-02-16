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
    static let loader:NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0,y:0, width: 50, height: 50), type: .ballSpinFadeLoader, color:Constants.design.continueLoginColor, padding: nil)
    
    
    static func hasLocationAccess(manager: CLLocationManager, completion: @escaping CallbackClosure<Bool>) {
        
        if (CLLocationManager.locationServicesEnabled()) {
            
            switch manager.authorizationStatus {
            case .authorizedAlways:
                completion(true)
            case .notDetermined:
                manager.requestAlwaysAuthorization()
            case .authorizedWhenInUse:
                tellUserTogoToSettings(msg: Constants.Strings.changePermissionsMsg)
            default:
                tellUserTogoToSettings()
                completion(false)
            }
        }
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
    
    static func showLoader(show:Bool){
        var window:UIWindow?
        if #available(iOS 13.0, *){
            if let sceneWindow = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window {
                window = sceneWindow
            }
        }else {
            if let appD = (UIApplication.shared.delegate as? AppDelegate)?.window {
                window = appD
            }
        }
        if show {
            window?.addSubview(loader)
            loader.frame = CGRect(x: (window?.frame.size.width  ?? 0)/2 - 25, y: (window?.frame.height ?? 0)/2 - 25, width: 50, height: 50)
            loader.startAnimating()
        }else {
            loader.stopAnimating()
            loader.removeFromSuperview()
        }
        
    }

    
    static func setupRootVC(window: UIWindow) {
        if !FirebaseHelper.isUserLoggedIn {
            let vc = UIStoryboard(name: Constants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.loginVcId)
            window.rootViewController = vc
            window.makeKeyAndVisible()
            print("Set LoginVc to root vc")
        }
        else {
            let vc = UIStoryboard(name: Constants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.homeVcId)
            window.rootViewController = vc
            window.makeKeyAndVisible()
            print("Set homeVc to root vc")
        }
    }
    
}
