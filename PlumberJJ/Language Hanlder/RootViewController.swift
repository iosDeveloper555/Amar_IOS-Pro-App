//
//  RootViewController.swift
//  Plumbal
//
//  Created by Casperon Tech on 30/11/15.
//  Copyright © 2015 Casperon Tech. All rights reserved.
//

import UIKit
import MPGNotification
import NVActivityIndicatorView
import JTAlertView
import NotificationView

class RootViewController: UIViewController {
    
    var Window:UIWindow=UIWindow()
    var notification:MPGNotification=MPGNotification()
    var buttonArray:NSArray=NSArray()
    let activityTypes: [NVActivityIndicatorType] = [
        .ballPulse]
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 75, height: 100),
                                                        type: .ballScaleMultiple)
    let activityforLoadServices = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 75, height: 100),
                                                                type: .ballRotateChase)

    var AlertView:JTAlertView=JTAlertView()
    var Is_alertshown:Bool=Bool()
      var reloadpage:String = ""
    var userIdforChat : String = ""
    var taskIDforChat : String = ""
    //MARK: - Override Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if(theme.Check_userID() != "") {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowPayment"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowNotification"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowAccountStatus"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowAdminNotification"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowRating"), object: nil)
            NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "Message_notify"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceiveChatToRootView"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceivePushChatToRootView"), object: nil)

//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowPushNotification"), object: nil)
            NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "ShowPushRating"), object: nil)
            NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "ShowPushPayment"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Language_Notification as String as String), object: nil)

            NotificationCenter.default.removeObserver(self)


            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.showPopup(_:)), name: NSNotification.Name(rawValue: "ShowPayment"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.Show_Alert(_:)), name: NSNotification.Name(rawValue: "ShowNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.Show_account_status_Alert(_:)), name: NSNotification.Name(rawValue: "ShowAccountStatus"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.Show_Admin_notification_Alert(_:)), name: NSNotification.Name(rawValue: "ShowAdminNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.Show_rating(_:)), name: NSNotification.Name(rawValue: "ShowRating"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.ConfigureNotification(_:)), name: NSNotification.Name(rawValue: "Message_notify"), object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.methodOfReceivedMessagePushNotification(_:)), name:NSNotification.Name(rawValue: "ReceivePushChatToRootView"), object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.methodOfReceivedMessageNotification(_:)), name:NSNotification.Name(rawValue: "ReceiveChatToRootView"), object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(self.methodofReceivePushNotification(_:)), name:NSNotification.Name(rawValue: "ShowPushNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.methodofReceiveRatingNotification(_:)), name:NSNotification.Name(rawValue: "ShowPushRating"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.methodofReceivePaymentNotification(_:)), name:NSNotification.Name(rawValue: "ShowPayment"), object: nil)
        }else
        {

        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(theme.Check_userID() != "") {
//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowPayment"), object: nil)
//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowNotification"), object: nil)
//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowRating"), object: nil)
//            NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "Message_notify"), object: nil)
//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceiveChatToRootView"), object: nil)
//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceivePushChatToRootView"), object: nil)
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowPushNotification"), object: nil)
//            NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "ShowPushRating"), object: nil)
//            NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "ShowPushPayment"), object: nil)
//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Language_Notification as String as String), object: nil)
//
//            NotificationCenter.default.removeObserver(self)
            
//
//            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.showPopup(_:)), name: NSNotification.Name(rawValue: "ShowPayment"), object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.Show_Alert(_:)), name: NSNotification.Name(rawValue: "ShowNotification"), object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.Show_rating(_:)), name: NSNotification.Name(rawValue: "ShowRating"), object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.ConfigureNotification(_:)), name: NSNotification.Name(rawValue: "Message_notify"), object: nil)
//
//            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.methodOfReceivedMessagePushNotification(_:)), name:NSNotification.Name(rawValue: "ReceivePushChatToRootView"), object: nil)
//
//            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.methodOfReceivedMessageNotification(_:)), name:NSNotification.Name(rawValue: "ReceiveChatToRootView"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.methodofReceivePushNotification(_:)), name:NSNotification.Name(rawValue: "ShowPushNotification"), object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.methodofReceiveRatingNotification(_:)), name:NSNotification.Name(rawValue: "ShowPushRating"), object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.methodofReceivePaymentNotification(_:)), name:NSNotification.Name(rawValue: "ShowPayment"), object: nil)
        }else
        {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowPushNotification"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       // NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    //MARK: - Function
    
    func showProgress(){
//        self.activityIndicatorView.color = themes.DarkRed()
        self.activityIndicatorView.color = PlumberThemeColor
        self.activityIndicatorView.center=CGPoint(x: self.view.frame.size.width/2,y: self.view.frame.size.height/2);
        self.activityIndicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.view.addSubview(activityIndicatorView)
    }
    
    func DismissProgress(){
        self.activityIndicatorView.stopAnimating()
         self.view.isUserInteractionEnabled = true
        self.activityIndicatorView.removeFromSuperview()
    }
    
    func showServiceProgress(rect : CGRect){
        self.activityforLoadServices.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        self.activityforLoadServices.color = themes.DarkRed()
        self.activityforLoadServices.color = PlumberThemeColor
        self.activityforLoadServices.center=CGPoint(x: rect.width/2,y: (rect.height/2)-20);
        self.activityforLoadServices.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.view.addSubview(activityforLoadServices)
    }
    
    func DismissServiceProgress(){
        self.activityforLoadServices.stopAnimating()
        self.view.isUserInteractionEnabled = true
        self.activityforLoadServices.removeFromSuperview()
    }
    
    func Logout(){
       // Appdel.CheckDisconnect()
        self.DismissProgress()
        let _: String = Bundle.main.bundleIdentifier!
        Appdel.MakeRootVc("SplashPage")
    }
    
    
    //MARK: - Notification Function
    
    @objc func ConfigureNotification(_ notif:Notification)  {
        if(Is_alertshown == false) {
            Is_alertshown=true
            let userInfo:Dictionary<String,String> = notif.userInfo as! Dictionary<String,String>
            let Job_Id = userInfo["Order_id"]
            let username = userInfo["username"]
            let MessageString = userInfo["Message"]
            buttonArray=["Reply"]
            notification=MPGNotification()
            notification = MPGNotification(title: username, subtitle: MessageString, backgroundColor: theme.ThemeColour(), iconImage: UIImage(named:"chaticon"))
            notification.setButtonConfiguration(MPGNotificationButtonConfigration(rawValue: buttonArray.count)! , withButtonTitles: buttonArray as! [NSArray])
            notification.duration = 4.0;
            notification.swipeToDismissEnabled = true;
            notification.titleColor=UIColor.white
            notification.subtitleColor=UIColor.white
            notification.animationType=MPGNotificationAnimationType.drop
            notification.buttonHandler = {(notification: MPGNotification!, buttonIndex: Int) -> Void in
//                Order_data.job_id=Job_Id!
                var mainView: UIStoryboard!
                mainView = UIStoryboard(name: "Main", bundle: nil)
                let secondViewController = mainView.instantiateViewController(withIdentifier: "MessageVC") as! MessageViewController
                self.navigationController?.pushViewController(withFade: secondViewController, animated: false)
            }
            notification.show()
        }
    }
    
    @objc func methodOfReceivedMessagePushNotification(_ notification: Notification){
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        // or as! Sting or as! Int
        let check_userid = userInfo["from"]
        _ = userInfo["message"]
        let taskid=userInfo["task"]
        if (check_userid == theme.getUserID())
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
                   /* Message_details.taskid = taskid!
                    Message_details.providerid = check_userid!*/
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageViewController
                    self.navigationController?.pushViewController(withFade: secondViewController, animated: false)
                }
                
            }
        }
    }

    @objc func methodofReceivePaymentNotification(_ notification: Notification){
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        let Order_id = userInfo["Order_id"]
        if(Order_id != nil) {
//            Root_Base.Job_ID=Order_id!
//            Order_data.job_id = Order_id!
        }
        if let activeController = navigationController?.visibleViewController {
            if activeController.isKind(of: MessageViewController.self){
                NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
            }
    
//        let Controller:PaymentViewController=self.storyboard?.instantiateViewController(withIdentifier: "payment") as! PaymentViewController
//        self.navigationController?.pushViewController(withFlip: Controller, animated: true)
        }
    }
    
    @objc func methodofReceiveRatingNotification(_ notification: Notification){
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        let Order_id = userInfo["Order_id"]
        if(Order_id != nil) {
//            Root_Base.Job_ID=Order_id!
//            Order_data.job_id = Order_id!
        }
         if let activeController = navigationController?.visibleViewController {
        if activeController.isKind(of: MessageViewController.self){
            NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
        }
        let Controller:RatingsViewController=self.storyboard?.instantiateViewController(withIdentifier: "ReviewPoup") as! RatingsViewController
        self.navigationController?.pushViewController(withFade: Controller, animated: false)
        }
    }
    
    
    @objc func methodofReceivePushNotification(_ notification: Notification){
        var reloadpage:String = ""
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        let Order_id = userInfo["Order_id"]
        if(Order_id != nil) {
            /*if   Root_Base.Job_ID == Order_id
            {
                reloadpage = "1"
            }
            else
            {
                reloadpage = "0"
            }*/
//            Root_Base.Job_ID=Order_id!
//            Order_data.job_id = Order_id!
        }
        
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if let activeController = appDel.window!.visibleViewController() {
            print("activeController =>\(activeController)")
                if activeController.isKind(of: MessageViewController.self){
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                }
            /*if activeController.isKind(of: JobDetailViewController.self) {
                if reloadpage == "1" {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadpage"), object: nil, userInfo: nil)
                }
            } else {
                let Controller:JobDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "jobDetail") as! JobDetailViewController
                self.navigationController?.pushViewController(withFade: Controller, animated: false)
            }*/
        }
    }
    
    @objc func methodOfReceivedMessageNotification(_ notification: Notification){
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        let check_userid = userInfo["from"]
        let messageString = userInfo["message"]
        let taskid=userInfo["task"]
        
        let title = ""
        let subtitle = Appname
        let body = messageString
        let image =  #imageLiteral(resourceName: "applogo")
        let notificationView = NotificationView.default
        notificationView.title = title
        notificationView.subtitle = subtitle
        notificationView.body = body
        notificationView.image = image
        notificationView.hideDuration = TimeInterval(3.0)
        notificationView.theme = .default
        notificationView.identifier = "updateChat"
    
        if (check_userid != theme.getUserID())  {
            if let activeController = navigationController?.visibleViewController {
                if activeController.isKind(of: MessageViewController.self){
                    notificationView.identifier = ""
                }else{
                        taskIDforChat = taskid!
                        userIdforChat = check_userid!
                    
//              AudioServicesPlayAlertSound(1315);
                    notificationView.delegate = self
                    notificationView.show()
                }
            }
        }
    }
    
    @objc func Show_rating(_ notification: Notification) {
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        let messageString = userInfo["Message"]
        let Order_id = userInfo["Order_id"]
        let action = userInfo["Action"]
        if(Order_id != nil) {
//            Root_Base.Job_ID=Order_id!
//            Order_data.job_id = Order_id!
        }
        var title = action
        title = title?.replacingOccurrences(of: "_", with: " ")
        title = title?.capitalizingFirstLetter()
        let body = messageString
        let image =  #imageLiteral(resourceName: "applogo")
        let notificationView = NotificationView.default
        notificationView.appNameLabel.text = ProductAppName
        notificationView.iconImageView.image = image
        notificationView.title = title
//        notificationView.subtitle = subtitle
        notificationView.body = body
        notificationView.image = image
        notificationView.hideDuration = TimeInterval(3.0)
        notificationView.theme = .default
        if (navigationController?.visibleViewController) != nil {
            if action == "payment_paid"
            {
                notificationView.identifier = "payment_paid"
            }
//                if activeController.isKind(of: MessageViewController.self){
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
//                }
//                let alertView = UNAlertView(title: Appname, message:messageString!)
//                alertView.addButton(themes.setLang("ok"), action: {
////                    let Controller:RatingsViewController=self.storyboard?.instantiateViewController(withIdentifier: "ReviewPoup") as! RatingsViewController
////                    self.navigationController?.pushViewController(withFlip: Controller, animated: true)
//
//                })
            notificationView.delegate = self
//            AudioServicesPlayAlertSound(1315);
            notificationView.show()
//                alertView.show()
            
        }
    }
    
    @objc  func showPopup(_ notification: Notification) {
        var reloadpage:String = ""
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        let messageString = userInfo["Message"]
        let Order_id = userInfo["Order_id"]
        if(Order_id != nil){
            /*if Root_Base.Job_ID == Order_id
            {
                reloadpage = "1"
            }
            else{
                
                reloadpage = "0"
            }
            Root_Base.Job_ID=Order_id!
//            Order_data.job_id = Order_id!*/
        }
        
        if let activeController = navigationController?.visibleViewController {
           
                if activeController.isKind(of: MessageViewController.self){
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])
                }
                let alertView = UNAlertView(title: Appname, message:messageString!)
                alertView.addButton(theme.setLang("ok"), action: {
                   /* if activeController.isKind(of: PaymentViewController.self){
                        if reloadpage == "1"
                        {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadpage"), object: nil, userInfo: nil)

                        }else
                        {
                        let Controller:PaymentViewController=self.storyboard?.instantiateViewController(withIdentifier: "payment") as! PaymentViewController
                        self.navigationController?.pushViewController(withFade: Controller, animated: false)
                        }
                    }else
                    {
                        let Controller:PaymentViewController=self.storyboard?.instantiateViewController(withIdentifier: "payment") as! PaymentViewController
                        self.navigationController?.pushViewController(withFade: Controller, animated: false)

                    }*/
                })
//                AudioServicesPlayAlertSound(1315);

                alertView.show()
            
        }
    }
    
    @objc func Show_Admin_notification_Alert(_ notification:Notification){
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        let messageString = userInfo["Message"]
        let action = userInfo["Action"]
        
        var title = action
        title = title?.replacingOccurrences(of: "_", with: " ")
        title = title?.capitalizingFirstLetter()
        _ = ProductAppName
        let body = messageString
        let image =  #imageLiteral(resourceName: "applogo")
        let notificationView = NotificationView.default
        //        notificationView.appNameLabel.text = title
        notificationView.iconImageView.image = image
        notificationView.title = ""
        notificationView.subtitle = title
        notificationView.body = body
        notificationView.image = image
        notificationView.hideDuration = TimeInterval(3.0)
        notificationView.theme = .default
        
        notificationView.delegate = self
//        AudioServicesPlayAlertSound(1315);
        notificationView.show()
    }
    
    @objc func Show_account_status_Alert(_ notification:Notification){
        
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        let messageString = userInfo["Message"]
        let action = userInfo["Action"]
        
        let alertView = UNAlertView(title: ProductAppName, message:messageString ?? "")
        alertView.addButton(theme.setLang("ok"), action: {
            if action == "account_status"{
                let Appdel = UIApplication.shared.delegate as! AppDelegate
                SocketIOManager.sharedInstance.LeaveRoom(theme.getUserID())
                SocketIOManager.sharedInstance.LeaveChatRoom(theme.getUserID())
                SocketIOManager.sharedInstance.RemoveAllListener();
                dbfileobj.deleteUser("Provider_Table")
                let _: String = Bundle.main.bundleIdentifier!
                
                UserDefaults.standard.removeObject(forKey: "userID")
                UserDefaults.standard.removeObject(forKey: "EmailID")
                
                Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "signinVCID")
            }
        })
//        AudioServicesPlayAlertSound(1315);
        
        alertView.show()
    }
    
    @objc func Show_Alert(_ notification:Notification){
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        let messageString = userInfo["Message"]
        let Order_id = userInfo["Order_id"]
        let action = userInfo["Action"]

        if(Order_id != nil) {
           /* if   Root_Base.Job_ID == Order_id
            {
                reloadpage = "1"
            }
            else
            {
                reloadpage = "0"
            }
            Root_Base.Job_ID=Order_id!
//            Order_data.job_id = Order_id!*/
        }
        var title = action
        title = title?.replacingOccurrences(of: "_", with: " ")
        title = title?.capitalizingFirstLetter()
        _ = ProductAppName
        let body = messageString
        let image =  #imageLiteral(resourceName: "applogo")
        let notificationView = NotificationView.default
//        notificationView.appNameLabel.text = title
        notificationView.iconImageView.image = image
        notificationView.title = ""
        notificationView.subtitle = title
        notificationView.body = body
        notificationView.image = image
        notificationView.hideDuration = TimeInterval(3.0)
        notificationView.theme = .default
         if action == "job_completed"
         {
            notificationView.identifier = "completed"
         }
        if action == "payment_paid"
        {
            notificationView.identifier = "payment_paid"
        }
         else if action != "admin_notification"{
            notificationView.identifier = "jobalert"
         }

        notificationView.delegate = self
//        AudioServicesPlayAlertSound(1315);
        notificationView.show()
     /*   if let activeController = navigationController?.visibleViewController {
            if activeController.isKind(of: OrderDetailViewController.self){
                
                let alertView = UNAlertView(title: Appname, message:messageString!)
                alertView.addButton(themes.setLang("ok"), action: {
                    if action != "admin_notification"{
                        if reloadpage == "1"
                        {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadpage"), object: nil, userInfo: nil)
                        }
                        else
                        {
                            let Controller:JobDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "jobDetail") as! JobDetailViewController
                            self.navigationController?.pushViewController(withFlip: Controller, animated: true)

                        }
                        
                    }
                })
                AudioServicesPlayAlertSound(1315);
                
                alertView.show()

            }else{
                
                if activeController.isKind(of: MessageViewController.self){
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "Dismisskeyboard"), object: nil, userInfo: ["message":"","from":"","task":"","msgid":"" ,"taskerstus":""])

                    let alertView = UNAlertView(title: Appname, message:messageString!)
                    alertView.addButton(themes.setLang("ok"), action: {
                        if action != "admin_notification"{

                        let Controller:JobDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "jobDetail") as! JobDetailViewController
                        self.navigationController?.pushViewController(withFlip: Controller, animated: true)
                        }
                    })
                   AudioServicesPlayAlertSound(1315);

                    alertView.show()

                }else if activeController.isKind(of: LocationViewController.self){
                    let alertView = UNAlertView(title: Appname, message:messageString!)
                    alertView.addButton(themes.setLang("ok"), action: {
                        if action != "admin_notification"{

                        self.navigationController!.popViewControllerWithFlip(animated: true)
                        }
                    })
                  AudioServicesPlayAlertSound(1315);

                    alertView.show()
                    
                }else{
                let alertView = UNAlertView(title: Appname, message:messageString!)
                alertView.addButton(themes.setLang("ok"), action: {
                    if action != "admin_notification"{
                        if action == "job_completed" {
                            Root_Base.Job_ID=Order_data.job_id
                            Root_Base.task_id = OrderDetail_data.task_id
                            let Controller:PaymentViewController=self.storyboard?.instantiateViewController(withIdentifier: "payment") as! PaymentViewController
                            self.navigationController?.pushViewController(withFlip: Controller, animated: true)
                        }else{
                    let Controller:JobDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "jobDetail") as! JobDetailViewController
                    self.navigationController?.pushViewController(withFlip: Controller, animated: true)
                        }
                    }
                    })
                   AudioServicesPlayAlertSound(1315);

                alertView.show()
                }
            }
        }*/
    }
    
    
    func notificationView(_ notification: MPGNotification, didDismissWithButtonIndex buttonIndex: Int) {
        NSLog("Button Index = %ld", Int(buttonIndex))
    }
    
    //MARK: - Button Action
    
    @IBAction func didDismissSegue(_ segue: UIStoryboardSegue) {
        
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
}

//extension UITextField {
//    func isMandatory(){
//        let label = UILabel()
//        label.frame = CGRect(x: 0, y: 0, width: 10,height: self.frame.height)
//        label.text = "*"
//        label.textColor = UIColor.red
//        self.rightView = label
//        self.rightViewMode = UITextField.ViewMode .always
//    }
//}
extension RootViewController: NotificationViewDelegate {
    func notificationViewWillAppear(_ notificationView: NotificationView) {
        print("delegate: notificationViewWillAppear")
    }
    func notificationViewDidAppear(_ notificationView: NotificationView) {
        print("delegate: notificationViewDidAppear")
    }
    func notificationViewWillDisappear(_ notificationView: NotificationView) {
        print("delegate: notificationViewWillDisappear")
    }
    func notificationViewDidDisappear(_ notificationView: NotificationView) {
        print("delegate: notificationViewDidDisappear")
    }
    func notificationViewDidTap(_ notificationView: NotificationView) {
        print("delegate: notificationViewDidTap")
        
        if notificationView.identifier == "job_completed"
        {
            if let activeController = navigationController?.visibleViewController {
            /*if activeController.isKind(of: PaymentViewController.self){
                if reloadpage == "1"
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadpage"), object: nil, userInfo: nil)
                    
                }else
                {
                    let Controller:PaymentViewController=self.storyboard?.instantiateViewController(withIdentifier: "payment") as! PaymentViewController
                    self.navigationController?.pushViewController(withFade: Controller, animated: false)
                }
            }else
            {
                let Controller:PaymentViewController=self.storyboard?.instantiateViewController(withIdentifier: "payment") as! PaymentViewController
                self.navigationController?.pushViewController(withFade: Controller, animated: false)
            }*/
            }
        }else if notificationView.identifier == "updateChat"{
            if let activeController = navigationController?.visibleViewController {
                if activeController.isKind(of: MessageViewController.self){
                }else{
            /*Message_details.taskid = taskIDforChat
            Message_details.providerid = userIdforChat*/
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageViewController
            self.navigationController?.pushViewController(withFade: secondViewController, animated: false)
            }
            }
        }
        else if notificationView.identifier == "payment_paid"{
            if let activeController = navigationController?.visibleViewController {
                /*if activeController.isKind(of: PaymentViewController.self){
                    if reloadpage == "1"
                    {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadpage"), object: nil, userInfo: nil)
                    }
                    else
                    {
                        let Controller:RatingsViewController=self.storyboard?.instantiateViewController(withIdentifier: "ReviewPoup") as! RatingsViewController
                        self.navigationController?.pushViewController(withFade: Controller, animated: false)
                    }
                }
                else
                {
                    let Controller:RatingsViewController=self.storyboard?.instantiateViewController(withIdentifier: "ReviewPoup") as! RatingsViewController
                    self.navigationController?.pushViewController(withFade: Controller, animated: false)
                }*/
            }
        }
        else if notificationView.identifier == "jobalert"
        {
            if let activeController = navigationController?.visibleViewController {
                /*if activeController.isKind(of: JobDetailViewController.self){
                    if reloadpage == "1"
                    {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadpage"), object: nil, userInfo: nil)
                    }
                    else
                    {
                        let Controller:JobDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "jobDetail") as! JobDetailViewController
                        self.navigationController?.pushViewController(withFade: Controller, animated: false)
                    }
                }
                else
                {
                    let Controller:JobDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "jobDetail") as! JobDetailViewController
                    self.navigationController?.pushViewController(withFade: Controller, animated: false)
                }*/
            }
        }
    }
}

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    static func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if let navigationController = vc as? UINavigationController,
            let visibleController = navigationController.visibleViewController  {
            return UIWindow.getVisibleViewControllerFrom( vc: visibleController )
        } else if let tabBarController = vc as? UITabBarController,
            let selectedTabController = tabBarController.selectedViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: selectedTabController )
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc
            }
        }
    }
}
