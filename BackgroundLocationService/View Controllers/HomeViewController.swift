//
//  HomeViewController.swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 20/01/2021.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    lazy var locationManager: CLLocationManager = CLLocationManager()
    var isLocationUpdatingOn: Bool = false
    
    var currentLocation: MyLocation? {
        guard let locationCord = locationManager.location?.coordinate else {return nil}
        return MyLocation(latitude: locationCord.latitude.description, longitude: locationCord.longitude.description)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.shared.locationManager.requestAlwaysAuthorization()
//        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        
//        locationManager?.distanceFilter = 0.2 //update location every 20 meters
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        checkLocationUpdateStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLocationUpdateStatus()
    }
    
    private func checkLocationUpdateStatus() {
        if isLocationUpdatingOn {
            locationManager.startUpdatingLocation()
        }
        else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func stopBtnTapped(_ sender: Any) {
        isLocationUpdatingOn = false
        locationManager.stopUpdatingLocation()
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // you're good to go!
            isLocationUpdatingOn = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.distanceFilter = 0.2 //20 meters
        if let location = locations.last {
            print("New location is \(location)")
            //todo: update location in firebase
        }
    }
    
}
