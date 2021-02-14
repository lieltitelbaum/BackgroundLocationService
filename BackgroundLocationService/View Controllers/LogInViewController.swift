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
        
        Utils.setFontLbl(lbl: welcomeLbl)
        Utils.setFontLbl(lbl: logInBtn.titleLabel)
        
        
    }
    
    @IBAction func annonymousBtnTapped(_ sender: Any) {
  
        if !FirebaseHelper.isUserLoggedIn {
            Auth.auth().signInAnonymously {[weak self] (result, error) in
                print("error in login \(String(describing: error))")
                if error != nil {
                    self?.showAlert(title: "Something went wrong", message: "Erroe signing in")
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
        let homeVc = HomeViewController.instantiate(storyboardName: Constants.mainStoryboard, identifier: Constants.homeVcId)
        self.navigationController?.pushViewController(homeVc, animated: true)
    }
    
}
