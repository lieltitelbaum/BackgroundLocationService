//
//  LogInViewController.swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 23/01/2021.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView


class LogInViewController: UIViewController {
    
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var welcomeLbl: UILabel!
    var isDarkModeOn: Bool?
    let loadingAnim: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballBeat, color: Constants.design.loadingAnimColor, padding: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInBtn.isEnabled = true
        loadingAnim.frame = CGRect(x: view.frame.width/2 - 30, y: logInBtn.frame.origin.y - 70, width: 50, height: 50)
        
        self.view.addSubview(loadingAnim)
        logInBtn.roundCorners()
        self.hideNav()
        handleDarkMode()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        darkModeHelper()
    }
    
    private func darkModeHelper() {
        if isDarkModeOn == true {
            self.view.backgroundColor = UIColor.black
            welcomeLbl.textColor = UIColor.white
        }
        else {
            self.view.backgroundColor = UIColor.white
            welcomeLbl.textColor = UIColor.black
        }
    }
    
    private func handleDarkMode() {
        if self.traitCollection.userInterfaceStyle == .dark {
            isDarkModeOn = true
        }
        else {
            isDarkModeOn = false
        }
        darkModeHelper()
    }
    
    @IBAction func annonymousBtnTapped(_ sender: UIButton) {
        sender.isEnabled = false
        loadingAnim.startAnimating()
        
        if !FirebaseHelper.isUserLoggedIn {
            Auth.auth().signInAnonymously {[weak self] (result, error) in
                if error != nil {
                    print("error in login \(String(describing: error))")
                    UIAlertController.createOkAlert(vc: self ?? LogInViewController(), title: "Something went wrong", msg: "Erroe signing in")
                    self?.loadingAnim.stopAnimating()
                    sender.isEnabled = true
                }
                else {
                    print("user is logged in with uid = \(String(describing: FirebaseHelper.uid))")
                    self?.goToHomeVc()
                }
            }
        }
        else {
            goToHomeVc()
        }
    }
    
    private func goToHomeVc() {
        logInBtn.isEnabled = true
        
        let homeVc = UIStoryboard(name: Constants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.homeVcId)
        if let navigationController = self.navigationController {
            navigationController.pushViewController(homeVc, animated: true)
        }
        else{
            print("navigation controller is nil")
        }
        loadingAnim.stopAnimating()
    }
    
}
