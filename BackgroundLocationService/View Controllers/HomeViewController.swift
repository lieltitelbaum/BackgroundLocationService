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
    
    var lastLocation: CLLocation?
    
    private var locationManager: CLLocationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?
    var isLocationUpdatingOn: Bool = false
    var currentLocation: MyLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSetup()
        startBtn.roundCorners()
        stopBtn.roundCorners()
        self.hideNav()
    }
    
    private func locationSetup() {
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .otherNavigation
        locationManager.distanceFilter = Constants.meterDistanceFilter //20 meters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setLocationUpdate(start: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationStatusHelper()
    }
    
    @IBAction func startBtnTapped(_ sender: Any) {
        locationStatusHelper()
    }
    
    private func locationStatusHelper() {
        if !requestLocationAuthorization() {
            //if it's not the first time the user get location permissions prompt, update location accordingly and present alert that refer the user to setting page in order to enable location if necessary
            Utils.hasLocationAccess(vc: self, manager: self.locationManager) {[weak self] (ans) in
                self?.setLocationUpdate(start: ans)
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
        //present an alert before user is stopping the service
        let alert = UIAlertController(title: Constants.Strings.stopLocationTitle, message: Constants.Strings.stopLocationMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.yesStr, style: .default, handler: {[weak self] (_) in
            self?.setLocationUpdate(start: false)
        }))
        alert.addAction(UIAlertAction(title: Constants.Strings.nopeStr, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @discardableResult
    private func requestLocationAuthorization() ->Bool {
        //return true if permissions needed to be asked, if not(not for the first time) return false
        
        // Only ask authorization if it was never asked before
        guard locationManager.authorizationStatus == .notDetermined else { return false }
        
        // Starting on iOS 13.4.0, to get .authorizedAlways permission, you need to
        // first ask for WhenInUse permission, then ask for Always permission to
        // get to a second system alert
        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = {[weak self] status in
                if status == .authorizedWhenInUse || status == .notDetermined {
                    print("status is \(status)")
                    self?.locationManager.requestAlwaysAuthorization()
                }
                else if status == .authorizedAlways {
                    print("\nstatus is: authorizedAlways")
                    self?.setLocationUpdate(start: true)
                }
                else if status == .denied || status == .restricted {
                    guard let strongSelf = self else {return}
                    Utils.tellUserTogoToSettings(vc: strongSelf)
                    self?.setLocationUpdate(start: false)
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
        }
        else {
            self.locationManager.requestAlwaysAuthorization()
        }
        return true
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.requestLocationAuthorizationCallback?(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {        
        //fetch location
        if let location = locations.last {
            print("New location is \(location)")
            
            //check the distance between the last location and current location
            if lastLocation != nil {
                let distance: CLLocationDistance =
                    lastLocation!.distance(from: location)
                print("Distance is \(distance)")
            }
            lastLocation = location
           
            
            currentLocation = MyLocation(latitude: location.coordinate.latitude.description, longitude: location.coordinate.longitude.description)
            
            if let currentLocation = currentLocation {
                //update location in firebase
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //In older ios versions use this function
        self.requestLocationAuthorizationCallback?(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed with error \(error)")
        setLocationUpdate(start: false)
    }
    
    
}
