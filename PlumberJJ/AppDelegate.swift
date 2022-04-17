//
//  AppDelegate.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 10/27/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit
///import HockeySDK
import AVFoundation
import UserNotifications
import XMLReader
import GooglePlaces
import IQKeyboardManagerSwift
let dbfileobj:DBFile = DBFile()
var ratingRec : RatingsRecord = RatingsRecord()
var Registerrec : NSMutableDictionary = NSMutableDictionary()
var jobDetail : JobDetailRecord = JobDetailRecord()
var trackingDetail:TrackingDetails = TrackingDetails()
var Language_handler:Languagehandler=Languagehandler()
var register:Registration = Registration()
var check_KeyBoard:String = String()
var Currentlat : String = String()
var Currentlng : String = String()
var didselect : String = String()
var lastDriving : Double = Double()
var Bearing : Double = Double()
var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
var launchedShortcutItem : UIApplicationShortcutItem?
var LocationTimer : Timer = Timer()
var ConnectionTimer:Timer=Timer()
var isocountry_code :String = String()
var GetReceipientMail:String=String()
var kmval :String = String()
let signup:Signup=Signup()
let registerData:RegistrationPageDatas = RegistrationPageDatas()
let URL_Handler:URLhandler=URLhandler()
var navigation=DLHamburguerNavigationController()
var Root_base:RootViewController=RootViewController()
enum ShortcutIdendifier : String {
    case first
    case second
    case third
    
    //Initializer
    init?(fullNameforType : String){
        guard let last = fullNameforType.components(separatedBy: ".").last else { return nil }
        self.init(rawValue: last)
    }
    
    //Properties
    var type : String{
        return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
    }
}


var navtransition : CATransition
{
    let trans = CATransition()
    trans.duration = 0.5
    trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    trans.type = CATransitionType.push
    return trans
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate{
    var theme:Theme=Theme()
    var window: UIWindow?
   
    
    let reachability = Reachability()
    var IsInternetconnected:Bool=Bool()
    var byreachable : String = String()
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        self.locationManager.requestAlwaysAuthorization()
        
        
        if UIDevice.current.modelName == "iPhone10,3" || UIDevice.current.modelName == "iPhone10,6" {
            self.theme.theDeviceisHavingNotch(true)
        }else
        {
            self.theme.theDeviceisHavingNotch(false)
        }
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
          //  self.theme.saveCountryCode(countryCode)
        }
        
        if let Shortcutitem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem
        {
            launchedShortcutItem = Shortcutitem
        }
        
        
        self.ReachabilityListener()
        UIApplication.shared.isIdleTimerDisabled = false
        
        UserDefaults.standard.removeObject(forKey: "Availability")
        NotificationCenter.default.addObserver(self, selector: #selector(hitMethodWhenAppActive), name:UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hitMethodWhenAppBackground), name:UIApplication.didEnterBackgroundNotification, object: nil)
        // Override point for customization after application launch.
      

        // For use in foreground
        
        HFALocationManager.InitLocationManager.updateCurrentLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        theme.saveLanguage("en")
        theme.SetLanguageToApp()
        
        self.checkForUpdates(islaunch: true)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.methodOfReceivedNotification(_:)), name:NSNotification.Name(rawValue: "didClickProfileBtnPostNotif"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.methodOfReceivedNotificationNetwork(_:)), name:NSNotification.Name(rawValue: kNoNetwork), object: nil)
        
//        BITHockeyManager.shared().configure(withIdentifier: "4a6d6242b4654b6c8b68c7c558b3f8e4")
//        BITHockeyManager.shared().start()
//        BITHockeyManager.shared().authenticator.authenticateInstallation()
        //Api Key for Google Map
        theme.getAppinformation()
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
        
        if(theme.isUserLigin())
        {
            setInitialViewcontroller()
        }
        if launchOptions != nil{
            if theme.isUserLigin(){
                let localNotif = launchOptions![UIApplication.LaunchOptionsKey.remoteNotification]
                    as? Dictionary<NSObject,AnyObject>
                
                if localNotif != nil
                {
                    let objUserRecs:UserInfoRecord=theme.GetUserDetails()
                    let providerid = objUserRecs.providerId
                    let checkuserid=theme.CheckNullValue((localNotif as AnyObject).value(forKey: "tasker") as AnyObject)
                    
                    if (providerid as String == checkuserid)
                    {
                        let ChatMessage:NSArray = (localNotif as AnyObject).value(forKey: "messages") as! NSArray
                        
                        var Message_Notice:NSString=NSString()
                        var taskid:NSString=NSString()
                        var messageid : NSString = NSString()
                        
                        let status : NSString = theme.CheckNullValue((localNotif as AnyObject).value(forKey: "status") as AnyObject) as NSString
                        if status == "1"
                        {
                            
                            Message_Notice = (ChatMessage[0] as AnyObject).object(forKey: "message") as! NSString
                            taskid = theme.CheckNullValue((localNotif as AnyObject).value(forKey: "task") as AnyObject) as NSString
                            messageid = (ChatMessage[0] as AnyObject).object(forKey: "_id") as! NSString
                            
                            let userid : NSString = theme.CheckNullValue((ChatMessage[0] as AnyObject).object(forKey: "from") as AnyObject) as NSString
                            let user_status : NSString = theme.CheckNullValue((ChatMessage[0] as AnyObject).object(forKey: "user_status") as AnyObject) as NSString
                            let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivePushChat"), object: ChatMessage, userInfo: ["message":"\(Message_Notice)","from":"\(userid)","task":"\(taskid)","msgid":"\(messageid)","usersts" : user_status])
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivePushChatToRootView"), object: ChatMessage, userInfo: ["message":"\(Message_Notice)","from":"\(userid)","task":"\(taskid)"])
                            }
                        }
                    }
                    else{
                        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: delayTime) {
                            self.APNSNotification(localNotif! as NSDictionary)
                        }
                    }
                }
            }
        }
        if theme.getEmailID() == ""{

            let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDel.MakeRootVc("RootVCID")
        }
        else
        {
            let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let rootView: UINavigationController = sb.instantiateViewController(withIdentifier: "RootVCID") as! UINavigationController
            UIView.transition(with: self.window!, duration: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: {
                appDel.window?.rootViewController=rootView
            }, completion: nil)
        }
        window?.backgroundColor=UIColor.white
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(item : shortcutItem))
    }
    
    func handleShortcutItem(item : UIApplicationShortcutItem) -> Bool
    {
        var handler = false
        //Verify that the provided shortcutitem's type is one handled by the application
        guard ShortcutIdendifier(fullNameforType: item.type) != nil else { return false }
        guard let shortCutType = item.type as String? else { return false }
        
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        var toOpenVc : UIViewController!
        
        switch shortCutType {
        case ShortcutIdendifier.first.type:
            toOpenVc = mainStoryBoard.instantiateViewController(withIdentifier: "NewLeadsVCSID") as! NewLeadsViewController
            handler = true
        
        case ShortcutIdendifier.second.type:
            toOpenVc = mainStoryBoard.instantiateViewController(withIdentifier: "MyJobsVCSID") as! MyJobsViewController
            handler = true
        
        case ShortcutIdendifier.third.type:
            toOpenVc = mainStoryBoard.instantiateViewController(withIdentifier: "StatisticsVCSID") as! StatisticsViewController
            handler = true
        default:
            print("Shortcut Item Handle func")
        }
        
        if let homeVC = self.window?.rootViewController as? UINavigationController
        {
            homeVC.pushViewController(toOpenVc, animated: true)
        }else{
            return false
        }
        
        return handler
    }
    
    func checkForUpdates(islaunch:Bool) {
        _ = Int()
        if appUpdateAvailable() {
            if islaunch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.displayAlert()
                }
            }
            else
            {
                displayAlert()
            }
        }
    }
    
    func appUpdateAvailable() -> Bool
    {
        //itunes.apple.com/us/app/handy-for-all-experts/id1157981860?mt=8
        
        let CurrentbundleID = Bundle.main.bundleIdentifier
        var currAppVersionDouble = Double()
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            currAppVersionDouble = Double(currentVersion) ?? 0.0
        }
        var upgradeAvailable = false
        // Get the main bundle of the app so that we can determine the app's version number
        URL_Handler.makeGetCall(storeInfoURL as NSString) { (responseObject) ->() in
           
            if(responseObject != nil)
            {
                let responseObject = responseObject as? [String:Any] ?? [:]
                let Results = responseObject["results"] as? [Any] ?? []
                if Results.count > 0 {
                    for Object in Results{
                        let Object = Object as? [String:Any] ?? [:]
                        let AppstoreVersion = self.theme.CheckNullValue(Object["version"])
                        let AppBundleID = self.theme.CheckNullValue(Object["bundleId"])
                        print("AppBundleID----->\(AppBundleID)")
                        print("AppstoreVersion----->\(AppstoreVersion)")
                        if CurrentbundleID == AppBundleID{
                            let store = Double(AppstoreVersion)
                            if currAppVersionDouble < store! {
                                upgradeAvailable = true
                            }
                            else
                            {
                                upgradeAvailable = false
                            } } } } }
        }
        print("CurrentbundleID----->\(CurrentbundleID)")
        print("currAppVersionDouble----->\(currAppVersionDouble)")

        return upgradeAvailable
    }
    
   
    func displayAlert()
    {
        
        let alertView = UNAlertView(title: Appname, message: "There is a newer version available for download! Please update the app by visiting the Apple Store.")
        alertView.addButton(theme.setLang("ok"), action: {
            let url = URL(string: "https://itunes.apple.com/us/app/handy-for-all-experts/id1157981860?mt=8")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
        })
        AudioServicesPlayAlertSound(1315);
        
        alertView.show()
    }
    @objc func hitMethodWhenAppBackground() {
        
        self.locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    @objc func hitMethodWhenAppActive() {
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.activityType = .automotiveNavigation
        if #available(iOS 9.0, *) {
            self.locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.startUpdatingLocation()
        
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
        Bearing = self.theme.getBearingBetweenTwoPoints1(user,locationB: partner)
        
        guard let currentlocation = locations.first else {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentlocation) { (placemarks, error) in
            guard let currentLocPlacemark = placemarks?.first else { return }
            print("get country",currentLocPlacemark.country ?? "No country found")
            print("get iso country",currentLocPlacemark.isoCountryCode ?? "No country code found")
            isocountry_code  = currentLocPlacemark.isoCountryCode ?? "IN"
            let dictCodes : NSDictionary = self.theme.getCountryList()
            let code = (dictCodes.value(forKey: isocountry_code)as! NSArray)[1] as? String
            self.theme.saveCountryCode(isocountry_code)
            
            
            
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: kLocationNotification), object:nil,userInfo :nil)
    }
    
    @objc func ReconnectMethod()
    {
        Thread.detachNewThreadSelector(#selector(EstablishCohnnection), toTarget: self, with: nil)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let direct = newHeading.trueHeading
        lastDriving = direct
    }
    @objc func EstablishCohnnection()
    {
        if(SocketIOManager.sharedInstance.ChatSocket.status == .notConnected || SocketIOManager.sharedInstance.ChatSocket.status == .disconnected)
        {
            if(theme.isUserLigin())
            {
                //Listen To server side Chat related notification
                
                SocketIOManager.sharedInstance.establishChatConnection()
                
            }
        }
        
        if(SocketIOManager.sharedInstance.socket.status == .notConnected || SocketIOManager.sharedInstance.socket.status ==  .disconnected)
        {
            
            
            //Listen To server side Job related notification
            
            if(theme.isUserLigin())
            {
                SocketIOManager.sharedInstance.establishConnection()
            }
            
        }
        
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0 ..< deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        if tokenString == ""
        {
            tokenString = "Simulator Signup"
            
        }
        
        theme.SaveDeviceTokenString(tokenString as NSString)
        print("tokenString: \(tokenString)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //  if userInfo.contains("tasker_status")
        
        let userInfoDict:NSDictionary?=userInfo as NSDictionary
        
        print("get userinformation=\(String(describing: userInfoDict))")
        let checkuserid = theme.CheckNullValue(userInfoDict!.object(forKey: "tasker") as AnyObject)
        
        if userInfoDict != nil
        {
            
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            
            let providerid = objUserRecs.providerId
            
            if (providerid as String == checkuserid)
            {
                
                
                var Message_Notice:NSString=NSString()
                var taskid:NSString=NSString()
                var messageid : NSString = NSString()
                var getuserid : NSString = NSString ()
                
                
                let status : NSString = theme.CheckNullValue(userInfoDict!.object(forKey: "status") as AnyObject) as NSString
                if status == "1"
                {
                    let ChatMessage:NSArray = userInfoDict!.object(forKey: "messages") as! NSArray
                    
                    
                    Message_Notice = (ChatMessage[0] as AnyObject).object(forKey: "message") as! NSString
                    taskid = userInfoDict!.object(forKey: "task") as! NSString
                    messageid = (ChatMessage[0] as AnyObject).object(forKey: "_id") as! NSString
                    getuserid = self.theme.CheckNullValue(userInfoDict!.object(forKey: "user") as AnyObject) as NSString
                    
                    let userid : NSString = theme.CheckNullValue((ChatMessage[0] as AnyObject).object(forKey: "from") as AnyObject) as NSString
                    let user_status : NSString = theme.CheckNullValue((ChatMessage[0] as AnyObject).object(forKey: "user_status") as AnyObject) as NSString
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivePushChat"), object: ChatMessage, userInfo: ["message":"\(Message_Notice)","from":"\(userid)","task":"\(taskid)","msgid":"\(messageid)","usersts" : user_status,"user_id":getuserid])
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivePushChatToRootView"), object: ChatMessage, userInfo: ["message":"\(Message_Notice)","from":"\(userid)","task":"\(taskid)"])
                }
            }
            else{
                APNSNotification(userInfo as NSDictionary)
            }
        }
    }
    
    func APNSNotification(_ dict : NSDictionary)
    {
        
        var Message_Notice:NSString=NSString()
        var Action:NSString = NSString()
        var key : NSString = NSString()
        var key0 : NSString = NSString()
        var key3 :NSString = NSString()
        var key4 : NSString = NSString()
        var KEY : NSString = NSString()
        let Message:NSDictionary=dict
        
        Message_Notice=Message.object(forKey: "message") as! NSString
        Action=Message.object(forKey: "action")as! NSString
        
        key = theme.CheckNullValue(Message.object(forKey: "key1") as AnyObject) as NSString
        key0 = theme.CheckNullValue(Message.object(forKey: "key0") as AnyObject) as NSString
        key3 = theme.CheckNullValue(Message.object(forKey: "key3") as AnyObject) as NSString
        key4 = theme.CheckNullValue(Message.object(forKey: "key4") as AnyObject) as NSString
        
        if (Action == "job_request") || Action=="Accept_task" || Action=="Left_job"
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kPushNotification), object:nil,userInfo :["message":"\(Message_Notice)","key":"\(key0)","action":"\(Action)"])
        }
            
        else if (Action == "job_cancelled")
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kPushNotification), object:nil,userInfo :["message":"\(Message_Notice)","key":"\(key0)","action":"\(Action)"])
        }
            
        else if(Action == "admin_notification")
        {
            
        }
        else if(Action == "account_status")
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kPushNotification), object: nil,userInfo :["message":"\(Message_Notice)","key":"\(key0)","action":"\(Action)"])
        }
        else if (Action == "receive_cash" )
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kPushNotification), object:nil,userInfo :["message":"\(Message_Notice)","key":"\(key)","action":"\(Action)" ,"price":"\(key3)" ,"currency":"\(key4)"])
        }
        else
        {
            let keyval: NSString = theme.CheckNullValue(Message.object(forKey: "key0") as AnyObject) as NSString
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: kPushNotification), object:nil,userInfo :["message":"\(Message_Notice)","key":"\(keyval)","action":"\(Action)"])
        }
    }
    
    func  socketTypeNotification(_ dict:NSDictionary)  {
        
        let Userid:NSString = dict.object(forKey: "user") as! NSString
        
        //let chatDict : NSDictionary = dict.objectForKey("chat") as! NSDictionary!
        //let taskid : String = self.theme.CheckNullValue(chatDict.objectForKey("task"))!
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceiveTypingMessage"), object: nil, userInfo: ["userid":"\(Userid)","taskid":""])
    }
    
    
    
    func socketStopTypeNotification(_ dict:NSDictionary)
    {    let Userid:NSString = dict.object(forKey: "user") as! NSString
        //        let chatDict : NSDictionary = dict.objectForKey("chat") as! NSDictionary!
        //        let taskid : String = self.theme.CheckNullValue(chatDict.objectForKey("task"))!
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceiveStopTypingMessage"), object: nil, userInfo: ["userid":"\(Userid)","taskid":""])
    }
    
    func socketChatNotification(_ dict:NSDictionary)
    {
        
        let Message:NSDictionary = dict.object(forKey: "message") as! NSDictionary
        var Message_Notice:NSString=NSString()
        var taskid:NSString=NSString()
        var messageid : NSString = NSString()
        var dateStr : NSString = NSString()
        var getuserid : NSString = NSString ()
        
        
        
        let status : NSString = theme.CheckNullValue(Message.object(forKey: "status") as AnyObject) as NSString
        if status == "1"
        {
            let ChatMessage:NSArray = Message.object(forKey: "messages") as! NSArray
            
            Message_Notice = (ChatMessage[0] as AnyObject).object(forKey: "message") as! NSString
            taskid = Message.object(forKey: "task") as! NSString
            getuserid = self.theme.CheckNullValue(Message.object(forKey: "user") as AnyObject) as NSString
            
            messageid = (ChatMessage[0] as AnyObject).object(forKey: "_id") as! NSString
            dateStr = (ChatMessage[0] as AnyObject).object(forKey: "date") as! NSString
            
            
            let userid : NSString = theme.CheckNullValue((ChatMessage[0] as AnyObject).object(forKey: "from") as AnyObject) as NSString
            let user_status : NSString = theme.CheckNullValue((ChatMessage[0] as AnyObject).object(forKey: "user_status") as AnyObject) as NSString
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceiveChat"), object: ChatMessage, userInfo: ["message":"\(Message_Notice)","from":"\(userid)","task":"\(taskid)","msgid":"\(messageid)","usersts" : user_status,"date" : dateStr,"user":getuserid])
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceiveChatToRootView"), object: nil, userInfo: ["message":"\(Message_Notice)","from":"\(userid)","task":"\(taskid)"])
        }
    }
    
    func socketNotification(_ dict:NSDictionary)
    {
        var messageArray:NSMutableDictionary=NSMutableDictionary()
        var Action:NSString = NSString()
        let Message:NSDictionary?=dict["message"] as? NSDictionary
        print("the user info is \(dict)...\(String(describing: Message))")
        
        
        if(Message != nil)
        {
            messageArray=(Message?.object(forKey: "message") as? NSMutableDictionary)!
            Action=(messageArray.object(forKey: "action") as? NSString)!
            
            
            
            if Action == "job_request" || Action=="Accept_task" || Action=="Left_job"
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: kPaymentPaidNotif), object: Message)
            }
            else if (Action == "job_cancelled")
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: kPaymentPaidNotif), object: Message)
            }
            else if (Action == "account_status"){
                NotificationCenter.default.post(name: Notification.Name(rawValue: kAccountstatus), object: Message)
            }
            else
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: kPaymentPaidNotif), object: Message)
            }
        }
    }
  
    func applicationWillResignActive(_ application: UIApplication) {
        
        ConnectionTimer.invalidate()
        ConnectionTimer = Timer()
        
        if(theme.isUserLigin())
        {
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            
            let providerid = objUserRecs.providerId
            
            
            SocketIOManager.sharedInstance.LeaveChatRoom(providerid as String)
            SocketIOManager.sharedInstance.LeaveRoom(providerid as String)
            SocketIOManager.sharedInstance.RemoveAllListener()
            
        }
        
        
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        if(theme.isUserLigin()){
            
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            let param=["user_type":"provider","id":"\(objUserRecs.providerId)","mode":"unavailable"]
            URL_Handler.makeCall(UserAvailableUrl , param: param as NSDictionary, completionHandler: { (responseObject, error) -> () in
                
            })
        }
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
        ConnectionTimer.invalidate()
        ConnectionTimer = Timer()
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler:
            {
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier!)
        })
        
        self.locationManager.startMonitoringSignificantLocationChanges()
        LocationTimer.invalidate()
        LocationTimer = Timer()
        LocationTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(ReconnectLocationMethod), userInfo: nil, repeats: true)
        RunLoop.current.add(LocationTimer, forMode: RunLoop.Mode.common)
        
        if(theme.isUserLigin())
        {
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            
            let providerid = objUserRecs.providerId
            
            
            SocketIOManager.sharedInstance.LeaveChatRoom(providerid as String)
            SocketIOManager.sharedInstance.LeaveRoom(providerid as String)
            SocketIOManager.sharedInstance.RemoveAllListener()
            
        }
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    @objc func ReconnectLocationMethod()
    {
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        print("call hitted")
    }
    func applicationWillEnterForeground(_ applßication: UIApplication) {
        
        
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        DispatchQueue.main.async {
            application.applicationIconBadgeNumber = 0
            LocationTimer.invalidate()
            ConnectionTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.ReconnectMethod), userInfo: nil, repeats: true)
            self.checkForUpdates(islaunch: false)
            
            if(self.theme.isUserLigin())
            {
                SocketIOManager.sharedInstance.establishConnection()
                SocketIOManager.sharedInstance.establishChatConnection()
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        ConnectionTimer.invalidate()
        ConnectionTimer = Timer()
        LocationTimer.invalidate()
        
        if(theme.isUserLigin())
        {
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            
            let providerid = objUserRecs.providerId
            
            
            SocketIOManager.sharedInstance.LeaveChatRoom(providerid as String)
            SocketIOManager.sharedInstance.LeaveRoom(providerid as String)
            SocketIOManager.sharedInstance.RemoveAllListener()
        }
        
        //SocketIOManager.sharedInstance.closeConnection()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    @objc func methodOfReceivedNotification(_ notification: Notification){
        guard let url = notification.object else {
            return // or throw
        }
        let blob = url as! NSString // or as! Sting or as! Int
        if(blob .isEqual(to: "1")){
            MakeRootVc("HomeVCSID")
        }
        else if(blob .isEqual(to: "2")){
            MakeRootVc("MyJobsVcSegue")
        }
        else if(blob .isEqual(to: "3")){
            MakeRootVc("BankingDetailSegue")
        }
        else if(blob .isEqual(to: "4")){
            MakeRootVc("MyProfileSegue")
        }
        else if(blob .isEqual(to: "5")){
            MakeRootVc("InitialVCSEGUe")
            let objDict:NSDictionary=NSDictionary()
            theme.saveUserDetail(objDict)
        }
    }
    
    func MakeRootVc(_ ViewIdStr:NSString){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVc = self.window!.rootViewController as! UINavigationController
        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "\(ViewIdStr)") as UIViewController
        initialVc.navigationController?.pushViewController(withFade: rootViewController, animated: false)
        
        //        let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let rootView:UIViewController = sb.instantiateViewControllerWithIdentifier("\(ViewIdStr)")
        //
        //         self.window!.rootViewController = rootView
        
    }
    
//    func setInitialViewcontroller(){
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let objLoginVc:DEMORootViewController = mainStoryboard.instantiateViewController(withIdentifier: "rootController") as! DEMORootViewController
//        
//        let navigationController: UINavigationController = UINavigationController(rootViewController: objLoginVc)
//        
//        self.window!.rootViewController = navigationController
//        self.window!.backgroundColor = UIColor.white
//        navigationController.setNavigationBarHidden(true, animated: true)
//        self.window!.makeKeyAndVisible()
//    }
    func setInitialViewcontroller(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let objLoginVc:DLDemoRootViewController = mainStoryboard.instantiateViewController(withIdentifier: "DLDemoRootViewController") as! DLDemoRootViewController
        
        let navigationController: UINavigationController = UINavigationController(rootViewController: objLoginVc)
        
        self.window!.rootViewController = navigationController
        self.window!.backgroundColor = UIColor.white
        navigationController.setNavigationBarHidden(true, animated: true)
        self.window!.makeKeyAndVisible()
    }
    func setInitailLogOut(){
      
        let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootView: UINavigationController = sb.instantiateViewController(withIdentifier: "StarterNavSid" as String) as! UINavigationController
        UIView.transition(with: self.window!, duration: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: {
            appDel.window?.rootViewController=rootView
        }, completion: nil)
        //[loginController.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    
    
    
    @objc func methodOfReceivedNotificationNetwork(_ notification: Notification){
        let navigationController = window?.rootViewController as? UINavigationController
        if let activeController = navigationController?.visibleViewController {
            
            let image = UIImage(named: "NoNetworkConn")
            activeController.view.makeToast(message:kErrorMsg, duration: 5, position:HRToastActivityPositionDefault as AnyObject, title: "Oops !!!!", image: image!)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
   
    func ReachabilityListener()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
    }
    @objc func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            IsInternetconnected=true
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
                byreachable = "1"
            } else {
                print("Reachable via Cellular")
                byreachable = "2"
            }
        } else {
            IsInternetconnected=false
            print("Network not reachable")
            byreachable = ""
        }
    }
    
    func Make_RootVc(_ ViewIdStr:NSString,RootStr:NSString){
        let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootView: UIViewController = sb.instantiateViewController(withIdentifier: ViewIdStr as String)
        self.window!.rootViewController=rootView
        NotificationCenter.default.post(name: Notification.Name(rawValue: "MakerootView"), object: RootStr)
    }
   
    
}

