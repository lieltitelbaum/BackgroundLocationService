//
//  Extensions.swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 23/01/2021.
//

import Foundation
import UIKit


extension UIViewController {
    func hideNav() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}

extension UIAlertController {
    static func createOkAlert(vc: UIViewController, title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: Constants.Strings.okStr, style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}

extension UIView {
    func roundCorners(radius: CGFloat = 20.0) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
