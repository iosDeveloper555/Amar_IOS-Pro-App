//
//  EmailLoginVC.swift
//  Plumbal
//
//  Created by romil Sheth on 08/10/21.
//  Copyright © 2021 Casperon Tech. All rights reserved.
//

import UIKit
import Alamofire

class EmailLoginVC: RootViewController {
    @IBOutlet var EmailidTextfield: UITextField!
    @IBOutlet weak var viewBtn:UIView!
//    @IBOutlet weak var viewEmailOtp:UIView!
    @IBOutlet weak var txtOtp:UITextField!
//    @IBOutlet weak var btnverify: UIButton!
//    @IBOutlet weak var EmailVarifyConstant : NSLayoutConstraint!
    @IBOutlet weak var viewOtp:UIView!
//    @IBOutlet weak var viewotpButton:UIView!
    
    var url_handler:URLhandler=URLhandler()
   
    let Themes = Theme()
  
    var UserType : String = ""
    var OTPStatus : String = ""
    var OTP : String = ""
    var firstName = String()
    var lastName = String()
    var userType = String()
    var phonenumber = String()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func btnResendOtpAction(_ sender: AnyObject)
    {
        let isValidProperEmail = Themes.isValidEmailAddressNew(emailAddressString: EmailidTextfield.text!)
        
        if (EmailidTextfield.text?.count)! >= 6 && isValidProperEmail == true
        {
            verificationapicall()
        }
        else{
            self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("valid_Mobile", comment: nil), ButtonTitle: kOk)
        }
    }
    
    // MARK: - btnVerifyAction
    @IBAction func btnVerifyAction(_ sender : Any)
    {
        if viewOtp.isHidden
        {
            let isValidProperEmail = Themes.isValidEmailAddressNew(emailAddressString: EmailidTextfield.text!)
            
            if (EmailidTextfield.text?.count)! >= 6 && isValidProperEmail == true
            {
                self.verificationapicall()
            }
            else
            {
                self.Themes.AlertView(Appname, Message: Language_handler.VJLocalizedString("Please Enter Valid Email", comment: nil), ButtonTitle: kOk)
            }
            
            
        }
        else
        {
            viewOtp.isHidden = true
        }
        
    }
    @IBAction func btnCheckVerifiycation(_ sender: AnyObject) {
        
        
        let FinalOTP = "\(self.txtOtp.text ?? "")"
        if FinalOTP == ""{
            Themes.AlertView("", Message: Language_handler.VJLocalizedString("enter_otp", comment: nil), ButtonTitle: kOk)
        }else{
            
            if FinalOTP == OTP
            {
                self.viewOtp.isHidden = true
                self.viewBtn.isHidden = true
                Themes.AlertView("", Message: Language_handler.VJLocalizedString("Email Verify successfully", comment: nil), ButtonTitle: kOk)
            }
            else
            {
                Themes.AlertView("", Message: Language_handler.VJLocalizedString("Please Enter Valid OTP", comment: nil), ButtonTitle: kOk)
            }
        }
    }
    @IBAction func btnbackAction(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didclickContinueButton(_ sender: Any)
    {
        let FinalOTP = "\(txtOtp.text!)"
        if FinalOTP == ""{
            self.Themes.AlertView("", Message: Language_handler.VJLocalizedString("enter_otp", comment: nil), ButtonTitle: kOk)
        }else{
            
            if FinalOTP == OTP
            {
                if UserType == "existing"
                {
                    self.HitLogInCall()
                }
                else
                {
                    
                    self.MoveToRegister()
                }
            }else{
                self.Themes.AlertView("", Message: Language_handler.VJLocalizedString("Enter_Valid_Otp", comment: nil), ButtonTitle: kOk)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.DismissProgress()
                })
            }
        }
    }

    func MoveToRegister()
    {
        self.DismissProgress()
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFirstPageViewController") as? RegFirstPageViewController{
            if let navigator = self.navigationController
            {

                viewController.emailVerify  = EmailidTextfield.text!
                viewController.isEmailVerify = true
                viewController.isMobileVerify = false
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
            
    }
    func verificationapicall()
    {
        self.showProgress()
        let PhoneDict : NSDictionary = ["email":EmailidTextfield.text!]
        url_handler.makeCall(MobileLoginUrl, param: PhoneDict as NSDictionary, completionHandler:{ (responseObject, error) -> () in
            if(error != nil)
            {
                self.Themes.AlertView("", Message: kErrorMsg, ButtonTitle: kOk)
                self.DismissProgress()
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.Themes.CheckNullValue(responseObject["status"])
                    if(status == "1"){
                        self.DismissProgress()
                        print(responseObject)
                        self.OTP = self.Themes.CheckNullValue(responseObject["otp"])
                        let OtpStatus = self.Themes.CheckNullValue(responseObject["otp_status"])
                        let userType = self.Themes.CheckNullValue(responseObject["user_type"])
                        let Phone = responseObject["phone"] as? [String:Any] ?? [:]
                        let code = self.Themes.CheckNullValue(Phone["code"])
                        let number = self.Themes.CheckNullValue(Phone["number"])
                        self.phonenumber =  number
                        self.UserType = userType
                        self.viewOtp.isHidden = false
                        self.viewBtn.isHidden = false
                       // self.CountryCode = code
                        self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("enter_sent_OTPEmail", comment: nil), ButtonTitle: kOk)
                    }
                    else{
                        let Error = self.Themes.CheckNullValue(responseObject["errors"])
                        self.Themes.AlertView("", Message: Error , ButtonTitle: kOk)
                        self.DismissProgress()
                        
                    }
                }else{
                    self.Themes.AlertView("", Message: Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), ButtonTitle: kOk)
                    self.DismissProgress()
                }
            }
        })
    }
    func HitLogInCall() {
        
        if phonenumber.count==0
        {
            phonenumber = "00000909090"
        }
        
        let Parameter : NSDictionary = ["phone_number" : "\(phonenumber)",
                                        "deviceToken" : self.Themes.GetDeviceToken() as String,
                                        "gcm_id" : ""
                                       ]
        
        url_handler.makeCall(LoginUrl, param: Parameter as NSDictionary) {
            (responseObject, error) -> () in
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                
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
                        
                        print(responseObject)
                        
                    }
                    else
                    {
                       let data = responseObject["response"] as? String ?? ""

                        self.view.makeToast(message:data, duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)

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
}
