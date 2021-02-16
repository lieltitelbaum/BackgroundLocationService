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
    public typealias CallbackClosure<T> = ((T) -> Void)

    static var uid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    static var isUserLoggedIn: Bool {
        return uid != nil
    }
    
    static func logOut(completion: @escaping CallbackClosure<Bool>){
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let signOutError as NSError{
            print("Could not sign out user \(signOutError)")
            completion(false)
        }
    }
    
    static func updateLocationInFirestore(location: MyLocation, completion: @escaping CallbackClosure<Bool>) {
        let locationDict = location.convertToDict()
        guard let uid = uid else {
            completion(false)
            return
        }
                
        db.collection(Constants.firebasePaths.fireStoreUsers).document(uid).setData(locationDict) { (err) in
            //if doc is not exist, it will create new one and if it does exist, it will overwrite the current value
            if let _ = err {
                completion(false)
            }
            else {
                completion(true)
            }
        }

//
//        db.collection("users").document(uid).getDocument { (snapDoc, error) in
//            if let locationData = snapDoc?.data() {
//               //update doc
//
//            }
//            else {
//                //create new doc
//                db.collection("users").document("notifications").collection(id).document("settings").setData(dict) { err in
//                    completion(err == nil)
//                }
//            }
//
//
//
////            if let val = locationData?.[Constants.]
//        }
    
    }
    
    
    
}
