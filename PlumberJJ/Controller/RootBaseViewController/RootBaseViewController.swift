//
//  RootBaseViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 10/27/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit
import AVFoundation
//import GradientCircularProgress
import NVActivityIndicatorView
import NotificationView
func isConnectedToNetwork() -> Bool {
    return (UIApplication.shared.delegate as! AppDelegate).IsInternetconnected
}

class RootBaseViewController: UIViewController , NotificationViewDelegate{
//    let progress = GradientCircularProgress()
    var spinnerViews : MMMaterialDesignSpinner?
    var spinnerView : MMMaterialDesignSpinner?
    var Appdel=UIApplication.shared.delegate as! AppDelegate
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 75, height: 100),
                                                        type: .ballScaleMultiple)
    var reachability : Reachability?
    var window: UIWindow?
    var theme:Theme=Theme()
    var url_handler : URLhandler = URLhandler()
    var sidebarMenuOpen:Bool=Bool()
    let Notify = NotificationView.default
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.getAppinformation()
        if isConnectedToNetwork() == false {
            if((self.view.window) != nil){
                let image = UIImage(named: "NoNetworkConn")
                self.view.makeToast(message:kErrorMsg, duration: 3, position:HRToastActivityPositionDefault as AnyObject, title: "Oops !!!!", image: image!)
            }
        }
        else {
            if(theme.isUserLigin()){
             
            }
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationLanguageChangeNotification:"), name: Language_Notification as String, object: nil)
        
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didClickLogOutPostNotif"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNoNetwork), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kPaymentPaidNotif), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceiveChatToRootView"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceivePushChatToRootView"), object: nil)
        
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "logout"), object: nil)
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kPushNotification), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(RootBaseViewController.methodOfReceivedNotificationForLogOut(_:)), name:NSNotification.Name(rawValue: "didClickLogOutPostNotif"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootBaseViewController.methodOfReceivedNotificationNetworkNet(_:)), name:NSNotification.Name(rawValue: kNoNetwork), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootBaseViewController.methodOfReceivedNotificationNetworkKKKK(_:)), name:NSNotification.Name(rawValue: kPaymentPaidNotif), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(RootBaseViewController.UpdateAccountStatusofTasker(_:)), name:NSNotification.Name(rawValue: kAccountstatus), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootBaseViewController.methodOfReceivedMessageNotification(_:)), name:NSNotification.Name(rawValue: "ReceiveChatToRootView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootBaseViewController.methodOfReceivedPushMessageNotification(_:)), name:NSNotification.Name(rawValue: "ReceivePushChatToRootView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RootBaseViewController.methodOfReceivedPushNotification(_:)), name:NSNotification.Name(rawValue: kPushNotification), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(RootBaseViewController.logoutmethod(_:)), name:NSNotification.Name(rawValue: "logout"), object: nil)
        

        
        NotificationCenter.default.addObserver(self, selector: #selector(RootBaseViewController.applicationLanguageChangeNotification(_:)), name: NSNotification.Name(rawValue: Language_Notification as String as String), object: nil)
        
        //theme.saveLanguage("en")
        //theme.SetLanguageToApp()
        
    }
    
    @objc func applicationLanguageChangeNotification(_ notification : Notification){
        
    }
    
    func  getAppinformation()
    {
        let URL_Handler:URLhandler=URLhandler()
        URL_Handler.makeCall(Appinfo_url, param: [:]) {
            (responseObject, error) -> () in
            if(error != nil)
            {
                
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.theme.CheckNullValue(responseObject["status"])
                    if(status == "1")
                    {
                        GetReceipientMail = self.theme.CheckNullValue(responseObject[ "email_address"])
                        kmval = self.theme.CheckNullValue(responseObject["distance_by"])
                    }
                    else
                    {
                    }
                }
            }
        }
    }
    
    @objc func logoutmethod(_ notify:Notification){
        self.theme.UpdateAvailability("0")
        let objUserRecs:UserInfoRecord=self.theme.GetUserDetails()
        let providerid = objUserRecs.providerId
        
        let Param: Dictionary = ["provider_id":"\(providerid as String)","device_type":"ios"]
        self.url_handler.makeCall(Logout_url, param: Param as NSDictionary) { (responseObject, error) -> () in
            self.DismissProgress()
            
            if(error != nil)
            {
                self.view.makeToast(message:"Network Failure", duration: 4, position: HRToastPositionDefault as AnyObject, title: "")
            }
                
            else
            {
                print("the response is \(String(describing: responseObject))")
                if(responseObject != nil)
                {
                    let responseObject = responseObject!
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    
                    if(status == "0")
                    {
                    }
                    else
                    {
                    }
                    
                    SocketIOManager.sharedInstance.RemoveAllListener()
                    SocketIOManager.sharedInstance.LeaveRoom(providerid as String)
                    SocketIOManager.sharedInstance.LeaveChatRoom(providerid as String)
                    let dic: NSDictionary = NSDictionary()
                    self.theme .saveUserDetail(dic)
                    let loginController = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitialVCSID") as! InitialViewController
                    //or the homeController
                    let navController = UINavigationController(rootViewController: loginController)
                    self.Appdel.window!.rootViewController! = navController
                    loginController.navigationController!.setNavigationBarHidden(true, animated: true)
                    
                }
                else
                {
                    self.view.makeToast(message: "Please try again", duration:3, position:HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                }
                
            }
            
        }
        
    }
    @objc func methodOfReceivedPushNotification(_ notification: Notification)  {
//        self.progress.dismiss()
        if((self.view.window) != nil){
            // self.view.endEditing(true)
            if(self.frostedViewController==nil){
                
            }else{
                self.frostedViewController.view.endEditing(true)
                // Present the view controller
                //
                self.frostedViewController.hideMenuViewController()
            }
            let userInfo:Dictionary<String,String?> = notification.userInfo as! Dictionary<String,String?>
            
            let Action = userInfo["action"]!
            _ = userInfo["action"]!
            let orderid = userInfo ["key"]!
            let alert = self.theme.CheckNullValue(userInfo["message"]!)
            
            if(Action=="job_request") || Action=="Accept_task" || Action=="Left_job" || Action ==  "rejecting_task" {
                if let activeController = navigationController?.visibleViewController {
                    if activeController.isKind(of: MyLeadsViewController.self){
                        let jobId=orderid
                        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                        objMyOrderVc.jobID=jobId!
                        objMyOrderVc.Getorderstatus = ""
                        self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
                    }else{
                        
                        if activeController.isKind(of: MessageViewController.self){
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                        }
                        
                        let jobId=orderid
                        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                        objMyOrderVc.jobID=jobId!
                        objMyOrderVc.Getorderstatus = ""
                        self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
                    }
                }
            }
            else if(Action=="account_status") {
                if (orderid == "2") || (orderid == "3"){
                    self.theme.AlertView(appNameJJ, Message: alert as String, ButtonTitle: kOk)
                    self.theme.saveVerifiedStatus(VerifiedStatus: 0)
                    //                    let alertView = UNAlertView(title: appNameJJ, message: self.theme.setLang("Account_Modified"))
                    //                    alertView.addButton(self.theme.setLang("ok"), action: {
                    //                      self.logoutmethod(Notification(name: Notification.Name(rawValue: "logout")))
                    //                    })
                    //                    alertView.show()
                }else if (orderid == "1"){
                    self.theme.AlertView(appNameJJ, Message: alert as String, ButtonTitle: kOk)
                    self.theme.saveVerifiedStatus(VerifiedStatus: 1)
                }
                self.updateAvailablity(self.theme.CheckNullValue(self.theme.getVerifiedStatus()))
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AccountStatusChanged"), object:nil, userInfo :["Key" : orderid!])
            }
            else if(Action=="job_cancelled"){
                if let activeController = navigationController?.visibleViewController {
                    if activeController.isKind(of: MyLeadsViewController.self){
                        let jobId=orderid
                        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                        objMyOrderVc.jobID=jobId!
                        objMyOrderVc.Getorderstatus = ""
                        self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
                    }else{
                        if activeController.isKind(of: MessageViewController.self){
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                        }
                        let jobId=orderid
                        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                        objMyOrderVc.jobID=jobId!
                        objMyOrderVc.Getorderstatus = ""
                        self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
                    }
                }
            }
            else if(Action=="receive_cash")
            {
                if let activeController = navigationController?.visibleViewController {
                    if activeController.isKind(of: MessageViewController.self){
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                    }
                }
                let pricestr  = theme.CheckNullValue(userInfo ["price"]!)
                let currencystr  = theme.CheckNullValue(userInfo["currency"]!)
                let jobId=orderid
                let price = pricestr
                let currency=currencystr
                let priceStr="\(currency) \(price)"
                let objReceiveCashvc = self.storyboard!.instantiateViewController(withIdentifier: "ReceiveCashVCSID") as! ReceiveCashViewController
                objReceiveCashvc.priceString=priceStr
                objReceiveCashvc.jobIDStr=jobId!
                self.navigationController!.pushViewController(withFade: objReceiveCashvc, animated: false)
            }
            else if(Action=="payment_paid")
            {
                if let activeController = navigationController?.visibleViewController {
                    if activeController.isKind(of: MessageViewController.self){
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                        
                    }
                }
//                let jobId=orderid
//                let objRatingsvc = self.storyboard!.instantiateViewController(withIdentifier: "RatingsVCSID") as! RatingsViewController
//
//                objRatingsvc.jobIDStr=jobId!
//                self.navigationController!.pushViewController(withFade: objRatingsvc, animated: false)
                let jobId=orderid
                let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                objMyOrderVc.jobID=jobId!
                objMyOrderVc.Getorderstatus = ""
                objMyOrderVc.isFromPushNotification = true
                self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
            }
            
        }
    }
    
    
    @objc func methodOfReceivedPushMessageNotification(_ notification: Notification){
        
        
//        self.progress.dismiss()
        if((self.view.window) != nil){
            // self.view.endEditing(true)
            if(self.frostedViewController==nil){
                
            }else{
                self.frostedViewController.view.endEditing(true)
                // Present the view controller
                //
                self.frostedViewController.hideMenuViewController()
            }
            
            let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
            // or as! Sting or as! Int
            
            let check_userid = userInfo["from"]
            _ = userInfo["message"]
            let taskid = userInfo["task"]
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            
            let providerid : String = objUserRecs.providerId
            if (check_userid == providerid)
            {
                
            }
            else
            {
                if let activeController = navigationController?.visibleViewController {
                    if activeController.isKind(of: MessageViewController.self){
                        
                        
                        
                    }else{
                        
                        
                        let objChatVc = self.storyboard!.instantiateViewController(withIdentifier: "ChatVCSID") as! MessageViewController
                        
                        objChatVc.Userid = check_userid
                        objChatVc.RequiredJobid = taskid
                        self.navigationController!.pushViewController(withFade: objChatVc, animated: false)
                        
                        
                        
                    }
                    
                }
            }
            
            
            
            
        }
        
    }
    
    @objc func methodOfReceivedMessageNotification(_ notification: Notification){
//        self.progress.dismiss()
        if((self.view.window) != nil){
            // self.view.endEditing(true)
            if(self.frostedViewController==nil){
                
            }else{
                self.frostedViewController.view.endEditing(true)
                // Present the view controller
                //
                self.frostedViewController.hideMenuViewController()
            }
            
            let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
            // or as! Sting or as! Int
            let check_userid = userInfo["from"]
            let ChatMsg = self.theme.CheckNullValue(userInfo["message"])
            let taskid = userInfo["task"]
            Notify.param = userInfo
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            
            let providerid : String = objUserRecs.providerId
            if (check_userid == providerid)
            {
                
            }
            else
            {
                if let activeController = navigationController?.visibleViewController {
                    if activeController.isKind(of: MessageViewController.self){
                    }else{
                        if activeController.isKind(of: MessageViewController.self){
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                            
                        }
//                        let alertView = UNAlertView(title: appNameJJ, message:Language_handler.VJLocalizedString("message_from_user", comment: nil))
//                        alertView.addButton(self.theme.setLang("ok"), action: {
//
//                            if activeController.isKind(of: TaskerProfileViewController.self){
//                                let myViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "ChatVCSID") as? MessageViewController
//                                myViewController!.Userid = check_userid
//                                myViewController!.RequiredJobid = taskid
//                                self.navigationController!.pushViewController(withFade: myViewController!, animated: false)
//
//                            }
//                            else
//                            {
//
//                                let objChatVc = self.storyboard!.instantiateViewController(withIdentifier: "ChatVCSID") as! MessageViewController
//
//                                objChatVc.Userid = check_userid
//                                objChatVc.RequiredJobid = taskid
//                                self.navigationController!.pushViewController(withFade: objChatVc, animated: false)
//                            }
//                        })
                        let Header = self.theme.setLang("New_msg")
                        self.theme.ShowNotification(Title: Header, message: ChatMsg, Indentifier: "Chat_Msg")
                        Notify.delegate = self
                        AudioServicesPlayAlertSound(1315);
//                        alertView.show()
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didClickLogOutPostNotif"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNoNetwork), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kPaymentPaidNotif), object: nil)
        
        NotificationCenter.default.removeObserver(self);
        
        
    }
    
    
    @objc func methodOfReceivedNotificationForLogOut(_ notification: Notification){
//        self.progress.dismiss()
        let objDict:NSDictionary=NSDictionary()
        theme.saveUserDetail(objDict)
        let objInitialVc = self.storyboard!.instantiateViewController(withIdentifier: "InitialVCSID") as! InitialViewController
        self.navigationController!.pushViewController(withFade: objInitialVc, animated: false)
        
    }
    func showProgress()
    {
       /* if spinnerView == nil {
            spinnerView = MMMaterialDesignSpinner(frame: CGRect.zero)
            
        }
        spinnerViews = spinnerView
        self.spinnerViews!.bounds = CGRect(x: 0, y: 0, width: 75, height: 75)
        self.spinnerViews!.tintColor = PlumberThemeColor
        
        if((self is JobsClosedViewController)||(self is MyOrderViewController)||(self is JobsCancelledViewController)||(self is MyJobsViewController)||(self is MyLeadsViewController)||(self is MissedLeadsViewController)||(self is BarChartViewController)||(self is PieChartViewController)||(self is NewLeadsViewController)){
            self.spinnerViews!.center = CGPoint(x: (self.view.bounds).midX,y: (self.view.bounds).midY-107)
        }else{
            self.spinnerViews!.center = CGPoint(x: (self.view.bounds).midX, y: (self.view.bounds).midY)
        }
        
        
        
        print("display spinner frame=\(self.spinnerView?.frame)" )
        self.spinnerViews!.translatesAutoresizingMaskIntoConstraints = false
        self.view!.addSubview(self.spinnerViews!)
        
        self.spinnerView?.startAnimating();*/
        
        self.activityIndicatorView.color = PlumberThemeColor
        self.activityIndicatorView.center=CGPoint(x: self.view.frame.size.width/2,y: self.view.frame.size.height/2);
        self.activityIndicatorView.startAnimating()
        self.view.addSubview(activityIndicatorView)
        
    }
    
    
    func DismissProgress()
    {
        /*self.spinnerView?.stopAnimating();
        
         self.spinnerView?.removeFromSuperview()*/
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.removeFromSuperview()
    }
    
    func DismissKeyboard()
    {
        self.view.endEditing(true)
        theme.saveHidestatus("Hide")
        
        
        
    }
    @objc func methodOfReceivedNotificationNetworkNet(_ notification: Notification){
        
//        self.progress.dismiss()
//        self.progress.dismiss()
//        self.progress.dismiss()
    }
    
   @objc func UpdateAccountStatusofTasker(_ notification: Notification){
    if((self.view.window) != nil){
        // self.view.endEditing(true)
        if(self.frostedViewController==nil){
            
        }else{
            self.frostedViewController.view.endEditing(true)
            // Present the view controller
            //
            self.frostedViewController.hideMenuViewController()
        }
        
        guard let url = notification.object else {
            return // or throw
        }
        
        let blob = url as! NSDictionary // or as! Sting or as! Int
        if(blob.count>0){
            var dictPartner:NSMutableDictionary = NSMutableDictionary()
            dictPartner = blob.object(forKey: "message") as! NSMutableDictionary
            
            let Action:NSString?=dictPartner.object(forKey: "action") as? NSString
            let message:NSString?=dictPartner.object(forKey: "message") as? NSString
            let MsgStr = message?.lowercased
            let key = self.theme.CheckNullValue(dictPartner.object(forKey: "key0"))
//          let key = String(format: "%d", dictPashowrtner.object(forKey: "key0") as! CVarArg)
            let objUserRecs:UserInfoRecord=self.theme.GetUserDetails()
            let providerid = objUserRecs.providerId
            
            if Action == "account_status" {
                if (key == "2") || (key == "3") || (key == "4"){
                    self.theme.saveVerifiedStatus(VerifiedStatus: 0)
                    let alertView = UNAlertView(title: appNameJJ, message: message! as String)
                    alertView.addButton(self.theme.setLang("ok"), action: {
                        SocketIOManager.sharedInstance.RemoveAllListener()
                        SocketIOManager.sharedInstance.LeaveRoom(providerid as String)
                        SocketIOManager.sharedInstance.LeaveChatRoom(providerid as String)
                        let dic: NSDictionary = NSDictionary()
                        self.theme .saveUserDetail(dic)
                        let loginController = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitialVCSID") as! InitialViewController
                        //or the homeController
                        let navController = UINavigationController(rootViewController: loginController)
                        self.Appdel.window!.rootViewController! = navController
                        loginController.navigationController!.setNavigationBarHidden(true, animated: true)
                    })
                    alertView.show()
                }else if (key == "1"){
                    self.theme.saveVerifiedStatus(VerifiedStatus: 1)
                    let Header = self.theme.setLang("account_status")
                    self.theme.ShowNotification(Title: Header, message: message! as String, Indentifier: "account_status")
                    Notify.delegate = self
                    AudioServicesPlayAlertSound(1315);
                    self.updateAvailablity(self.theme.CheckNullValue(self.theme.getVerifiedStatus()))
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AccountStatusChanged"), object:nil, userInfo :["Key" : key])
                }
            }
        }
    }
    }
    
    @objc func updateAvailablity(_ Status : String){
        showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["tasker":"\(objUserRecs.providerId)","availability" :Status]
        // print(Param)
        
        url_handler.makeCall(EnableAvailabilty, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.theme.CheckNullValue(responseObject["status"])
                    if(status == "1") //Verified
                    {
                        self.theme.saveVerifiedStatus(VerifiedStatus: 1)
                        let resDict = responseObject["response"] as! [String:Any]
                        let tasker_status : String = self.theme.CheckNullValue(resDict["tasker_status"])
                        
                        if (tasker_status == "1")
                        {
//                            self.view.makeToast(message:"Your availability is ON", duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                            self.theme.saveAvailable_satus("GO OFFLINE")
                            self.theme.saveVerifiedStatus(VerifiedStatus: 1)
                        }
                        else
                        {
//                            self.view.makeToast(message:"Your availability is OFF", duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                            self.theme.saveAvailable_satus("GO ONLINE")
                            self.theme.saveVerifiedStatus(VerifiedStatus: 0)
                        }
                    }else if (status == "3") || (status == "2"){//Not Verified
//                        self.theme.AlertView(ProductAppName, Message: Language_handler.VJLocalizedString("Acc_Not_Verified", comment: nil), ButtonTitle: kOk)
                        self.theme.saveVerifiedStatus(VerifiedStatus: 0)
                    }
                    else
                    {
//                        self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
            }
        }
    }
    
    
    @objc func methodOfReceivedNotificationNetworkKKKK(_ notification: Notification){
//        self.progress.dismiss()
        if((self.view.window) != nil){
            // self.view.endEditing(true)
            if(self.frostedViewController==nil){
                
            }else{
                self.frostedViewController.view.endEditing(true)
                // Present the view controller
                //
                self.frostedViewController.hideMenuViewController()
            }
            
            guard let url = notification.object else {
                return // or throw
            }
            
            let blob = url as! NSDictionary // or as! Sting or as! Int
            if(blob.count>0){
                
                var dictPartner:NSMutableDictionary = NSMutableDictionary()
                dictPartner = blob.object(forKey: "message") as! NSMutableDictionary
                Notify.param = dictPartner as? [String : Any]
                let Action = self.theme.CheckNullValue(dictPartner.object(forKey: "action"))
                let Title = self.theme.CheckNullValue(dictPartner.object(forKey: "key0"))
                let Message = self.theme.CheckNullValue(dictPartner.object(forKey: "message"))
                var Header = String()
                if Action=="job_request" || Action=="Accept_task" || Action=="Left_job" {
                    if let activeController = navigationController?.visibleViewController {
                        if activeController.isKind(of: MyLeadsViewController.self){
//                            let alertView = UNAlertView(title: appNameJJ, message:(dictPartner.object(forKey: "message") as? NSString)! as String)
//                            alertView.addButton(self.theme.setLang("ok"), action: {
//                                let jobId=dictPartner.object(forKey: "key0") as! String
//                                let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
//                                objMyOrderVc.jobID=jobId
//                                objMyOrderVc.Getorderstatus = ""
//                                self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
//                            })
                            Header = self.theme.setLang("New_Leads_notify")
                            self.theme.ShowNotification(Title: Header, message: Message, Indentifier: Action)
                            Notify.delegate = self
                            AudioServicesPlayAlertSound(1315);
//                            alertView.show()
                        }else{
//                            let alertView = UNAlertView(title: appNameJJ, message:(dictPartner.object(forKey: "message") as? NSString)! as String)
//                            alertView.addButton(self.theme.setLang("ok"), action: {
//                                if activeController.isKind(of: TaskerProfileViewController.self){
//                                    let jobId=dictPartner.object(forKey: "key0") as! String
//                                    let objMyOrderVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "MyOrderDetailOpenVCSID") as? MyOrderOpenDetailViewController
//                                    objMyOrderVc!.jobID=jobId
//                                    objMyOrderVc!.Getorderstatus = ""
//                                    self.navigationController!.pushViewController(withFade: objMyOrderVc!, animated: false)
//                                }
//                                else
//                                {
//                                    if activeController.isKind(of: MessageViewController.self){
//                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
//                                    }
//                                    let jobId=dictPartner.object(forKey: "key0") as! String
//                                    let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
//                                    objMyOrderVc.jobID=jobId
//                                    objMyOrderVc.Getorderstatus = ""
//                                    self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
//                                }
//                            })
                            Header = self.theme.setLang("New_Leads_notify")
                            self.theme.ShowNotification(Title: Header, message: Message, Indentifier: Action)
                            Notify.delegate = self
                            AudioServicesPlayAlertSound(1315);
//                            alertView.show()
                        }
                    }
                }
                else if(Action=="admin_notification")
                {
                    if let activeController = self.navigationController?.visibleViewController {
                        if activeController.isKind(of: MessageViewController.self){
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                        }
//                        let alertView = UNAlertView(title: appNameJJ, message:(dictPartner.object(forKey: "message") as? NSString)! as String)
//                        alertView.addButton(self.theme.setLang("ok"), action: {
//                        })
                        self.theme.ShowNotification(Title: Title, message: Message, Indentifier: Action)
                        Notify.delegate = self
                        AudioServicesPlayAlertSound(1315);
//                        alertView.show()
                    }
                }
                else if(Action=="job_cancelled"){
//                    let alertView = UNAlertView(title: appNameJJ, message:Language_handler.VJLocalizedString("cancel_by_user", comment: nil))
//                    alertView.addButton(self.theme.setLang("ok"), action: {
//                        if let activeController = self.navigationController?.visibleViewController {
//                            if activeController.isKind(of: MyOrderOpenDetailViewController.self){
//                                NotificationCenter.default.post(name: Notification.Name(rawValue: kJobCancelNotif), object: nil)
//                            }
//                            else if activeController.isKind(of: TaskerProfileViewController.self){
//                                let jobId=dictPartner.object(forKey: "key0") as! String
//                                let objMyOrderVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "MyOrderDetailOpenVCSID") as? MyOrderOpenDetailViewController
//                                objMyOrderVc!.jobID=jobId
//                                objMyOrderVc!.Getorderstatus = ""
//                                self.navigationController!.pushViewController(withFade: objMyOrderVc!, animated: false)
//                            }
//                            else{
//                                if activeController.isKind(of: MessageViewController.self){
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
//                                }
//                                let jobId=dictPartner.object(forKey: "key0") as! String
//                                let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
//                                objMyOrderVc.jobID=jobId
//                                objMyOrderVc.Getorderstatus = ""
//                                self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
//                            }
//                        }
//                    })
                    Header = self.theme.setLang("job_cancelled")
                    self.theme.ShowNotification(Title: Header, message: Message, Indentifier: Action)
                    Notify.delegate = self
                    AudioServicesPlayAlertSound(1315);
//                    alertView.show()
                }
                else if(Action=="receive_cash")
                {
                    if let activeController = self.navigationController?.visibleViewController {
                        if activeController.isKind(of: TaskerProfileViewController.self){
                            let jobId=dictPartner.object(forKey: "key1") as! String
                            let price=dictPartner.object(forKey: "key3") as! String
                            let currency=self.theme.getCurrencyCode(dictPartner.object(forKey: "key4") as! String)
                            let priceStr="\(currency) \(price)"
                            let objReceiveCashvc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "ReceiveCashVCSID") as? ReceiveCashViewController
                            objReceiveCashvc!.priceString=priceStr
                            objReceiveCashvc!.jobIDStr=jobId
                            self.navigationController!.pushViewController(withFade: objReceiveCashvc!, animated: false)
                        }
                        else{
                            if activeController.isKind(of: MessageViewController.self){
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                            }
                            let jobId=dictPartner.object(forKey: "key1") as! String
                            let price=dictPartner.object(forKey: "key3") as! String
                            let currency=self.theme.getCurrencyCode(dictPartner.object(forKey: "key4") as! String)
                            let priceStr="\(currency) \(price)"
                            let objReceiveCashvc = self.storyboard!.instantiateViewController(withIdentifier: "ReceiveCashVCSID") as! ReceiveCashViewController
                            objReceiveCashvc.priceString=priceStr
                            objReceiveCashvc.jobIDStr=jobId
                            self.navigationController!.pushViewController(withFade: objReceiveCashvc, animated: false)
                        }
                    }
                }
                else if(Action=="payment_paid")
                {
//
//                    let alertView = UNAlertView(title: appNameJJ, message:(dictPartner.object(forKey: "message") as? NSString)! as String)
//                    alertView.addButton(self.theme.setLang("ok"), action: {
//
//                        if let activeController = self.navigationController?.visibleViewController {
//                            if activeController.isKind(of: TaskerProfileViewController.self){
//                                let jobId=dictPartner.object(forKey: "key0") as! String
//                                let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
//                                objMyOrderVc.jobID=jobId
//                                objMyOrderVc.Getorderstatus = ""
//                                objMyOrderVc.isFromPushNotification = true
//                                self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
//                            }
//                            else{
//                                if activeController.isKind(of: MessageViewController.self){
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
//                                }
//                                let jobId=dictPartner.object(forKey: "key0") as! String
//                                let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
//                                objMyOrderVc.jobID=jobId
//                                objMyOrderVc.Getorderstatus = ""
//                                objMyOrderVc.isFromPushNotification = true
//                                self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
//                            }
//                        }
//                    })
                    Header = self.theme.setLang("payment")
                    self.theme.ShowNotification(Title: Header, message: Message, Indentifier: Action)
                    Notify.delegate = self
                    AudioServicesPlayAlertSound(1315);
//                    alertView.show()
                }
                    
                else if(Action=="partially_paid")
                {
//                    let alertView = UNAlertView(title: appNameJJ, message:(dictPartner.object(forKey: "message") as? NSString)! as String)
//                    alertView.addButton(self.theme.setLang("ok"), action: {
//                        if let activeController = self.navigationController?.visibleViewController {
//                            if activeController.isKind(of: TaskerProfileViewController.self){
//                                let jobId=dictPartner.object(forKey: "key0") as! String
//                                let objMyOrderVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "MyOrderDetailOpenVCSID") as? MyOrderOpenDetailViewController
//                                objMyOrderVc!.jobID=jobId
//                                objMyOrderVc!.Getorderstatus = ""
//                                self.navigationController!.pushViewController(withFade: objMyOrderVc!, animated: false)
//                            }
//                            else{
//                                if activeController.isKind(of: MessageViewController.self){
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
//                                }
//                                let jobId=dictPartner.object(forKey: "key0") as! String
//                                let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
//                                objMyOrderVc.jobID=jobId
//                                objMyOrderVc.Getorderstatus = ""
//                                self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
//                            }
//                        }
//                    })
                    Header = self.theme.setLang("Partial_Pay")
                    self.theme.ShowNotification(Title: Header, message: Message, Indentifier: Action)
                    Notify.delegate = self
                    AudioServicesPlayAlertSound(1315);
//                    alertView.show()
                }
                else if(Action=="job_assigned"){
//                    let alertView = UNAlertView(title:appNameJJ, message: Language_handler.VJLocalizedString("assigned_to_job", comment: nil))
//                    alertView.addButton(self.theme.setLang("ok"), action: {
//                    })
//                    alertView.addButton("View", action: {
//                        if let activeController = self.navigationController?.visibleViewController {
//                            if activeController.isKind(of: MyOrderOpenDetailViewController.self){
//                                NotificationCenter.default.post(name: Notification.Name(rawValue: kJobCancelNotif), object: nil)
//                            }else{
//
//                                if activeController.isKind(of: TaskerProfileViewController.self){
//                                    let jobId=dictPartner.object(forKey: "key1") as! String
//                                    let objMyOrderVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "MyOrderDetailOpenVCSID") as? MyOrderOpenDetailViewController
//                                    objMyOrderVc!.jobID=jobId
//                                    objMyOrderVc!.Getorderstatus = ""
//                                    self.navigationController!.pushViewController(withFade: objMyOrderVc!, animated: false)
//                                }
//                                else{
//                                    let jobId=dictPartner.object(forKey: "key1") as! String
//                                    let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
//                                    objMyOrderVc.jobID=jobId
//                                    objMyOrderVc.Getorderstatus = ""
//                                    self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
//                                }
//                            }
//                        }
//                    })
                    Header = self.theme.setLang("Job_assigned")
                    self.theme.ShowNotification(Title: Header, message: Message, Indentifier: Action)
                    Notify.delegate = self
                    AudioServicesPlayAlertSound(1315);
//                    alertView.show()
                }
            }
        }
    }
    
    func notificationViewDidTap(_ notificationView: NotificationView) {
        let Response = notificationView.param ?? [:]
        print("The notificationView.param is -->>\(Response)")
        if notificationView.identifier == "job_request" || notificationView.identifier == "Accept_task"  || notificationView.identifier == "Left_job" {
            if let activeController = navigationController?.visibleViewController {
                if activeController.isKind(of: MyLeadsViewController.self){
                    let jobId = self.theme.CheckNullValue(Response["key0"])
                    let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                    objMyOrderVc.jobID=jobId
                    objMyOrderVc.Getorderstatus = ""
                    self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
                }else{
                    if activeController.isKind(of: TaskerProfileViewController.self){
                        let jobId = self.theme.CheckNullValue(Response["key0"])
                        let objMyOrderVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "MyOrderDetailOpenVCSID") as? MyOrderOpenDetailViewController
                        objMyOrderVc!.jobID = jobId
                        objMyOrderVc!.Getorderstatus = ""
                        self.navigationController!.pushViewController(withFade: objMyOrderVc!, animated: false)
                    }
                    else
                    {
                        if activeController.isKind(of: MessageViewController.self){
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                        }
                        let jobId = self.theme.CheckNullValue(Response["key0"])
                        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                        objMyOrderVc.jobID = jobId
                        objMyOrderVc.Getorderstatus = ""
                        self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
                    }
                }
            }
        }
        else if notificationView.identifier == "admin_notification"{
           
        }
        else if notificationView.identifier == "job_cancelled"{
                if let activeController = self.navigationController?.visibleViewController {
                    if activeController.isKind(of: MyOrderOpenDetailViewController.self){
                        NotificationCenter.default.post(name: Notification.Name(rawValue: kJobCancelNotif), object: nil)
                    }
                    else if activeController.isKind(of: TaskerProfileViewController.self){
                        let jobId = self.theme.CheckNullValue(Response["key0"])
                        let objMyOrderVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "MyOrderDetailOpenVCSID") as? MyOrderOpenDetailViewController
                        objMyOrderVc!.jobID=jobId
                        objMyOrderVc!.Getorderstatus = ""
                        self.navigationController!.pushViewController(withFade: objMyOrderVc!, animated: false)
                    }
                    else{
                        if activeController.isKind(of: MessageViewController.self){
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                        }
                        let jobId = self.theme.CheckNullValue(Response["key0"])
                        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                        objMyOrderVc.jobID=jobId
                        objMyOrderVc.Getorderstatus = ""
                        self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
                    }
                }
        }
        else if notificationView.identifier == "receive_cash"{
            
        }
        else if notificationView.identifier == "payment_paid"{
            if let activeController = self.navigationController?.visibleViewController {
                if activeController.isKind(of: TaskerProfileViewController.self){
                    let jobId = self.theme.CheckNullValue(Response["key0"])
                    let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                    objMyOrderVc.jobID=jobId
                    objMyOrderVc.Getorderstatus = ""
                    objMyOrderVc.isFromPushNotification = true
                    self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
                }
                else{
                    if activeController.isKind(of: MessageViewController.self){
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                    }
                    let jobId = self.theme.CheckNullValue(Response["key0"])
                    let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                    objMyOrderVc.jobID=jobId
                    objMyOrderVc.Getorderstatus = ""
                    objMyOrderVc.isFromPushNotification = true
                    self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
                }
            }
        }
        else if notificationView.identifier == "partially_paid"{
            if let activeController = self.navigationController?.visibleViewController {
                if activeController.isKind(of: TaskerProfileViewController.self){
                    let jobId = self.theme.CheckNullValue(Response["key0"])
                    let objMyOrderVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "MyOrderDetailOpenVCSID") as? MyOrderOpenDetailViewController
                    objMyOrderVc!.jobID = jobId
                    objMyOrderVc!.Getorderstatus = ""
                    self.navigationController!.pushViewController(withFade: objMyOrderVc!, animated: false)
                }
                else{
                    if activeController.isKind(of: MessageViewController.self){
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                    }
                    let jobId = self.theme.CheckNullValue(Response["key0"])
                    let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                    objMyOrderVc.jobID=jobId
                    objMyOrderVc.Getorderstatus = ""
                    self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
                }
            }
        }
        else if notificationView.identifier == "job_assigned"{
            if let activeController = self.navigationController?.visibleViewController {
                if activeController.isKind(of: MyOrderOpenDetailViewController.self){
                    NotificationCenter.default.post(name: Notification.Name(rawValue: kJobCancelNotif), object: nil)
                }else{
                    
                    if activeController.isKind(of: TaskerProfileViewController.self){
                        let jobId = self.theme.CheckNullValue(Response["key0"])
                        let objMyOrderVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "MyOrderDetailOpenVCSID") as? MyOrderOpenDetailViewController
                        objMyOrderVc!.jobID=jobId
                        objMyOrderVc!.Getorderstatus = ""
                        self.navigationController!.pushViewController(withFade: objMyOrderVc!, animated: false)
                    }
                    else{
                        let jobId = self.theme.CheckNullValue(Response["key0"])
                        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
                        objMyOrderVc.jobID=jobId
                        objMyOrderVc.Getorderstatus = ""
                        self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
                    }
                }
            }
        }
        else if notificationView.identifier == "Chat_Msg"{
            let check_userid = self.theme.CheckNullValue(Response["from"])
            let taskid = self.theme.CheckNullValue(Response["task"])
            if let activeController = navigationController?.visibleViewController {
                if activeController.isKind(of: MessageViewController.self){
                    
                }else{
                    if activeController.isKind(of: TaskerProfileViewController.self){
                        let myViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "ChatVCSID") as? MessageViewController
                        myViewController!.Userid = check_userid
                        myViewController!.RequiredJobid = taskid
                        self.navigationController!.pushViewController(withFade: myViewController!, animated: false)
                    }
                    else
                    {
                        let objChatVc = self.storyboard!.instantiateViewController(withIdentifier: "ChatVCSID") as! MessageViewController
                        objChatVc.Userid = check_userid
                        objChatVc.RequiredJobid = taskid
                        self.navigationController!.pushViewController(withFade: objChatVc, animated: false)
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Custom UISwitch
    
    func switchTransform(isSwitch: UISwitch)
    {
        isSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
    }
    
    
    
    
}

extension UITextField {
    func isMandatory(){
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 10,height: self.frame.height)
        label.text = "*"
        label.textColor = UIColor.red
        self.rightView = label
        self.rightViewMode = UITextField.ViewMode .always
    }
}


