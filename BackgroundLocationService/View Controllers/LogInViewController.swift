//
//  LogInViewController.swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 23/01/2021.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var welcomeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInBtn.setCornerBorder()
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.view.backgroundColor = UIColor.black
            welcomeLbl.textColor = UIColor.white
        }
        else {
            self.view.backgroundColor = UIColor.white
            welcomeLbl.textColor = UIColor.black
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.view.backgroundColor = UIColor.white
        welcomeLbl.textColor = UIColor.black
        
    }
    
    @IBAction func annonymousBtnTapped(_ sender: UIButton) {
        
        Utils.showLoader(show: true)
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            if window.rootViewController != self
            {
                Utils.setupRootVC(window: window)
                print("root view controller is not login vc")
            }
        }
        
        if !FirebaseHelper.isUserLoggedIn {
            Auth.auth().signInAnonymously { (result, error) in
                Utils.showLoader(show: true)
                if error != nil {
                    print("error in login \(String(describing: error))")
                    self.showAlert(title: "Something went wrong", message: "Erroe signing in")
                    Utils.showLoader(show: false)
                }
                else {
                    print("user is logged in with uid = \(String(describing: FirebaseHelper.uid))")
                    self.goToHomeVc()
                }
            }
        }
        else {
            goToHomeVc()
        }
    }
    
    private func goToHomeVc() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVc") as? HomeViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
            else {
                print("eror in navigation controller")
            }
        }
        
        
//        let homeVc = HomeViewController.instantiate(storyboardName: Constants.mainStoryboard, identifier: Constants.homeVcId)
//        if let navigationController = self.navigationController {
//            navigationController.pushViewController(homeVc, animated: true)
//            Utils.showLoader(show: false)
//        }
//        else{
//            print("navigation controller is nil")
//        }
    }
    
}
