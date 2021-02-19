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
    let loadingAnim: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballBeat, color: Constants.design.loadingAnimColor, padding: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInBtn.isEnabled = true
        loadingAnim.frame = CGRect(x: view.frame.width/2 - 30, y: logInBtn.frame.origin.y - logInBtn.frame.height - 80, width: 50, height: 50)
        
        self.view.addSubview(loadingAnim)
        logInBtn.roundCorners()
        self.hideNav()
    }
    
    @IBAction func annonymousBtnTapped(_ sender: UIButton) {
        sender.isEnabled = false
        loadingAnim.startAnimating()
        
        if !FirebaseHelper.isUserLoggedIn {
            Auth.auth().signInAnonymously {[weak self] (result, error) in
                if error != nil {
                    print("error in login \(String(describing: error))")
                    UIAlertController.createOkAlert(vc: self ?? LogInViewController(), title: Constants.Strings.somethingWentWrong, msg: Constants.Strings.errorLogIn)
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
