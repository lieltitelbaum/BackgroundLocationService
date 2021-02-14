//
//  Extensions.swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 23/01/2021.
//

import Foundation
import UIKit


extension UIViewController {
    func showAlert(title:String,message:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
    }
    
    class func instantiate(storyboardName: String? = Constants.mainStoryboard, identifier: String? = nil) -> Self {
        return instantiateFromStoryboardHelper(storyboardName: storyboardName, identifier: identifier)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T: UIViewController>(storyboardName: String?, identifier viewControllerIdentifier: String? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboardName ?? "Main", bundle: nil)
        let identifier = viewControllerIdentifier ?? NSStringFromClass(T.self).components(separatedBy: ".").last!
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        
        return controller
    }
    
    func mostTopViewController() -> UIViewController {
        guard let topController = self.presentedViewController else { return self }

        return topController.mostTopViewController()
    }
}

extension UIApplication {
    static func mostTopViewController() -> UIViewController? {
        guard let topController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        return topController.mostTopViewController()
    }
}

extension UIAlertController {
    
    static func make(style: UIAlertController.Style, title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        return alertController
    }
    
    @discardableResult
    func show(completion: (() -> Swift.Void)? = nil) -> UIAlertController? {
        guard let mostTopViewController = UIApplication.mostTopViewController() else { print("Failed to present alert [title: \(String(describing: self.title)), message: \(String(describing: self.message))]"); return nil }

        mostTopViewController.present(self, animated: true, completion: completion)

        return self
    }
    
    func withAction(_ action: UIAlertAction) -> UIAlertController {
        self.addAction(action)
        return self
    }
    
    static func makeAlert(title: String, message: String) -> UIAlertController {
        return make(style: .alert, title: title, message: message)
    }
}

extension Notification.Name {
}
