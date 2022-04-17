//
//  DataManager.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import Foundation

class DataManager {
    
    static var userRadius:String {
        set {
            UserDefaults.standard.set(newValue, forKey: "radius")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "radius") ?? ""
        }
    }
    
}




