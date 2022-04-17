//
//  VarificationVC.swift
//  PlumberJJ
//
//  Created by romil Sheth on 30/10/21.
//  Copyright © 2021 Casperon Technologies. All rights reserved.
//

import UIKit

class VarificationVC: RootBaseViewController,MICountryPickerDelegate {

    @IBOutlet var EmailidTextfield: UITextField!
    @IBOutlet var txtOtpEmail: UITextField!
    @IBOutlet weak var txt_PhoneNnumber : UITextField!
    @IBOutlet weak var viewBtn:UIView!
    @IBOutlet weak var view_Email : UIView!
    @IBOutlet weak var view_PhoneNumber : UIView!
    @IBOutlet weak var viewOtp:UIView!
    @IBOutlet weak var txtOtp:UITextField!
    @IBOutlet weak var btnGetotpEmaiWidth : NSLayoutConstraint!
    @IBOutlet weak var btnGetotpPhoneNumberWidth : NSLayoutConstraint!
    @IBOutlet weak var view_EmailOtp : UIView!
    @IBOutlet weak var view_EmailOtpBtn : UIView!
    @IBOutlet weak var CountryFlag: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
   
    
    var URL_handler:URLhandler=URLhandler()
    let themes = Theme()
    var verification_code = String()
    var UserType : String = ""
    var OTPStatus : String = ""
    var OTP : String = ""
    var firstName = String()
    var lastName = String()
    var CountryCode = String()
    var PhoneDic = NSDictionary()
    var EmailRegister = String()
    var PhoneNumber = String()
    var socialtype = String()
    var socialId = String()
    var isEmailFinishVerify = Bool()
    var isPhoneFinishVerify = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        if PhoneNumber != ""
        {
            txt_PhoneNnumber.text = PhoneNumber
            self.txt_PhoneNnumber.isUserInteractionEnabled = false
            CountryCode = PhoneDic.value(forKey: "code") as? String ?? ""
            lblCountryCode.text = CountryCode
            btnGetotpPhoneNumberWidth.constant = 0
            self.themes.Set(CountryCode: lblCountryCode, WithFlag: CountryFlag)
            isPhoneFinishVerify = true
           
        }
        else
        {
            self.txt_PhoneNnumber.isUserInteractionEnabled = true
            btnGetotpPhoneNumberWidth.constant = 50
            isPhoneFinishVerify = false
            self.themes.Set(CountryCode: lblCountryCode, WithFlag: CountryFlag)
        }
        if EmailRegister != ""
        {
            btnGetotpEmaiWidth.constant = 0
            EmailidTextfield.text = EmailRegister
            EmailidTextfield.isUserInteractionEnabled = false
            isEmailFinishVerify = true
        }
        else
        {
            btnGetotpEmaiWidth.constant = 50
            EmailidTextfield.isUserInteractionEnabled = true
            isEmailFinishVerify = false
        }
        viewBtn.isHidden = true
        view_EmailOtpBtn.isHidden = true
    }
    @IBAction func btnResendOtpPhoneAction(_ sender: AnyObject)
    {
        if (txt_PhoneNnumber.text?.count)! >= MinimummobileValidation
        {
            self.getOtpPhone()
        }
        else{
            self.themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("valid_Mobile", comment: nil), ButtonTitle: kOk)
        }
    }
    func getOtpPhone()
    {
        if (txt_PhoneNnumber.text?.count)! >= MinimummobileValidation
        {
            self.showProgress()
            let PhoneDict : NSDictionary = ["code":"\(lblCountryCode.text ?? "")",
                                            "number":"\(txt_PhoneNnumber.text ?? "")"]
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
                        let status=self.themes.CheckNullValue(responseObject["status"])
                        if(status == "1"){
                            print(responseObject)
                            
                            
                            self.OTPStatus = self.themes.CheckNullValue(responseObject["otp_status"])
                            self.UserType = self.themes.CheckNullValue(responseObject["user_type"])
                            self.OTP = self.themes.CheckNullValue(responseObject["otp"])
                            let objPhoneDict = responseObject["phone"] as? [String:Any] ?? [:]
                            self.CountryCode = self.themes.CheckNullValue(objPhoneDict["code"])
                            SessionManager.sharedinstance.ExpertsAvailableRadius = self.themes.CheckNullValue(responseObject["radius"])
                            Registerrec["radius"] = SessionManager.sharedinstance.ExpertsAvailableRadius
                            self.viewOtp.isHidden = false
                            self.viewBtn.isHidden = false
                            self.DismissProgress()
                        }
                        else{
                             let Error = self.themes.CheckNullValue(responseObject["msg"])
                            self.themes.AlertView(appNameJJ, Message: Error, ButtonTitle: kOk)
                            self.DismissProgress()
                            
                        }
                    }else{
                        self.view.makeToast(message:Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                        self.DismissProgress()
                    }
                }
            }
        }else{
            self.themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("valid_Mobile", comment: nil), ButtonTitle: kOk)
        }
    }
    
    @IBAction func btnGetOtpAction(_ sender : UIButton)
    {
        if sender.tag == 10
        {
            self.getOtpPhone()
        }
        else
        {
            self.getOtpEmail()
        }
        
    }
    @IBAction func btnResendEmailVarificationAction(_ sender : UIButton)
    {
        
        getOtpEmail()
    }
    func getOtpEmail()
    {
        if (EmailidTextfield.text?.count)! >= 6
        {
            self.showProgress()
//            let PhoneDict : NSDictionary = ["email":"\(EmailidTextfield.text ?? "")"]
            let Parameter : NSDictionary = ["email" : EmailidTextfield.text ?? ""]
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
                        let status=self.themes.CheckNullValue(responseObject["status"])
                        if(status == "1"){
                            print(responseObject)
                            
                            
                            self.OTPStatus = self.themes.CheckNullValue(responseObject["otp_status"])
                            self.UserType = self.themes.CheckNullValue(responseObject["user_type"])
                            self.OTP = self.themes.CheckNullValue(responseObject["otp"])
                            let objPhoneDict = responseObject["phone"] as? [String:Any] ?? [:]
                            self.CountryCode = self.themes.CheckNullValue(objPhoneDict["code"])
                            SessionManager.sharedinstance.ExpertsAvailableRadius = self.themes.CheckNullValue(responseObject["radius"])
                            Registerrec["radius"] = SessionManager.sharedinstance.ExpertsAvailableRadius
                            self.view_EmailOtp.isHidden = false
                            self.view_EmailOtpBtn.isHidden = false
                            self.DismissProgress()
                        }
                        else{
                             let Error = self.themes.CheckNullValue(responseObject["msg"])
                            self.themes.AlertView(appNameJJ, Message: Error, ButtonTitle: kOk)
                            self.DismissProgress()
                            
                        }
                    }else{
                        self.view.makeToast(message:Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                        self.DismissProgress()
                    }
                }
            }
        }
        else{
            self.themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Please Enter Valid Email ", comment: nil), ButtonTitle: kOk)
        }
        
    }
    @IBAction func btnVarifyAction(_ sender : UIButton)
    {
        if txt_PhoneNnumber.text! == ""
        {
            self.themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("enter_sent_OTP", comment: nil), ButtonTitle: kOk)
        }
        else
        {
            if txtOtp.text! == OTP
            {
                self.theme.saveCountryCode(lblCountryCode.text ?? "")
                isPhoneFinishVerify = true
                self.viewOtp.isHidden = true
                self.viewOtp.isHidden = true
                self.viewBtn.isHidden = true
                self.txt_PhoneNnumber.isUserInteractionEnabled = false
                PhoneNumber = txt_PhoneNnumber.text!
                CountryCode = lblCountryCode.text!
                themes.AlertView("", Message: Language_handler.VJLocalizedString("Phone Verify successfully", comment: nil), ButtonTitle: kOk)
                
            }
            else
            {
                self.themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Enter_Valid_Otp", comment: nil), ButtonTitle: kOk)
            }
        }
    }
    @IBAction func btnEmailVarifyAction(_ sender : UIButton)
    {
        if EmailidTextfield.text! == ""
        {
            self.themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("enter_sent_OTP", comment: nil), ButtonTitle: kOk)
        }
        else
        {
            if txtOtpEmail.text! == OTP
            {
                self.theme.saveCountryCode(lblCountryCode.text ?? "")
                isEmailFinishVerify = true
                self.view_EmailOtp.isHidden = true
                self.view_EmailOtpBtn.isHidden = true
                self.EmailidTextfield.isUserInteractionEnabled = false
                
                themes.AlertView("", Message: Language_handler.VJLocalizedString("Email Verify successfully", comment: nil), ButtonTitle: kOk)
                
            }
            else
            {
                self.themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Enter_Valid_Otp", comment: nil), ButtonTitle: kOk)
            }
        }
    }
    func MoveToRegister(){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFirstPageViewController") as? RegFirstPageViewController{
            if let navigator = self.navigationController
            {
                let PhoneDict : NSDictionary = ["code":"\(lblCountryCode.text! )",
                                                "number":"\(txt_PhoneNnumber.text! )"]
                viewController.PhoneDict = PhoneDict
                viewController.emailVerify = EmailidTextfield.text!
                viewController.socialtype = self.socialtype
                viewController.socialId = self.socialId
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
    }
    func HitLogInCall() {
        self.showProgress()
        let Parameter : NSDictionary = ["phone_number" : "\(PhoneNumber)",
                                        "deviceToken" : self.themes.GetDeviceToken() as String,
                                        "gcm_id" : ""
                                       ]
        print(Parameter)
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
                    let status=self.themes.CheckNullValue(responseObject["status"])
                    if(status == "1"){
                        self.themes.saveVerifiedStatus(VerifiedStatus: 1)
                        self.themes.saveUserDetail(responseObject["response"] as! NSDictionary)
                        let ResponseDict = responseObject["response"] as? [String : Any] ?? [:]
                        let CurrencyCode : String = self.themes.getCurrencyCode(self.themes.CheckNullValue(ResponseDict["currency"]))
                        self.themes.saveappCurrencycode(CurrencyCode as String)
                        let FirstName = self.themes.CheckNullValue(ResponseDict["firstname"])
                        let LastName = self.themes.CheckNullValue(ResponseDict["lastname"])
                        let FullName = "\(FirstName)\(" ")\(LastName)"
                        self.themes.saveFullName(UserName: FullName)
                        
                        let _:UserInfoRecord=self.themes.GetUserDetails()
                        SocketIOManager.sharedInstance.establishConnection()
                        SocketIOManager.sharedInstance.establishChatConnection()
                        if(self.themes.isUserLigin()){
                            self.MoveToApp()
                        }
                        print(responseObject)
                        
                    }else if (status == "3") || (status == "2"){
                        self.themes.saveVerifiedStatus(VerifiedStatus: 0)
                        self.themes.saveUserDetail(responseObject["response"] as! NSDictionary)
                        let ResponseDict = responseObject["response"] as? [String : Any] ?? [:]
                        let CurrencyCode : String = self.themes.getCurrencyCode(self.themes.CheckNullValue(ResponseDict["currency"]))
                        self.themes.saveappCurrencycode(CurrencyCode as String)
                        
                        let _:UserInfoRecord=self.themes.GetUserDetails()
                        SocketIOManager.sharedInstance.establishConnection()
                        SocketIOManager.sharedInstance.establishChatConnection()
                        if(self.themes.isUserLigin()){
                            self.MoveToApp()
                        }
                        
                        //print(responseObject)
                        
                    }
                }else{
                    self.view.makeToast(message:Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                   
                }
            }
        }
    }
    func MoveToApp(){
        self.perform(#selector(self.updateAvailbility), with: nil, afterDelay: 0.5)
        self.themes.UpdateAvailability("1")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewcontroller()
        let socStr:NSString = ""//dict.objectForKey("soc_key") as! NSString
        if(socStr.length>0){
            self.themes.saveJaberPassword(socStr as String)
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
                    let status=self.themes.CheckNullValue(responseObject.object(forKey: "status"))
                    if(status == "1")
                    {
                        let resDict: NSDictionary = responseObject.object(forKey: "response") as! NSDictionary
                        let tasker_status : String = self.themes.CheckNullValue(resDict.object(forKey: "tasker_status"))
                        
                        if (tasker_status == "1")
                        {
                            self.view.makeToast(message:"Your availability is ON", duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                            self.themes.saveAvailable_satus("GO OFFLINE")
                        }
                        else
                        {
                            self.view.makeToast(message:"Your availability is OFF", duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                            self.themes.saveAvailable_satus("GO ONLINE")
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
    @IBAction func btnResendAction(_ sender : UIButton)
    {
        
    }
    @IBAction func btnContinueAction(_ sender : UIButton)
    {
        if isEmailFinishVerify == true && isPhoneFinishVerify == true
        {
            PhoneNumber = txt_PhoneNnumber.text!
            CountryCode = lblCountryCode.text!
            
            if UserType == "existing"
            {
               
                
                self.HitLogInCall()
            }
            else
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.MoveToRegister()
                  
                   
                })
            }
            
            
        }
        else
        {
            
            self.themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("enter_sent_OTP", comment: nil), ButtonTitle: kOk)
        }
        
    }
    @IBAction func btnbackAction(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didclickCountry(_ sender: Any)
    {
        if PhoneNumber == ""
        {
            let  country = MICountryPicker()
            country.delegate = self
            country.showCallingCodes = true
                if let navigator = self.navigationController
                {
                    navigator.pushViewController(country, animated: true)
                }
        }
        
    }
    @objc func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {}
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String, countryFlagImage: UIImage) {
        lblCountryCode.text = dialCode
        CountryFlag.image = countryFlagImage
        picker.navigationController?.popAnimationFade(animated: true)
       
    }
    
}
