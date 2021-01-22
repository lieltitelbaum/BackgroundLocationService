//
//  FirebaseHelper.swift
//  BackgroundLocationService
//
//  Created by Liel Titelbaum on 21/01/2021.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import CoreLocation


class FirebaseHelper {
    
    static let db = Firestore.firestore()

    static var uid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    static var isUserLoggedIn: Bool {
        return uid != nil
    }
    
}
