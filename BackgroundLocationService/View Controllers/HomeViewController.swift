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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()

        startBtn.setCornerBorder()
        stopBtn.setCornerBorder()
        
        setupLocation()
        
    }
    
    private func setupLocation() {
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .otherNavigation
        //                locationManager.distanceFilter = CLLocationDistance(Constants.meterDistanceFilter)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setLocationUpdate(start: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.hasLocationAccess(manager: locationManager) { (ans) in
            self.setLocationUpdate(start: ans)
        }
    }
    
    @IBAction func startBtnTapped(_ sender: Any) {
        Utils.hasLocationAccess(manager: locationManager) {[weak self] (access) in
            if access {
                self?.setLocationUpdate(start: true)
            }
            else {
                print("Does not have location access")
                self?.setLocationUpdate(start: false)
            }
        }
    }
    
    @IBAction func logOutTapped(_ sender: UIButton) {
        FirebaseHelper.logOut {[weak self] (success) in
            if success {
                if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                    Utils.setupRootVC(window: window)
                    self?.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    print("Failed getting window")
                    return
                }
            }
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
        else if status == .authorizedWhenInUse {
            print("user chose authorizedWhenInUse")
            locationManager.requestAlwaysAuthorization()
        }
        else {
            setLocationUpdate(start: false)
            Utils.tellUserTogoToSettings()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        setLocationUpdate(start: false)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Utils.hasLocationAccess(manager: locationManager) { (access) in
            self.setLocationUpdate(start: access)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        manager.distanceFilter = CLLocationDistance(Constants.meterDistanceFilter) //20 meters
        locationManager.requestAlwaysAuthorization()

        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        
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
