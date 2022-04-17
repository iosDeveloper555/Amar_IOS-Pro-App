//
//  OTPViewController.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 6/11/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController {
    
    @IBOutlet weak var HeaderBarView: UIView!
    @IBOutlet weak var BackButtonView: UIView!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var ResentdOtp: UIButton!
    @IBOutlet weak var ContinueButton: TKTransitionSubmitButton!
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var OTP1: UITextField!
    @IBOutlet weak var OTP2: UITextField!
    @IBOutlet weak var OTP3: UITextField!
    @IBOutlet weak var OTP4: UITextField!
    @IBOutlet weak var OTP5: UITextField!
    @IBOutlet weak var OTP6: UITextField!
    
    
    
    
    
    // Views for Apple login users to hide 
    
    
    let Themes = Theme()
    var CountryCode : String = ""
    var Mobilenumber : String = ""
    var UserType : String = ""
    var OTPStatus : String = ""
    var OTP : String = ""
    var countdownTimer: Timer!
    var totalTime = 15
    var indexpath : Int = 0
    var TextFieldArray = [UITextField]()
    var url_handler : URLhandler = URLhandler()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TextFieldArray = [self.OTP1,self.OTP2,self.OTP3,self.OTP4,self.OTP5,self.OTP6]
        self.SetUI()
//        self.startTimer()
        if OTPStatus == "development" {
            OTP6.becomeFirstResponder()
            self.SetOTPText(str: OTP)
        }else{
            OTP1.becomeFirstResponder()
        }
    }
    
    func SetUI(){
        HeaderLabel.text = "\(Language_handler.VJLocalizedString("Enter_the_code", comment: nil))\(" ")\(CountryCode)\(Mobilenumber)"
        ResentdOtp.setTitle(Language_handler.VJLocalizedString("Resend_Code", comment: nil), for: .normal)
        ResentdOtp.setTitleColor(PlumberThemeColor, for: .normal)
        ResentdOtp.titleLabel?.adjustsFontSizeToFitWidth = true
        ContinueButton.setTitleColor(UIColor.white, for: .normal)
        ContinueButton.setTitle(Language_handler.VJLocalizedString("continue", comment: nil), for: .normal)
        ContinueButton.backgroundColor = PlumberThemeColor
        ContinueButton.layer.cornerRadius = 10
    }
    
    func SetOTPText(str: String){
        let OTPArray = str.map {String($0)} //->Array<String> ->Seperates string and set for each textfield
        for i in 0..<TextFieldArray.count{
            let TextField = TextFieldArray[i]
            TextField.text = self.Themes.CheckNullValue(OTPArray[i])
        }
    }
//
//    func startTimer() {
//        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
//        ResentdOtp.isUserInteractionEnabled = false
//        ResentdOtp.setTitleColor(UIColor.gray, for: .normal)
//        ResentdOtp.setTitle(Language_handler.VJLocalizedString("Will_Resend", comment: nil), for: .normal)
//    }
//
//    @objc func updateTime() {
//        TimerLabel.text = "\(timeFormatted(totalTime))"
//        if totalTime != 0 {
//            totalTime -= 1
//        } else {
//            endTimer()
//        }
//    }
//
//    func endTimer() {
//        countdownTimer.invalidate()
//        ResentdOtp.isUserInteractionEnabled = true
//        ResentdOtp.setTitleColor(PlumberThemeColor, for: .normal)
//        ResentdOtp.setTitle(Language_handler.VJLocalizedString("Resend_Code", comment: nil), for: .normal)
//        TimerLabel.text = " "
//    }
//
//    func timeFormatted(_ totalSeconds: Int) -> String {
//        let seconds: Int = totalSeconds % 60
//        let minutes: Int = (totalSeconds / 60) % 60
//        //let hours: Int = totalSeconds / 3600
//        return String(format: "%02d:%02d",minutes, seconds)
//    }
    
    func ResignAllTextField(){
        for TextField in TextFieldArray{
            if TextField.becomeFirstResponder(){
                TextField.resignFirstResponder()
            }
        }
    }
    
    @IBAction func didclickBackButton(_ sender: Any) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
    @IBAction func didclickResendOTP(_ sender: Any) {
//        self.startTimer()
//        totalTime = 15
        self.GetOtp()
    }
    
    @IBAction func didclickContinueButton(_ sender: Any)
    {
        let FinalOTP = "\(self.OTP1.text ?? "")\(self.OTP2.text ?? "")\(self.OTP3.text ?? "")\(self.OTP4.text ?? "")\(self.OTP5.text ?? "")\(self.OTP6.text ?? "")"
        if FinalOTP == ""{
            self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("enter_sent_OTP", comment: nil), ButtonTitle: kOk)
        }else{
            if FinalOTP == OTP {
                if UserType == "existing"{
                    self.HitLogInCall()
                }else{
                    ContinueButton.startLoadingAnimation()
                    self.ResignAllTextField()
                    AvailableArray.removeAll()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.MoveToRegister()
                    })
                }
            }else{
                self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Enter_Valid_Otp", comment: nil), ButtonTitle: kOk)

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.ContinueButton.returnToOriginalState()
                    self.ContinueButton.isUserInteractionEnabled = true
                    self.ContinueButton.setTitle("continue", for: .normal)
                })
            }
        }
    }
    
    func GetOtp(){
        let PhoneDict : NSDictionary = ["code":CountryCode,
                                        "number":Mobilenumber]
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
                        if OtpStatus == "development"{
                            self.SetOTPText(str: Otp)
                        }
                        self.UserType = userType
                        self.CountryCode = code
                        self.Mobilenumber = number
                        self.OTP = Otp
                    }
                    else{
                        let Error = self.Themes.CheckNullValue(responseObject["errors"])
                        self.Themes.AlertView("", Message: Error , ButtonTitle: kOk)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            self.ContinueButton.returnToOriginalState()
                            self.ContinueButton.isUserInteractionEnabled = true
                            self.ContinueButton.setTitle("continue", for: .normal)
                        })
                    }
                }else{
                    self.Themes.AlertView("", Message: Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), ButtonTitle: kOk)
                }
            }
        })
    }
    
    func HitLogInCall() {
        ContinueButton.startLoadingAnimation()
        ContinueButton.isUserInteractionEnabled = false
        let Parameter : NSDictionary = ["phone_number" : "\(Mobilenumber)",
                                        "deviceToken" : self.Themes.GetDeviceToken() as String,
                                        "gcm_id" : ""
                                       ]
        
        url_handler.makeCall(LoginUrl, param: Parameter as NSDictionary) {
            (responseObject, error) -> () in
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.ContinueButton.returnToOriginalState()
                    self.ContinueButton.isUserInteractionEnabled = true
                    self.ContinueButton.setTitle("continue", for: .normal)
                })
            }else{
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
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
                        self.ResignAllTextField()
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
                        self.ResignAllTextField()
                        print(responseObject)
                        
                    }
                }else{
                    self.view.makeToast(message:Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.ContinueButton.returnToOriginalState()
                        self.ContinueButton.isUserInteractionEnabled = true
                        self.ContinueButton.setTitle("continue", for: .normal)
                    })
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.ContinueButton.returnToOriginalState()
            self.ContinueButton.isUserInteractionEnabled = true
            self.ContinueButton.setTitle("continue", for: .normal)
        })
    }
    
    func MoveToRegister(){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFirstPageViewController") as? RegFirstPageViewController{
            if let navigator = self.navigationController
            {
                let PhoneDict : NSDictionary = ["code":"\(self.CountryCode )",
                    "number":"\(self.Mobilenumber )"]
                viewController.PhoneDict = PhoneDict
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.ContinueButton.returnToOriginalState()
            self.ContinueButton.isUserInteractionEnabled = true
            self.ContinueButton.setTitle("continue", for: .normal)
        })
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
}

extension OTPViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let initiallyEmpty = textField.text == "" ? true:false
        
        if (textField.text?.count ?? 0 < 1) || (string == ""){
            textField.text = string
        }
        if string != "" {
            for i in 0..<TextFieldArray.count {
                
                if i > textField.tag {
                    
                    let textfield = TextFieldArray[i]
                    
                    if textfield.text == "" {
                        textfield.becomeFirstResponder()
                        if initiallyEmpty == false {
                            textfield.text = string
                        }
                        break
                    }
                }
            }
        }else{
            if textField.tag > 0 {
                let textfield = TextFieldArray[textField.tag-1]
                textfield.becomeFirstResponder()
            }
        }
        return false
    }
}
