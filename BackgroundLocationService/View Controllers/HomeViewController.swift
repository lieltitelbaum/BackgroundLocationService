//
//  HomeViewController.swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 20/01/2021.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var enablePermissionsLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    lazy var locationManager: CLLocationManager = CLLocationManager()
    var isLocationUpdatingOn: Bool = false
    var currentLocation: MyLocation?
    
//    var currentLocation: MyLocation? {
//        guard let locationCord = locationManager.location?.coordinate else {return nil}
//        return MyLocation(latitude: locationCord.latitude.description, longitude: locationCord.longitude.description)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Utils.shared.locationManager.requestAlwaysAuthorization()
//        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        setupLocation()
//        locationManager.delegate = self
//        locationManager.allowsBackgroundLocationUpdates = true

    }
    
    private func setFonts() {
        Utils.setFontLbl(lbl: enablePermissionsLbl)
        Utils.setFontLbl(lbl: stopBtn.titleLabel)
        Utils.setFontLbl(lbl: startBtn.titleLabel)
        Utils.setFontLbl(lbl: logOutBtn.titleLabel)
    }
    
    private func setupLocation() {
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .otherNavigation
        locationManager.distanceFilter = CLLocationDistance(Constants.meterDistanceFilter)
        locationManager.startUpdatingLocation()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setLocationUpdate(start: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if !Utils.hasLocationAccess() {
//            Utils.tellUserTogoToSettings()
//            setLocationUpdate(start: false)
//        }
//        else {
//            setLocationUpdate(start: true)
//        }
    }
    
    @IBAction func startBtnTapped(_ sender: Any) {
        setLocationUpdate(start: true)
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        FirebaseHelper.logOut { (_ ) in
            let loginVc = LogInViewController.instantiate(identifier: Constants.loginVcId)
//            self.navigationController?.pushViewController(loginVc, animated: true)
            self.navigationController?.popToViewController(loginVc, animated: true)
        }
    }
    
    private func setLocationUpdate(start: Bool) {
        start ? locationManager.startUpdatingLocation() : locationManager.stopUpdatingLocation()
    }
    
    @IBAction func stopBtnTapped(_ sender: Any) {
        setLocationUpdate(start: false)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // you're good to go!
            print("user chose authorizedAlways")
            setLocationUpdate(start: true)
        }
        else if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else {
            setLocationUpdate(start: false)
            locationManager.requestAlwaysAuthorization()
//            Utils.tellUserTogoToSettings()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        setLocationUpdate(start: false)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedAlways:
            setLocationUpdate(start: true)
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            setLocationUpdate(start: true)
//            Utils.tellUserTogoToSettings(msg: "Please change location permission to always")
        default:
            Utils.tellUserTogoToSettings()
            setLocationUpdate(start: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.distanceFilter = CLLocationDistance(Constants.meterDistanceFilter) //20 meters
        
        if let location = locations.last {
            print("New location is \(location)")
            
            currentLocation = MyLocation(latitude: location.coordinate.latitude.description, longitude: location.coordinate.longitude.description)
            
            if let currentLocation = currentLocation {
                FirebaseHelper.updateLocationInFirestore(location: currentLocation) { (comp) in
                    if comp {
                        print("cuurent location is= \nlat: \(currentLocation.latitude) , long: \(currentLocation.longitude), updated in firestore successfully")
                    }
                    else {
                        print("cuurent location is \(currentLocation), did not updated in firestore successfully")
                    }
                }
            }
        }
        else {
            print("failed in fetching last location")
        }
    }
    
}
