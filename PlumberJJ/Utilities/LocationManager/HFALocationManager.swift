//
//  HFALocationManager.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 6/7/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

private(set) var currentLocation: CLLocation?
private(set) var locationManager: CLLocationManager?

enum HFALocationManagerMonitorMode : Int {
    case HFALocationManagerModeStandard
    case HFALocationManagerModeStandardWhenInUse // this is new in iOS 8 - app can request for permission for only when app is in use
    case HFALocationManagerModeSignificantLocationUpdates
}

private var sharedManager: HFALocationManager?

class HFALocationManager: NSObject,CLLocationManagerDelegate {
    
      static let InitLocationManager = HFALocationManager()
    
    var isLocationUpdated = false
    var isRefreshLocation = false
    var isDriverLocationUpdatedInitially = false
    var isDriverLocationUpdatedServerInitially = false
    
    var gotAppInfo = false
    var canMoveToApp = false
    var isBackgroundMode = false
    var deferringUpdates = false
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var mode: HFALocationManagerMonitorMode?
    let THEMES = Theme()
    
    
    override convenience init() {
        self.init(locationManager: CLLocationManager())!
    }
    
    init?(locationManager: CLLocationManager?) {
        super.init()
        assert(locationManager != nil, "Invalid parameter not satisfying: locationManager != nil")
        self.locationManager = locationManager
        self.locationManager?.delegate = self
        isRefreshLocation = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCurrentLocation), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.hitMethodWhenAppBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLocationOnBackgroundThreadWithTimer), name: NSNotification.Name("updateHFALocationWithInterval"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveAppInfoNotification(_:)), name: NSNotification.Name("NotifForAppInfo"), object: nil)
    }
    
    @objc func receiveAppInfoNotification(_ notification: Notification?) {
        gotAppInfo = true
        updateLoc()
    }
    
    @objc func updateLocationOnBackgroundThreadWithTimer() {
            updateLoc()
    }
    
    @objc func hitMethodWhenAppBackground() {
        if locationManager != nil {
            locationManager?.startMonitoringSignificantLocationChanges()
        }
    }
    
    func removeUpdateOnAppTermination() {
        if locationManager != nil {
            locationManager?.stopMonitoringSignificantLocationChanges()
        }
    }
    
    @objc func updateCurrentLocation() {
        
        if locationManager != nil {
            isBackgroundMode = true
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                locationManager?.distanceFilter = kCLDistanceFilterNone
                locationManager?.activityType = .automotiveNavigation
                if #available(iOS 9.0, *) {
                    locationManager?.allowsBackgroundLocationUpdates = true
                } else {
                    // Fallback on earlier versions
                }
                locationManager?.pausesLocationUpdatesAutomatically = false
                locationManager?.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                
                let alertView =  UNAlertView(title:Language_handler.VJLocalizedString("location_disable_title", comment: nil), message: Language_handler.VJLocalizedString("location_disable_message", comment: nil))
                alertView.addButton(kOk, action: {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }

                })
                
                alertView.show()
                break
                
            case .authorizedAlways, .authorizedWhenInUse: break
                
            }
        } else {
            let alertView =  UNAlertView(title:Language_handler.VJLocalizedString("location_disable_title", comment: nil), message: Language_handler.VJLocalizedString("location_disable_message", comment: nil))
            alertView.addButton(kOk, action: {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }

            })
            alertView.show()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        Currentlat="\(locValue.latitude)"
        Currentlng="\(locValue.longitude)"
        let user : CLLocation = CLLocation.init(latitude: trackingDetail.userLat, longitude: trackingDetail.userLong)
        let partner : CLLocation = CLLocation.init(latitude: locValue.latitude, longitude: locValue.longitude)
        Bearing = self.THEMES.getBearingBetweenTwoPoints1(user,locationB: partner)
        
        guard let currentlocation = locations.first else {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentlocation) { (placemarks, error) in
            guard let currentLocPlacemark = placemarks?.first else { return }
            print("get country",currentLocPlacemark.country ?? "No country found")
            print("get iso country",currentLocPlacemark.isoCountryCode ?? "No country code found")
            isocountry_code  = currentLocPlacemark.isoCountryCode ?? "IN"
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: kLocationNotification), object:nil,userInfo :nil)
    }
    
    func updateLoc() {
        
    }

}
