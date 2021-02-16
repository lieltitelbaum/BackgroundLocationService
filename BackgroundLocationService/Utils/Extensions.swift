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

extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

extension UIApplication {
    static func mostTopViewController() -> UIViewController? {
        guard let topController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        return topController.mostTopViewController()
    }
}

extension UIColor {
    public convenience init?(hex hexa: String) {
        let r, g, b: CGFloat
        
        var hex = hexa.replacingOccurrences(of: "0x", with: "#")
        if !hex.starts(with: "#") {
            hex = "#\(hex)"
        }
        
        guard hex.hasPrefix("#") else { return nil }
        guard hex.count == 6 + 1 else { return nil }
        
        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        
        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000ff)) / 255
                
                self.init(red: r, green: g, blue: b, alpha: 1)
                return
            }
        }
        
        return nil
    }
}

extension UIView {
    /**
     Set the corner radius of the view.
     
     - Parameter color:        The color of the border.
     - Parameter cornerRadius: The radius of the rounded corner.
     - Parameter borderWidth:  The width of the border.
     */
    open func setCornerBorder(color: UIColor? = nil, cornerRadius: CGFloat = 15.0, borderWidth: CGFloat = 1.5) {
        self.layer.borderColor = color != nil ? color!.cgColor : UIColor.clear.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
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
