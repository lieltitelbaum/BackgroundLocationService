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
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    lazy var locationManager: CLLocationManager = CLLocationManager()
    var isLocationUpdatingOn: Bool = false
    var currentLocation: MyLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocation()
        startBtn.roundCorners()
        stopBtn.roundCorners()
        self.hideNav()
    }
    
    private func setupLocation() {
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.activityType = .otherNavigation
        locationManager.distanceFilter = CLLocationDistance(Constants.meterDistanceFilter)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setLocationUpdate(start: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.hasLocationAccess(vc: self, manager: locationManager) {[weak self] (ans) in
            self?.setLocationUpdate(start: ans)
        }
    }
    
    @IBAction func startBtnTapped(_ sender: Any) {
        Utils.hasLocationAccess(vc: self, manager: locationManager) {[weak self] (access) in
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
                    Utils.setupRootViewController(window: window)
                    self?.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    print("Failed getting window")
                    return
                }
            }
            else {
                guard let strongSelf = self else {return}
                UIAlertController.createOkAlert(vc: strongSelf, title: Constants.Strings.logOutMsgTitle, msg: Constants.Strings.logOutMsgBody)
            }
        }
    }
    
    private func setLocationUpdate(start: Bool) {
        start ? locationManager.startUpdatingLocation() : locationManager.stopUpdatingLocation()
    }
    
    @IBAction func stopBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: Constants.Strings.stopLocationTitle, message: Constants.Strings.stopLocationMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.yesStr, style: .default, handler: {[weak self] (_) in
            self?.setLocationUpdate(start: false)
        }))
        alert.addAction(UIAlertAction(title: Constants.Strings.nopeStr, style: .cancel, handler: nil))
        self.present(alert, animated: true)
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
            Utils.tellUserTogoToSettings(vc: self)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        setLocationUpdate(start: false)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Utils.hasLocationAccess(vc: self, manager: locationManager) { (access) in
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
