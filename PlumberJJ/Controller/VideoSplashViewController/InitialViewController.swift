//
//  InitialViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/18/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import AuthenticationServices
import KeychainSwift
import PhoneNumberKit
class InitialViewController: RootBaseViewController,CLLocationManagerDelegate,MICountryPickerDelegate/*, UIPageViewControllerDataSource, UIPageViewControllerDelegate */{
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var viewOTpBack: extensionView!
    var locationManager = CLLocationManager()
    let Themes = Theme()
    var dicFbData = NSDictionary()
    var firstName = String()
    var lastName = String()
    
    @IBOutlet weak var CountryFlag: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var MobileTextField: UITextField!
    @IBOutlet weak var txtMobileVerify:UITextField!
    
    var keyboardheight : CGFloat = 0.0
    var OTPStatus = String()
    var UserType = String()
    var OTP = String()
    var CountryCode = String()
    @IBOutlet weak var viewOtp:UIView!
    @IBOutlet weak var viewotpButton:UIView!
    var isMobileVerify = false
    var phonenumber = String()
    var countryCodeNew = String()
    var isLoginLocation = false
    var appleEmail = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
        SetUI()
        
    }
    func SetUI(){
        isMobileVerify = false
        MobileTextField.delegate = self
        MobileTextField.placeholder = "08123456789"
       // MobileTextField.becomeFirstResponder()
        lblCountryCode.adjustsFontSizeToFitWidth = true
        self.Themes.Set(CountryCode: lblCountryCode, WithFlag: CountryFlag)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.viewOTpBack.isHidden = true
        self.imgLogo.isHidden=false
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
        self.locationManager.pausesLocationUpdatesAutomatically = true
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
       
        guard let currentlocation = locations.first else {
            return
        }
        let geocoder = CLGeocoder()
        print(currentlocation)
        geocoder.reverseGeocodeLocation(currentlocation) { (placemarks, error) in
            guard let currentLocPlacemark = placemarks?.first else { return }
            print("get country",currentLocPlacemark.country ?? "No country found")
            print("get iso country",currentLocPlacemark.isoCountryCode ?? "No country code found")
            let isocountry_codenew  = currentLocPlacemark.isoCountryCode ?? "IN"
            
            let dictCodes : NSDictionary = self.theme.getCountryList()
            print(dictCodes)
           // let code = (dictCodes.value(forKey: isocountry_codenew)as! NSArray)[1] as? String
            let flag = (dictCodes.value(forKey: isocountry_codenew)as! NSArray)[0] as? String
          
            
            if self.isLoginLocation == false
            {
                self.theme.saveCountryCode(isocountry_codenew)
               // self.lblCountryCode.text = "+" + code!
                self.CountryFlag.image = UIImage(named: flag ?? "")
                self.Themes.Set(CountryCode: self.lblCountryCode, WithFlag: self.CountryFlag)
                self.isLoginLocation = true
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: kLocationNotification), object:nil,userInfo :nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardheight = keyboardRectangle.height
        // do whatever you want with this keyboard height
       
    }
    
    @IBAction func didclickCountry(_ sender: Any) {
        let  country = MICountryPicker()
        country.delegate = self
        country.showCallingCodes = true
            if let navigator = self.navigationController
            {
                navigator.pushViewController(country, animated: true)
            }
    }
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {}
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String, countryFlagImage: UIImage) {
        lblCountryCode.text = dialCode
        CountryFlag.image = countryFlagImage
        picker.navigationController?.popAnimationFade(animated: true)
        MobileTextField.becomeFirstResponder()
    }
    @IBAction func btnGetOptAction(_ sender: AnyObject)
    {
        if (MobileTextField.text?.count)! >= MinimummobileValidation
        {
            let phoneNumberKit = PhoneNumberKit()
            let countryInt = UInt64 (lblCountryCode.text!)
            let country =  phoneNumberKit.mainCountry(forCode: countryInt!)
            
            let regionCode = self.Themes.CheckMobileNoAndCountryCodeIsValid(countryCode: lblCountryCode.text!, phoneNumber: MobileTextField.text!)
            if regionCode == country ?? ""
            {
                self.RemoveDB()
                self.showProgress()
                let PhoneDict : NSDictionary = ["code":"\(lblCountryCode.text ?? "")",
                                                "number":"\(MobileTextField.text ?? "")"]
                let Parameter : NSDictionary = ["phone" : PhoneDict]
                
                url_handler.makeCall(MobileLoginUrl , param: Parameter as NSDictionary) {
                    (responseObject, error) -> () in
                    if(error != nil)
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                        self.DismissProgress()
                    }
                    else
                    {
                        if(responseObject != nil && (responseObject?.count)!>0)
                        {
                            let responseObject = responseObject as? [String:Any] ?? [:]
                            let status=self.Themes.CheckNullValue(responseObject["status"])
                            if(status == "1"){
                                print(responseObject)
                                
                                
                                self.OTPStatus = self.Themes.CheckNullValue(responseObject["otp_status"])
                                self.UserType = self.Themes.CheckNullValue(responseObject["user_type"])
                                self.OTP = self.Themes.CheckNullValue(responseObject["otp"])
                                let objPhoneDict = responseObject["phone"] as? [String:Any] ?? [:]
                                self.CountryCode = self.Themes.CheckNullValue(objPhoneDict["code"])
                                SessionManager.sharedinstance.ExpertsAvailableRadius = self.Themes.CheckNullValue(responseObject["radius"])
                                Registerrec["radius"] = SessionManager.sharedinstance.ExpertsAvailableRadius
                                self.viewOtp.isHidden = false
                                self.viewotpButton.isHidden = false
                                self.DismissProgress()
                                
                                
                                self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("enter_sent_OTP", comment: nil), ButtonTitle: kOk)
                                
                            }
                            else{
                                 let Error = self.Themes.CheckNullValue(responseObject["msg"])
                                self.Themes.AlertView(appNameJJ, Message: Error, ButtonTitle: kOk)
                                self.DismissProgress()
                                
                            }
                        }else{
                            self.view.makeToast(message:Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                            self.DismissProgress()
                        }
                    }
                }
            }
            else
            {
                self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Mobile No Doesn't Match With Country Code", comment: nil), ButtonTitle: kOk)
                
            }
        }
        else
        {
            self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("valid_Mobile", comment: nil), ButtonTitle: kOk)
        }

    }
    @IBAction func btnResendOtpAction(_ sender: AnyObject)
    {
        if (MobileTextField.text?.count)! >= MinimummobileValidation
        {
            GetOtp()
        }
        else{
            self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("valid_Mobile", comment: nil), ButtonTitle: kOk)
        }
    }
    func GetOtp(){
        let PhoneDict : NSDictionary = ["code":lblCountryCode.text!,
                                        "number":MobileTextField.text!]
        let Parameter : NSDictionary = ["phone" : PhoneDict]
        url_handler.makeCall(MobileLoginUrl, param: Parameter as NSDictionary, completionHandler:{ (responseObject, error) -> () in
            if(error != nil)
            {
                self.Themes.AlertView("", Message: kErrorMsg, ButtonTitle: kOk)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.Themes.CheckNullValue(responseObject["status"])
                    if(status == "1"){
                        print(responseObject)
                        let Otp = self.Themes.CheckNullValue(responseObject["otp"])
                        let OtpStatus = self.Themes.CheckNullValue(responseObject["otp_status"])
                        let userType = self.Themes.CheckNullValue(responseObject["user_type"])
                        let Phone = responseObject["phone"] as? [String:Any] ?? [:]
                        let code = self.Themes.CheckNullValue(Phone["code"])
                        let number = self.Themes.CheckNullValue(Phone["number"])
                        
                        self.UserType = userType
                        self.CountryCode = code
                        
                        self.OTP = Otp
                        self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("enter_sent_OTP", comment: nil), ButtonTitle: kOk)
                    }
                    
                    else{
                        let Error = self.Themes.CheckNullValue(responseObject["errors"])
                        self.Themes.AlertView("", Message: Error , ButtonTitle: kOk)
                        
                    }
                }else{
                    self.Themes.AlertView("", Message: Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), ButtonTitle: kOk)
                }
            }
        })
    }
    @IBAction func btnVerificationPhoneNumberAction(_ sender: Any)
    {
        if txtMobileVerify.text! == ""
        {
            self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("enter_sent_OTP", comment: nil), ButtonTitle: kOk)
        }
        else
        {
            if txtMobileVerify.text! == OTP
            {
                self.theme.saveCountryCode(lblCountryCode.text ?? "")
                Themes.AlertView("", Message: Language_handler.VJLocalizedString("Phone Verify successfully", comment: nil), ButtonTitle: kOk)
                
                if UserType == "existing"
                {
                    self.viewOtp.isHidden = true
                    self.viewotpButton.isHidden = true
                    isMobileVerify = true
                    phonenumber = MobileTextField.text!
                    countryCodeNew = lblCountryCode.text!
                   
                    
                    
                    
                }
                else
                {
                    self.viewOtp.isHidden = true
                    self.viewotpButton.isHidden = true
                    isMobileVerify = true
                    phonenumber = MobileTextField.text!
                    countryCodeNew = lblCountryCode.text!
                }
                
                self.viewOTpBack.isHidden = true
                self.imgLogo.isHidden=false
            }
            else
            {
                self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Enter_Valid_Otp", comment: nil), ButtonTitle: kOk)
            }
        }
    }
    @IBAction func btnContiuneMobileAction(_ sender: Any)
    {
        if isMobileVerify == false
        {
            self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Please verify Mobile", comment: nil), ButtonTitle: kOk)
        }
        else
        {
            self.HitLogInCall()
            if UserType == "existing"
            {
                self.HitLogInCall()
            }
            else
            {
                self.MovetoVarifyVC(PhoneNumber: self.MobileTextField.text ?? "", Email: "", isEmail: false, isMobile: true, socialtype: "mobile", socialId: "")
                //self.MoveToRegister()
            }
        }
    }
    
    func MovetoVarifyVC(PhoneNumber : String , Email: String,isEmail:Bool,isMobile:Bool,socialtype:String,socialId:String)
    {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFirstPageViewController") as? RegFirstPageViewController{
            if let navigator = self.navigationController
            {
                
                if isMobile
                {
                    let PhoneDict : NSDictionary = ["code":"\(lblCountryCode.text ?? "" )",
                                                    "number":"\(MobileTextField.text ?? "")"]
                    viewController.PhoneDict = PhoneDict
                    viewController.phoneCodeImage = CountryFlag.image!
                  
                    if isEmail == true
                    {
                        viewController.emailVerify = Email
                    }
                }
                
                if isEmail
                {
                    viewController.emailVerify  = Email
                }
                viewController.socialtype = socialtype
                viewController.socialId = socialId
                viewController.isEmailVerify = isEmail
                viewController.isMobileVerify = isMobile
                viewController.firstName = firstName
                viewController.lastName = lastName
                viewController.appleEmail = appleEmail
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
    }
    
    func MoveToRegister(){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFirstPageViewController") as? RegFirstPageViewController{
            if let navigator = self.navigationController
            {
                let PhoneDict : NSDictionary = ["code":"\(countryCodeNew )",
                                                "number":"\(phonenumber )"]
                viewController.PhoneDict = PhoneDict
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
    }
    func HitLogInCall() {
        self.showProgress()
        
        if self.phonenumber.count == 0
        {
            phonenumber = MobileTextField.text ?? "09900999"
        }
        //phonenumber = MobileTextField.text!
        countryCodeNew = lblCountryCode.text!
        let Parameter : NSDictionary = ["phone_number" : "\(phonenumber)",
                                        "deviceToken" : self.Themes.GetDeviceToken() as String,
                                        "gcm_id" : ""
                                       ]
        print(Parameter)
        print(LoginUrl)
       
        url_handler.makeCall(LoginUrl, param: Parameter as NSDictionary) {
            (responseObject, error) -> () in
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                self.DismissProgress()
                
            }else{
                self.DismissProgress()
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    print(responseObject)
                    let status=self.Themes.CheckNullValue(responseObject["status"])
                    if(status == "1"){
                        self.Themes.saveVerifiedStatus(VerifiedStatus: 1)
                        self.Themes.saveUserDetail(responseObject["response"] as! NSDictionary)
                        let ResponseDict = responseObject["response"] as? [String : Any] ?? [:]
                        let CurrencyCode : String = self.Themes.getCurrencyCode(self.Themes.CheckNullValue(ResponseDict["currency"]))
                        self.Themes.saveappCurrencycode(CurrencyCode as String)
                        let FirstName = self.Themes.CheckNullValue(ResponseDict["firstname"])
                        let LastName = self.Themes.CheckNullValue(ResponseDict["lastname"])
                        let FullName = "\(FirstName)\(" ")\(LastName)"
                        self.Themes.saveFullName(UserName: FullName)
                        
                        let _:UserInfoRecord=self.Themes.GetUserDetails()
                        SocketIOManager.sharedInstance.establishConnection()
                        SocketIOManager.sharedInstance.establishChatConnection()
                        if(self.Themes.isUserLigin()){
                            self.MoveToApp()
                        }
                        print(responseObject)
                        
                    }else if (status == "3") || (status == "2"){
                        self.Themes.saveVerifiedStatus(VerifiedStatus: 0)
                        self.Themes.saveUserDetail(responseObject["response"] as! NSDictionary)
                        let ResponseDict = responseObject["response"] as? [String : Any] ?? [:]
                        let CurrencyCode : String = self.Themes.getCurrencyCode(self.Themes.CheckNullValue(ResponseDict["currency"]))
                        self.Themes.saveappCurrencycode(CurrencyCode as String)
                        
                        let _:UserInfoRecord=self.Themes.GetUserDetails()
                        SocketIOManager.sharedInstance.establishConnection()
                        SocketIOManager.sharedInstance.establishChatConnection()
                        if(self.Themes.isUserLigin()){
                            self.MoveToApp()
                        }
                        
                        //print(responseObject)
                        
                    }
                    else
                    {
                        //MARK: - OTp handle
                        
                        let data = responseObject["response"] as? String ?? ""

                        self.view.makeToast(message:data, duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                        if  status == "0" && self.phonenumber.count == 0
                        {
                            self.viewOTpBack.isHidden = false
                            self.imgLogo.isHidden=true
                        }
                    }
                    
                }else{
                    self.view.makeToast(message:Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                   
                }
            }
        }
    }
    func MoveToApp(){
        self.perform(#selector(self.updateAvailbility), with: nil, afterDelay: 0.5)
        self.Themes.UpdateAvailability("1")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewcontroller()
        let socStr:NSString = ""//dict.objectForKey("soc_key") as! NSString
        if(socStr.length>0){
            self.Themes.saveJaberPassword(socStr as String)
        }
    }
    @objc func updateAvailbility(){
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["tasker":"\(objUserRecs.providerId)","availability" :"1"]
        
        url_handler.makeCall(EnableAvailabilty, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status=self.Themes.CheckNullValue(responseObject.object(forKey: "status"))
                    if(status == "1")
                    {
                        let resDict: NSDictionary = responseObject.object(forKey: "response") as! NSDictionary
                        let tasker_status : String = self.Themes.CheckNullValue(resDict.object(forKey: "tasker_status"))
                        
                        if (tasker_status == "1")
                        {
                            self.view.makeToast(message:"Your availability is ON", duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                            self.Themes.saveAvailable_satus("GO OFFLINE")
                        }
                        else
                        {
                            self.view.makeToast(message:"Your availability is OFF", duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                            self.Themes.saveAvailable_satus("GO ONLINE")
                        }
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
            }
        }
    }
    
    func RemoveDB () {
        ObjCatArray.Sharedinstance.CategoryMainObj.removeAll()
        ObjCatArray.Sharedinstance.CAtRec.id = ""
        ObjCatArray.Sharedinstance.CAtRec.image = ""
        ObjCatArray.Sharedinstance.CAtRec.name = ""
    }
    
 
    @IBAction func didClickRegisterBtn(_ sender: AnyObject) {

        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFirstPageViewController") as? RegFirstPageViewController{
        if let navigator = self.navigationController
        {
            navigator.pushViewController(withFade:viewController , animated: false)
        }
    }
    }
    


    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - btnGoogleLoginAction
    @IBAction func btnGoogleLoginAction(_ sender : Any)
    {
       
//        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFourthPageViewController") as? RegFourthPageViewController{ //RegFirstPageViewController //RegFourthPageViewController
//            if let navigator = self.navigationController
//            {
//                navigator.pushViewController(withFade: viewController, animated: false)
//            }
//        }
//
        
        let signInConfig = GIDConfiguration.init(clientID: "391955278457-papsbs9scatos6kl72bfjo4tg6267h30.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signOut()
        
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
            } else {
                GIDSignIn.sharedInstance.signOut()
            }
          }

        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }

            let emailAddress = user.profile?.email
            var userid = String()
            if let id = user.userID
            {
                userid = id
            }
           
           // let fullName = user.profile?.name
            self.firstName = user.profile?.givenName ?? ""
            self.lastName = user.profile?.familyName ?? ""
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            let dicAllData = ["Email":emailAddress ?? "","fName":self.firstName,"lname":self.lastName,"pic":profilePicUrl ?? ""] as [String : Any]
            self.apicallForSocialLogin(socialtype: "google", socialId: userid, dicParam: dicAllData)
            //let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
         //   self.getSocialLogin(socialtype: "google", socialId: userid, email: emailAddress ?? "", phone_number: "", country_code: "", isEmailVarify: true, isMobileVarify: false)
        }
        
        
        
    }
    // MARK: - btnFacebookAction
    @IBAction func btnFacebookAction(_ sender : Any)
    {
        
        let manager = LoginManager()
        manager.logOut()
        
        
        let cookies = HTTPCookieStorage.shared
            let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
            for cookie in facebookCookies! {
                cookies.deleteCookie(cookie )
            }
        
      
        manager.logIn(permissions: [], from: self) { (loginResult, err) in
            if (err == nil){
                let fbloginresult : LoginManagerLoginResult = loginResult!
                // if user cancel the login
                if (loginResult?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()                 }
                else if (fbloginresult.grantedPermissions.contains("first_name")) {
                    self.getFBUserData()
                }
            }
            else {
                print(err ?? " ")
            }
        }
    }
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result1, error) -> Void in
                if (error == nil){
                    
                    let Dic = result1 as? NSDictionary
                    
                    self.dicFbData = Dic?.mutableCopy() as? NSMutableDictionary ?? [:]
                    print(self.dicFbData)
                    self.firstName = Dic?.value(forKey: "first_name") as? String ?? ""
                    self.lastName = Dic?.value(forKey: "last_name") as? String ?? ""
                    _ = Dic?.value(forKey: "name") as? String ?? ""
                    let emailAddress = Dic?.value(forKey: "email") as? String ?? ""
                    var profilePicUrl = String()
                    if let dicpicture = self.dicFbData.value(forKey: "picture") as? NSDictionary
                    {
                        if let dicdata = dicpicture.value(forKey: "data") as? NSDictionary
                        {
                            if let url = dicdata.value(forKey: "url") as? String
                            {
                                profilePicUrl = url
                            }
                        }
                    }
                    
                    var userid = String()
                    let id = Dic?.value(forKey: "id") as? String ?? ""
                    if id != ""
                    {
                        userid = id
                    }
                    if emailAddress != ""
                    {
                        
                        let dicAllData = ["Email":emailAddress ,"fName":self.firstName,"lname":self.lastName,"pic":profilePicUrl ] as [String : Any]
                        self.apicallForSocialLogin(socialtype: "facebook", socialId: userid, dicParam: dicAllData)
                        
                        
                        // self.getSocialLogin(socialtype: "facebook", socialId: userid, email: emailAddress, phone_number: "", country_code: "", isEmailVarify: true, isMobileVarify: false)
                    }
                    else{
                      //  self.getSocialLogin(socialtype: "facebook", socialId: userid, email: emailAddress, phone_number: "", country_code: "", isEmailVarify: false, isMobileVarify: false)
                    }
                    
                }else{
                    
                }
            })
        }
    }
    // MARK: - btnSignInWithAppleAction
    @IBAction func btnSignInWithAppleAction(_ sender : Any)
    {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    // MARK: - btnContinueWithEmailAction
    @IBAction func btnContinueWithEmailAction(_ sender : Any)
    {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmailLoginVC") as? EmailLoginVC{
            if let navigator = self.navigationController
            {
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
    }
    func apicallForSocialLogin(socialtype:String, socialId:String, dicParam:[String:Any])
    {
        self.RemoveDB()
        self.showProgress()
        let PhoneDict : NSDictionary = ["socialtype":socialtype,
                                        "socialId":socialId]
        
        url_handler.makeCall(MobileLoginUrl , param: PhoneDict as NSDictionary) {
            (responseObject, error) -> () in
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                self.DismissProgress()
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.Themes.CheckNullValue(responseObject["status"])
                    if(status == "1"){
                        
                        print(responseObject)
                        
                        
                        self.OTPStatus = self.Themes.CheckNullValue(responseObject["otp_status"])
                        self.UserType = self.Themes.CheckNullValue(responseObject["user_type"])
                        self.OTP = self.Themes.CheckNullValue(responseObject["otp"])
                        let objPhoneDict = responseObject["phone"] as? [String:Any] ?? [:]
                        self.CountryCode = self.Themes.CheckNullValue(objPhoneDict["code"])
                        self.phonenumber = self.Themes.CheckNullValue(objPhoneDict["number"])
                        SessionManager.sharedinstance.ExpertsAvailableRadius = self.Themes.CheckNullValue(responseObject["radius"])
                        Registerrec["radius"] = SessionManager.sharedinstance.ExpertsAvailableRadius
                    
                        
                        
                        if self.UserType == "existing"
                        {
                            
                          self.HitLogInCall()
                        }
                        else
                        {
                            self.DismissProgress()
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
        //                        self.MoveToRegister()
                                if let emailcheck = dicParam["Email"] as? String,emailcheck != ""
                                {
                                   self.MovetoVarifyVC(PhoneNumber: "", Email: emailcheck, isEmail: true, isMobile: false, socialtype: socialtype, socialId: socialId)
                                }
                                else{
                                    
                                    self.MovetoVarifyVC(PhoneNumber: "", Email: "", isEmail: false, isMobile: false, socialtype: socialtype, socialId: socialId)
                                }
                                
                            })
                        }
                    }
                    else{
                         let Error = self.Themes.CheckNullValue(responseObject["msg"])
                        self.Themes.AlertView(appNameJJ, Message: Error, ButtonTitle: kOk)
                        self.DismissProgress()
                        
                    }
                }else{
                    self.view.makeToast(message:Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                    self.DismissProgress()
                }
            }
        }
    
    }
    
    
}
extension InitialViewController: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
 
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
 
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            firstName = appleIDCredential.fullName?.givenName ?? ""
            lastName = appleIDCredential.fullName?.familyName ?? ""
            appleEmail = email ?? ""
            print(userIdentifier)

            print(fullName ?? "")
            print(email ?? "" )
            print(fullName?.familyName ?? "")
            print(fullName?.givenName ?? "")
      
            
            let keychain = KeychainSwift()
            
            keychain.synchronizable = true
            
 
            if let useremail = keychain.get("AppleEmail"),
              let FirstName = keychain.get("FirstName"),let LastName = keychain.get("LastName") {
                
                let keychainuserIdentifier = keychain.get("userIdentifier")
                
                if keychainuserIdentifier == userIdentifier
                {
                    self.firstName = FirstName
                    self.lastName = LastName
                    self.appleEmail = useremail
                  //  self.getSocialLogin(socialtype: "apple", socialId: userIdentifier, email: useremail, phone_number: "", country_code: "", isEmailVarify: true, isMobileVarify: false)
                    let dicAllData = ["Email":useremail,"fName":self.firstName,"lname":self.lastName,"pic":""] as [String : Any]
                    self.apicallForSocialLogin(socialtype: "apple", socialId: userIdentifier, dicParam: dicAllData)
                }
                else
                {
                    let email = appleIDCredential.email ?? ""
                    let firstname = appleIDCredential.fullName?.givenName ?? ""
                    let lastname = appleIDCredential.fullName?.familyName ?? ""
                   
                    firstName = appleIDCredential.fullName?.givenName ?? ""
                    lastName = appleIDCredential.fullName?.familyName ?? ""
                    appleEmail = email

                    if email != ""
                    {
                        keychain.set(email, forKey: "AppleEmail")
                        keychain.set(firstname, forKey: "FirstName")
                        keychain.set(lastname, forKey: "LastName")
                       
                    }
                    keychain.set(userIdentifier, forKey: "userIdentifier")
                    
                   
                    
                    self.firstName = FirstName
                    self.lastName = LastName
                   // self.getSocialLogin(socialtype: "apple", socialId: userIdentifier, email: useremail, phone_number: "", country_code: "", isEmailVarify: true, isMobileVarify: false)
                    
                   // loginViewModel.loginWithGoogleApi(parameters: param)
                    
                    let dicAllData = ["Email":email,"fName":self.firstName,"lname":self.lastName,"pic":""] as [String : Any]
                    self.apicallForSocialLogin(socialtype: "apple", socialId: userIdentifier, dicParam: dicAllData)
                }
                
 
            }
            else
            {
                
                 
                let email = appleIDCredential.email ?? ""
                let firstname = appleIDCredential.fullName?.givenName ?? ""
                let lastname = appleIDCredential.fullName?.familyName ?? ""
               
                firstName = firstname
                lastName = lastname
                appleEmail = email

                if email != ""
                {
                    keychain.set(email, forKey: "AppleEmail")
                    keychain.set(firstname, forKey: "FirstName")
                    keychain.set(lastname, forKey: "LastName")
                }
                keychain.set(userIdentifier, forKey: "userIdentifier")
                self.firstName = firstname
                self.lastName = lastname
               // self.getSocialLogin(socialtype: "apple", socialId: userIdentifier, email: email, phone_number: "", country_code: "", isEmailVarify: true, isMobileVarify: false)
                let dicAllData = ["Email":email,"fName":self.firstName,"lname":self.lastName,"pic":""] as [String : Any]
                self.apicallForSocialLogin(socialtype: "apple", socialId: userIdentifier, dicParam: dicAllData)
                
            }
             
             
     
            
        }
      
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
extension InitialViewController: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
extension InitialViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == MobileTextField
        {
            if (self.Themes.TextfieldMaximum(string, Textfield: textField, Count: MaximummobileValidation, range: range))
            {
                return true
            }else
            {
                return false
            }
            
        }
        return true
    }
}
