//
//  RegFirstPageViewController.swift
//  PlumberJJ
//
//  Created by Sakthivel's Mac Mini on 11/07/18.
//  Copyright © 2018 Casperon Technologies. All rights reserved.
//

import UIKit
import GooglePlaces
import PhoneNumberKit
import MobileCoreServices
import Alamofire
import Foundation
import CoreLocation

//var countryCode = ""
//var userPhoneNum = ""
var ACCEPTABLE_CHARACTERS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"

extension UITextField
{
    func borderForTextfield()
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x:0.0,y:self.frame.height - 1,width:self.frame.width,height:1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}

extension UIButton
{
    func borderForbutton()
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x:0.0,y:self.frame.height - 1,width:self.frame.width,height:1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        
        self.layer.addSublayer(bottomLine)
    }
}

extension UIButton{
    
    func applyGradientwithcorner() -> Void {
        var colours = [UIColor]()
        
        colours = [PlumberThemeColor,customThemeColor]
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        //gradient.locations = locations
        gradient.startPoint =  CGPoint(x:0.0,y: 0.5);
        gradient.endPoint = CGPoint(x:1.0,y: 0.5);
        gradient.cornerRadius = self.frame.size.height/2
        
        self.layer.insertSublayer(gradient, at: 0)
        self.backgroundColor = UIColor.clear
    }
}

var AvailableArray = [AvailableRec]()

class RegFirstPageViewController: RootBaseViewController,WWCalendarTimeSelectorProtocol,ChooseLocationViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MICountryPickerDelegate,CLLocationManagerDelegate{
    
    // story board outlet
    // imageview
    // lable
    var radius = 10

    var locationManager = CLLocationManager()
    @IBOutlet weak var HeaderLbl: UILabel!
    @IBOutlet weak var SubHeaderLbl: UILabel!
    // Custom Valid lable
    @IBOutlet weak var titleLbl: CustomLabelHeader!
    @IBOutlet weak var email_valid_lbl: CustomLabelHeader!
    @IBOutlet weak var mobile_valid_lbl: CustomvalidLabel!
    @IBOutlet weak var FirstnameValid_Lbl: CustomvalidLabel!
    @IBOutlet weak var LastNameValid_Lbl: CustomvalidLabel!
    @IBOutlet weak var DateOfBirthValid_Lbl: CustomvalidLabel!
    @IBOutlet weak var GenderValid_Lbl: CustomvalidLabel!
    @IBOutlet weak var AddressValid_Lbl: CustomvalidLabel!
    @IBOutlet weak var RadiusValid_Lbl: CustomvalidLabel!
    @IBOutlet weak var APTValid_Lbl: CustomvalidLabel!
    @IBOutlet weak var SSNValid_Lbl: CustomvalidLabel!

    @IBOutlet var ValidLabelArray: [CustomvalidLabel]!
    @IBOutlet var TextFieldsArray: [BodyTextFieldStyle]!
    @IBOutlet weak var trems_cond_lbl: UITextView!
    @IBOutlet weak var Contractor_agreement_lbl: UITextView!
    @IBOutlet weak var professional_agreement_lbl: UITextView!
    //NSLayoutConstraints
    @IBOutlet weak var DownViewBottom: NSLayoutConstraint!
    @IBOutlet weak var ques_height: NSLayoutConstraint!
    
    
   
    // stack view
    @IBOutlet weak var stackView: UIStackView!
    // TextFields
    @IBOutlet weak var email_textField: CustomTextField!
    @IBOutlet weak var email_textField_verify: CustomTextField!
    @IBOutlet weak var FirstnameTxtfield: CustomTextField!
    @IBOutlet weak var LastNameTxtfield: CustomTextField!
    @IBOutlet weak var RadiusTxtfield: CustomTextField!
    //UIVIew
    @IBOutlet weak var BAckButtonView: UIView!
    @IBOutlet var DatePickerView: DatePickerView!
    @IBOutlet var GenderView: GenderView!
    
    @IBOutlet var OutsiderView: [CSAnimationView]!
    @IBOutlet weak var DoneView: UIView!
    //DatePicker
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    //ImageView
    @IBOutlet weak var TaskerImage: UIImageView!
    
    // Button
    @IBOutlet weak var submit_btn: CustomButton!
    @IBOutlet weak var AddTaskerImageBtn: UIButton!
    @IBOutlet weak var DateofbirthButton: UIButton!
    @IBOutlet weak var AddressButton: UIButton!
    @IBOutlet weak var CheckBoxButton: UIButton!
    @IBOutlet weak var CheckBoxButton1: UIButton!
    @IBOutlet weak var CheckBoxButton2: UIButton!
    @IBOutlet weak var maleRadioView: UIView!
    @IBOutlet weak var femaleRadioView: UIView!
    @IBOutlet weak var othersRadioView: UIView!
    @IBOutlet weak var maleRadio_Img: UIImageView!
    @IBOutlet weak var femaleRadio_Img: UIImageView!
    @IBOutlet weak var othersRadio_Img: UIImageView!
    @IBOutlet weak var male_Lbl: UILabel!
    @IBOutlet weak var female_Lbl: UILabel!
    @IBOutlet weak var others_Lbl: UILabel!
    
    
    @IBOutlet weak var firstNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailConstraint: NSLayoutConstraint!
    
    @IBOutlet var viewsToHideIncaseOfAppleLogin: [UIView]!
    
    @IBOutlet weak var DoneBtn: UIButton!
    // scrollview
    @IBOutlet weak var scr_view: UIScrollView!
    // tableview
    @IBOutlet weak var AboutTableView: UITableView!
    // set Calender View
    
    var check_pass = ""
    var heightConstraint : NSLayoutConstraint!
    var QuestionsArray = [QuestionRec]()
    var DistanceStr : String = " "
    var GenderData = [String]()
    var SelectedGender : String = " "
    var imagePicker : UIImagePickerController!
    var isimgupload:Bool?
    var imagedata = Data()
    var imageurl :String = ""
    var isaddressPresent:Bool?
    var address_Coord : CLLocationCoordinate2D?
    var PhoneDict :NSDictionary = NSDictionary()
    var TextIndex = NSInteger()
    var dicOtherInfo = NSDictionary()
    var socialtype = String()
    var socialId = String()
    var emailVerify = String()
    var firstName = String()
    var lastName = String()
    var appleEmail = String()
    
    @IBOutlet weak var txt_PhoneNnumber : CustomTextField!
    @IBOutlet weak var txt_PhoneNnumber_verify : CustomTextField!
    @IBOutlet weak var CountryFlag: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
   
   
    @IBOutlet weak var stackviewMobileVerify:UIStackView!
    @IBOutlet weak var viewMobileVerify:UIView!
    
    @IBOutlet weak var stackviewEmailVerify:UIStackView!
    @IBOutlet weak var viewEmailVerify:UIView!
    
    @IBOutlet weak var WidthBtnEmailOtp:NSLayoutConstraint!
    @IBOutlet weak var WidthBtnPhoneOtp:NSLayoutConstraint!
    var phoneCodeImage = UIImage()
    var isEmailVerify = false
    var isMobileVerify = false
    var UserType : String = ""
    var OTPStatus : String = ""
    var OTP : String = ""
    var isLoginLocation = false
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if socialtype == "apple"{
            FirstnameTxtfield.text = firstName
            LastNameTxtfield.text = lastName
//            email_textField.text = appleEmail
            FirstnameTxtfield.isUserInteractionEnabled = false
            LastNameTxtfield.isUserInteractionEnabled = false
            viewsToHideIncaseOfAppleLogin.forEach({
                $0.isHidden = true
            })
            firstNameConstraint.constant = 0
            secondNameConstraint.constant = 0
            emailConstraint.constant = 0
        }
        
        if self.theme.yesTheDeviceisHavingNotch()
        {
            DownViewBottom.constant = 15
            for View in OutsiderView{
                if View == DatePickerView{
                    heightConstraint?.constant = DatePicker.frame.height + DoneView.frame.height + DownViewBottom.constant
                }else if View == GenderView{
                    heightConstraint?.constant = GenderView.GenderPicker.frame.height + GenderView.DoneView.frame.height + DownViewBottom.constant
                }
            }
        }else{
            for View in OutsiderView{
                if View == DatePickerView{
                    heightConstraint?.constant = DatePicker.frame.height + DoneView.frame.height
                }else if View == GenderView{
                    heightConstraint?.constant = GenderView.GenderPicker.frame.height + GenderView.DoneView.frame.height + DownViewBottom.constant
                }
            }
        }
    }
    
    
    
    @IBAction func btnbackAction(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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
                self.theme.Set(CountryCode: self.lblCountryCode, WithFlag: self.CountryFlag)
                self.isLoginLocation = true
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: kLocationNotification), object:nil,userInfo :nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        stackviewEmailVerify.isHidden = true
        viewEmailVerify.isHidden = true
        stackviewMobileVerify.isHidden = true
        viewMobileVerify.isHidden = true
        
        if isEmailVerify == true
        {
            WidthBtnEmailOtp.constant = 0
            
            self.email_textField.isUserInteractionEnabled = false
            
        }
        else
        {
            
            self.email_textField.isUserInteractionEnabled = true
        }
        if isMobileVerify == true
        {
            WidthBtnPhoneOtp.constant = 0
           
            txt_PhoneNnumber.text = PhoneDict.value(forKey: "number") as? String ?? ""
            self.txt_PhoneNnumber.isUserInteractionEnabled = false
            print(PhoneDict.value(forKey: "code") as? String ?? "")
            print(phoneCodeImage)
            lblCountryCode.text = PhoneDict.value(forKey: "code") as? String ?? ""
            CountryFlag.image = phoneCodeImage
        }
        else
        {
          
            

            self.locationManager.requestWhenInUseAuthorization()
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            self.theme.Set(CountryCode: lblCountryCode, WithFlag: CountryFlag)

        }
        
        
        self.DatePickerView.DoneButton.backgroundColor = PlumberThemeColor
        self.GetAboutDetails()
        imagePicker = UIImagePickerController()
        titleLbl.text = theme.setLang("register")
        //BAckButtonView.SetBackButtonShadow()
        //set name to lable
        //self.addDoneButtonOnKeyboard()
        self.TaskerImage.layer.cornerRadius = TaskerImage.frame.width/2
        self.TaskerImage.layer.borderColor = PlumberThemeColor.cgColor
        self.TaskerImage.layer.borderWidth = 1.5
        self.AddTaskerImageBtn.layer.cornerRadius = AddTaskerImageBtn.frame.width/2
        self.AddTaskerImageBtn.tintColor = PlumberThemeColor
        self.SubHeaderLbl.text = "Personal Info"
        self.male_Lbl.text = self.theme.setLang("Male")
        self.female_Lbl.text = self.theme.setLang("Female")
        self.others_Lbl.text = self.theme.setLang("other")
        //delegate Calling
        self.FirstnameTxtfield.delegate = self
        self.LastNameTxtfield.delegate = self
        self.email_textField.delegate = self
        self.RadiusTxtfield.delegate = self
        self.GenderView.GenderPicker.delegate = self
        self.GenderView.GenderPicker.dataSource = self
        imagePicker.delegate = self
        // Button Text
        self.submit_btn.setTitle(theme.setLang("register"), for: .normal)
        self.DateofbirthButton.setTitle(theme.setLang("DOB"), for: .normal)
        self.AddressButton.setTitle(theme.setLang("Address"), for: .normal)
        // hide validation lbl
        self.hidevalidationlbl()
        //setRadio
        self.maleRadio_Img.image = UIImage(named: "radio_empty")
        self.femaleRadio_Img.image = UIImage(named: "radio_empty")
        self.othersRadio_Img.image = UIImage(named: "radio_empty")
        self.maleRadio_Img.image = UIImage(named: "radio_empty")
        self.femaleRadio_Img.image = UIImage(named: "radio_empty")
        self.othersRadio_Img.image = UIImage(named: "radio_empty")
        //Attributed Texts
        self.setAttributeString()
        self.setAttributeString1()
        self.setAttributeString2()
//        let MaintremsString : String = self.theme.setLang("trems_and_cond")
//        let tremsStringToColor = self.theme.setLang("termuse")
//        let TogethertremsString = "\(MaintremsString)\(" ")\(tremsStringToColor)"
//        let tremsrange = (TogethertremsString as NSString).range(of: tremsStringToColor)
//        let tremsattribute = NSMutableAttributedString.init(string: TogethertremsString)
//        tremsattribute.addAttribute(NSAttributedStringKey.foregroundColor, value: PlumberThemeColor , range: tremsrange)
//        tremsattribute.addAttribute(NSAttributedStringKey.link, value:"1", range: tremsrange)
////        let str:NSMutableAttributedString = NSMutableAttributedString.init(string:"\(self.theme.setLang("trems_and_cond")) \(self.theme.setLang("termuse"))")
////        str.addAttribute(NSAttributedStringKey.link, value:"1", range: NSRange(location:35,length:12))
//
//        trems_cond_lbl.attributedText = tremsattribute
//        trems_cond_lbl.textAlignment = .left
        trems_cond_lbl.font = PlumberMediumBoldFont
        trems_cond_lbl.delegate = self
        trems_cond_lbl.isSelectable = false
        trems_cond_lbl.isEditable = false
        Contractor_agreement_lbl.font = PlumberMediumBoldFont
        Contractor_agreement_lbl.delegate = self
        Contractor_agreement_lbl.isSelectable = false
        Contractor_agreement_lbl.isEditable = false
        professional_agreement_lbl.font = PlumberMediumBoldFont
        professional_agreement_lbl.delegate = self
        professional_agreement_lbl.isSelectable = false
        professional_agreement_lbl.isEditable = false
        let MainString : String = self.theme.setLang("Become a")
        let StringToColor = ProductShortAppName
        let TogetherString = "\(MainString)\(" ")\(StringToColor)"
        let range = (TogetherString as NSString).range(of: StringToColor)
        let attribute = NSMutableAttributedString.init(string: TogetherString)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: PlumberThemeColor , range: range)
        self.HeaderLbl.attributedText = attribute
        
        AboutTableView.estimatedRowHeight = 40
        AboutTableView.rowHeight = UITableView.automaticDimension
        ques_height.constant = 0
        // textfield place Holders
        self.FirstnameTxtfield.placeholder = theme.setLang("firstNAme")
        self.LastNameTxtfield.placeholder = theme.setLang("lastName")
        self.email_textField.placeholder = theme.setLang("e_mailplace")
        
        //Validation Lable text
        self.FirstnameValid_Lbl.text = theme.setLang("enter_First_NAme")
        self.LastNameValid_Lbl.text = theme.setLang("enter_Last_NAme")
        self.email_valid_lbl.text = theme.setLang("miss_e_mail")
        self.mobile_valid_lbl.text = "Enter Phone number"
        self.DateOfBirthValid_Lbl.text = theme.setLang("miss_dob")
        self.GenderValid_Lbl.text = theme.setLang("miss_gender")
        self.AddressValid_Lbl.text = theme.setLang("address_valid")
        self.RadiusValid_Lbl.text = theme.setLang("radius_mand")
        self.CheckBoxButton.tintColor = PlumberThemeColor
        self.CheckBoxButton.setImage(UIImage(named: "Unchecked_Checkbox"), for: .normal)
        
        self.CheckBoxButton1.tintColor = PlumberThemeColor
        self.CheckBoxButton1.setImage(UIImage(named: "Unchecked_Checkbox"), for: .normal)
        
        self.CheckBoxButton2.tintColor = PlumberThemeColor
        self.CheckBoxButton2.setImage(UIImage(named: "Unchecked_Checkbox"), for: .normal)
        
        self.SetDatePicker()
        //SetGenderPicker
        if emailVerify != ""
        {
            self.email_textField.text = emailVerify
        }
      
        GenderData = ["\(theme.setLang("Male"))","\(theme.setLang("Female"))","\(theme.setLang("Not_To_Mention"))"]
    }
    @IBAction func btnMobileGetOtpAction(_ sender: Any) {
        if (txt_PhoneNnumber.text?.count)! >= MinimummobileValidation
        {
            let phoneNumberKit = PhoneNumberKit()
            let countryInt = UInt64 (lblCountryCode.text!)
            let country =  phoneNumberKit.mainCountry(forCode: countryInt!)
            
            let regionCode = self.theme.CheckMobileNoAndCountryCodeIsValid(countryCode: lblCountryCode.text!, phoneNumber: txt_PhoneNnumber.text!)
            if regionCode == country ?? ""
            {
                self.getOtpPhone()
            }
            else{
                self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Mobile No Doesn't Match With Country Code", comment: nil), ButtonTitle: kOk)
            }
           
        }
        else{
            self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("valid_Mobile", comment: nil), ButtonTitle: kOk)
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
                        let status=self.theme.CheckNullValue(responseObject["status"])
                        if(status == "1")
                        {
                            print(responseObject)
                            
                            
                            self.OTPStatus = self.theme.CheckNullValue(responseObject["otp_status"])
                            self.UserType = self.theme.CheckNullValue(responseObject["user_type"])
                            self.OTP = self.theme.CheckNullValue(responseObject["otp"])
                            let objPhoneDict = responseObject["phone"] as? [String:Any] ?? [:]
                            self.PhoneDict = objPhoneDict as NSDictionary
                            SessionManager.sharedinstance.ExpertsAvailableRadius = self.theme.CheckNullValue(responseObject["radius"])
                            Registerrec["radius"] = SessionManager.sharedinstance.ExpertsAvailableRadius
                            self.stackviewMobileVerify.isHidden = false
                            self.viewMobileVerify.isHidden = false
                            self.DismissProgress()
                            
                            self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("enter_sent_OTP", comment: nil), ButtonTitle: kOk)
                        }
                        else{
                             let Error = self.theme.CheckNullValue(responseObject["msg"])
                            self.theme.AlertView(appNameJJ, Message: Error, ButtonTitle: kOk)
                            self.DismissProgress()
                            
                        }
                    }else{
                        self.view.makeToast(message:Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                        self.DismissProgress()
                    }
                }
            }
        }else{
            self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("valid_Mobile", comment: nil), ButtonTitle: kOk)
        }
    }
    
//MARK: - Verify Mobile number
    
    @IBAction func btnVerificationPhoneNumberAction(_ sender: Any)
    {
        if txt_PhoneNnumber_verify.text! == ""
        {
            self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("enter_sent_OTP", comment: nil), ButtonTitle: kOk)
        }
        else
        {
            if txt_PhoneNnumber_verify.text! == OTP
            {
                self.theme.saveCountryCode(lblCountryCode.text ?? "")
                self.theme.AlertView("", Message: Language_handler.VJLocalizedString("Phone Verify successfully", comment: nil), ButtonTitle: kOk)
                stackviewMobileVerify.isHidden = true
                viewMobileVerify.isHidden = true
                isMobileVerify = true
                let PhoneDict1 : NSDictionary = ["code":"\(lblCountryCode.text ?? "")",
                                                "number":"\(txt_PhoneNnumber.text ?? "")"]
                self.PhoneDict = PhoneDict1
            }
            else
            {
                self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Enter_Valid_Otp", comment: nil), ButtonTitle: kOk)
            }
        }
    }
    @IBAction func didclickCountry(_ sender: Any)
    {
        if isMobileVerify == false
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
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {}
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String, countryFlagImage: UIImage) {
        lblCountryCode.text = dialCode
        CountryFlag.image = countryFlagImage
        picker.navigationController?.popAnimationFade(animated: true)
        txt_PhoneNnumber.becomeFirstResponder()
    }
    @IBAction func btnEmailGetOtpAction(_ sender: Any) {
        if (email_textField.text?.count)! >= 6
        {
            verificationapicall()
        }
        else
        {
            self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Please Enter Valid Email ", comment: nil), ButtonTitle: kOk)
        }
    }
    @IBAction func btnEmailVerifyAction(_ sender: Any) {
        
        
        let FinalOTP = "\(self.email_textField_verify.text ?? "")"
        if FinalOTP == ""
        {
            theme.AlertView("", Message: Language_handler.VJLocalizedString("enter_otp", comment: nil), ButtonTitle: kOk)
        }
        else
        {
            
            if FinalOTP == OTP
            {
                isEmailVerify =  true
                stackviewEmailVerify.isHidden = true
                viewEmailVerify.isHidden = true
                theme.AlertView("", Message: Language_handler.VJLocalizedString("Email Verify successfully", comment: nil), ButtonTitle: kOk)
            }
            else
            {
                theme.AlertView("", Message: Language_handler.VJLocalizedString("Please Enter Valid OTP", comment: nil), ButtonTitle: kOk)
            }
        }
    }
    func verificationapicall()
    {
        self.showProgress()
        let PhoneDict : NSDictionary = ["email":email_textField.text!]
        url_handler.makeCall(MobileLoginUrl, param: PhoneDict as NSDictionary, completionHandler:{ (responseObject, error) -> () in
            if(error != nil)
            {
                self.theme.AlertView("", Message: kErrorMsg, ButtonTitle: kOk)
                self.DismissProgress()
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.theme.CheckNullValue(responseObject["status"])
                    if(status == "1"){
                        self.DismissProgress()
                        print(responseObject)
                        self.OTP = self.theme.CheckNullValue(responseObject["otp"])
                        let OtpStatus = self.theme.CheckNullValue(responseObject["otp_status"])
                        let userType = self.theme.CheckNullValue(responseObject["user_type"])
                        let Phone = responseObject["phone"] as? [String:Any] ?? [:]
                        let code = self.theme.CheckNullValue(Phone["code"])
                        let number = self.theme.CheckNullValue(Phone["number"])
                        
                        self.UserType = userType
                        self.stackviewEmailVerify.isHidden = false
                        self.viewEmailVerify.isHidden = false
                       // self.CountryCode = code
                       
                    }
                    else{
                        let Error = self.theme.CheckNullValue(responseObject["errors"])
                        self.theme.AlertView("", Message: Error , ButtonTitle: kOk)
                        self.DismissProgress()
                        
                    }
                }else{
                    self.theme.AlertView("", Message: Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), ButtonTitle: kOk)
                    self.DismissProgress()
                }
            }
        })
    }
    
    func setAttributeString()
    {
        let MaintremsString : String = self.theme.setLang("trems_and_cond")
        let tremsStringToColor = self.theme.setLang("termuse")
        let normalAttributes = [NSAttributedString.Key.font:PlumberBodyFont ,NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.75)]
        let colorAttributes = [NSAttributedString.Key.font:PlumberBodyFont,NSAttributedString.Key.foregroundColor: PlumberThemeColor]
        let TogethertremsString = "\(MaintremsString)\(" ")\(tremsStringToColor)"
        trems_cond_lbl.text = TogethertremsString
        let mainText = NSMutableAttributedString()
        let myAttrString1 = NSAttributedString(string: MaintremsString, attributes: normalAttributes as [NSAttributedString.Key : Any])
        mainText.append(myAttrString1)
        let myAttrStringSpace = NSAttributedString(string: "\n" , attributes: normalAttributes as [NSAttributedString.Key : Any])
        mainText.append(myAttrStringSpace)
        let myAttrString2 = NSAttributedString(string: tremsStringToColor, attributes: colorAttributes as [NSAttributedString.Key : Any])
        mainText.append(myAttrString2)
        trems_cond_lbl.attributedText = mainText
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.termsOfServiceTapped(_:)))
        trems_cond_lbl.addGestureRecognizer(tap)
    }
    func setAttributeString1()
    {
      
        let MaintremsString : String = self.theme.setLang("trems_and_cond")
        let tremsStringToColor = "Independent Contractor agreement"
        let normalAttributes = [NSAttributedString.Key.font:PlumberBodyFont ,NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.75)]
        let colorAttributes = [NSAttributedString.Key.font:PlumberBodyFont,NSAttributedString.Key.foregroundColor: PlumberThemeColor]
        let TogethertremsString = "\(MaintremsString)\(" ")\(tremsStringToColor)"
        Contractor_agreement_lbl.text = TogethertremsString
        let mainText = NSMutableAttributedString()
        let myAttrString1 = NSAttributedString(string: MaintremsString, attributes: normalAttributes as [NSAttributedString.Key : Any])
        mainText.append(myAttrString1)
        let myAttrStringSpace = NSAttributedString(string: "\n" , attributes: normalAttributes as [NSAttributedString.Key : Any])
        mainText.append(myAttrStringSpace)
        let myAttrString2 = NSAttributedString(string: tremsStringToColor, attributes: colorAttributes as [NSAttributedString.Key : Any])
        mainText.append(myAttrString2)
        Contractor_agreement_lbl.attributedText = mainText
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.Contractor_agreementTapped(_:)))
        Contractor_agreement_lbl.addGestureRecognizer(tap)
    }
    func setAttributeString2()
    {
        let MaintremsString : String = self.theme.setLang("trems_and_cond")
        let tremsStringToColor = "Professional agreement"
        let normalAttributes = [NSAttributedString.Key.font:PlumberBodyFont ,NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.75)]
        let colorAttributes = [NSAttributedString.Key.font:PlumberBodyFont,NSAttributedString.Key.foregroundColor: PlumberThemeColor]
        let TogethertremsString = "\(MaintremsString)\(" ")\(tremsStringToColor)"
        professional_agreement_lbl.text = TogethertremsString
        let mainText = NSMutableAttributedString()
        let myAttrString1 = NSAttributedString(string: MaintremsString, attributes: normalAttributes as [NSAttributedString.Key : Any])
        mainText.append(myAttrString1)
        let myAttrStringSpace = NSAttributedString(string: "\n" , attributes: normalAttributes as [NSAttributedString.Key : Any])
        mainText.append(myAttrStringSpace)
        let myAttrString2 = NSAttributedString(string: tremsStringToColor, attributes: colorAttributes as [NSAttributedString.Key : Any])
        mainText.append(myAttrString2)
        professional_agreement_lbl.attributedText = mainText
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.professional_agreementTapped(_:)))
        professional_agreement_lbl.addGestureRecognizer(tap)
    }
    
    @objc private func termsOfServiceTapped(_ sender: UITapGestureRecognizer){
        self.termsOfServiceTappedfunc(sender)
    }
    @objc private func Contractor_agreementTapped(_ sender: UITapGestureRecognizer){
        self.ContractorTappedfunc(sender)
    }
    @objc private func professional_agreementTapped(_ sender: UITapGestureRecognizer){
        self.perFomanceServiceTappedfunc(sender)
    }
    
    @objc func ContractorTappedfunc(_ sender: UITapGestureRecognizer) {
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < myTextView.textStorage.length {
            print("character index: \(characterIndex)")
            let myRange = NSRange(location: characterIndex, length: 1)
            let substring = (myTextView.attributedText.string as NSString).substring(with: myRange)
            print("character at index: \(substring)")
            _ = "MyCustomAttributeName"
            let attributeValue = myTextView.attributedText.attribute(NSAttributedString.Key.foregroundColor, at: characterIndex, effectiveRange: nil) as? UIColor
            if let value = attributeValue{
                switch value{
                case UIColor.black.withAlphaComponent(1):
                    print("normal")
                    break
                case PlumberThemeColor:
                    print("link-------")
                    self.openContractorCondition()
                    break
                default:
                    break
                }
            }
        }
    }
    
    @objc func termsOfServiceTappedfunc(_ sender: UITapGestureRecognizer) {
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < myTextView.textStorage.length {
            print("character index: \(characterIndex)")
            let myRange = NSRange(location: characterIndex, length: 1)
            let substring = (myTextView.attributedText.string as NSString).substring(with: myRange)
            print("character at index: \(substring)")
            _ = "MyCustomAttributeName"
            let attributeValue = myTextView.attributedText.attribute(NSAttributedString.Key.foregroundColor, at: characterIndex, effectiveRange: nil) as? UIColor
            if let value = attributeValue{
                switch value{
                case UIColor.black.withAlphaComponent(1):
                    print("normal")
                    break
                case PlumberThemeColor:
                    print("link-------")
                    self.openTermsAndCondition()
                    break
                default:
                    break
                }
            }
        }
    }
    @objc func perFomanceServiceTappedfunc(_ sender: UITapGestureRecognizer) {
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < myTextView.textStorage.length {
            print("character index: \(characterIndex)")
            let myRange = NSRange(location: characterIndex, length: 1)
            let substring = (myTextView.attributedText.string as NSString).substring(with: myRange)
            print("character at index: \(substring)")
            _ = "MyCustomAttributeName"
            let attributeValue = myTextView.attributedText.attribute(NSAttributedString.Key.foregroundColor, at: characterIndex, effectiveRange: nil) as? UIColor
            if let value = attributeValue{
                switch value{
                case UIColor.black.withAlphaComponent(1):
                    print("normal")
                    break
                case PlumberThemeColor:
                    print("link-------")
                    self.professionalCondition()
                    break
                default:
                    break
                }
            }
        }
    }
    
    func openTermsAndCondition(){
        let termsAndCondtns_VC:TermsAndConditionsViewController=self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        termsAndCondtns_VC.url_String = "Terms of Use"
        self.navigationController?.pushViewController(withFade: termsAndCondtns_VC, animated: false)
    }
    
    func openContractorCondition(){
        let termsAndCondtns_VC:TermsAndConditionsViewController=self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        termsAndCondtns_VC.url_String = "Contractor agreement"
        self.navigationController?.pushViewController(withFade: termsAndCondtns_VC, animated: false)
    }
    
    func professionalCondition(){
        let termsAndCondtns_VC:TermsAndConditionsViewController=self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        termsAndCondtns_VC.url_String = "Professional agreement"
        self.navigationController?.pushViewController(withFade: termsAndCondtns_VC, animated: false)
    }
    
    func GetAboutDetails(){
        self.showProgress()
        url_handler.makeCall(registration_Qestion, param:["":""]) { (responseObject, error) in
            if error != nil
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                self.DismissProgress()
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let status=self.theme.CheckNullValue(responseObject?.object(forKey: "status") as AnyObject)
                    if(status == "1")
                    {
                        let responseObject = responseObject as? [String:Any] ?? [:]
                        let questions = responseObject["response"] as! NSArray
                        self.DistanceStr = self.theme.CheckNullValue(responseObject["distanceby"])
//                        self.RadiusTxtfield.placeholder = "\(self.theme.setLang("Radius"))\("-")\(self.DistanceStr)"
                        for ques in questions
                        {
                            let ques = ques as? [String:Any] ?? [:]
                            let ques_rec = QuestionRec()
                            ques_rec.quesId = self.theme.CheckNullValue(ques["_id"])
                            ques_rec.quesTitle = self.theme.CheckNullValue(ques["question"])
                            ques_rec.question = " "
                            self.QuestionsArray.append(ques_rec)
                        }
                        self.AboutTableView.reloadData()
                    }
                    else
                    {
                        let response = self.theme.CheckNullValue(responseObject?.object(forKey:"response"))
                        self.theme.AlertView(appNameJJ, Message: response, ButtonTitle: kOk)
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
        }
    }
    
    func SetDatePicker(){
        let calendar = Calendar(identifier: .gregorian)
        
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        components.year = -19
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        components.year = -150
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        DatePicker.minimumDate = minDate
        DatePicker.maximumDate = maxDate
    }
    
//    func addDoneButtonOnKeyboard(){
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        doneToolbar.barStyle = .default
//
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
//
//        let items = [flexSpace, done]
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//
//        RadiusTxtfield.inputAccessoryView = doneToolbar
//    }
    
//    @objc func doneButtonAction(){
//        RadiusTxtfield.resignFirstResponder()
//    }
//
    override func viewDidLayoutSubviews() {
        self.submit_btn.applyGradientwithcorner()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // back button Action
    @IBAction func didClickbackbtn(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: InitialViewControllerTwo.self) {
                AvailableArray.removeAll()
                _ =  self.navigationController!.popToViewController(controller, animated: false)
                break
            }
        }
    }
    @IBAction func didclickSelectDOB(_ sender: Any) {
        self.resignkeyboard()
        self.view.AddBlurEffect()
        self.theme.MakeAnimation(view: self.DatePickerView, animation_type: CSAnimationTypeSlideUp)
        self.view.addSubview(DatePickerView)
        DatePickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: DatePickerView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: DatePickerView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: DatePickerView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute:.bottom, multiplier: 1, constant: 0).isActive = true
        heightConstraint =  NSLayoutConstraint(item: DatePickerView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1000)
        heightConstraint?.isActive = true
        DatePickerView.layoutIfNeeded()
        
    }
    @IBAction func didclcikGenderBtn(_ sender: Any) {
        self.view.AddBlurEffect()
        self.theme.MakeAnimation(view: self.GenderView , animation_type: CSAnimationTypeSlideUp)
        self.view.addSubview(GenderView)
        GenderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: GenderView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: GenderView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: GenderView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute:.bottom, multiplier: 1, constant: 0).isActive = true
        heightConstraint =  NSLayoutConstraint(item: GenderView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220)
        heightConstraint?.isActive = true
        GenderView.layoutIfNeeded()
    }
    
    @IBAction func didclcikDoeBtn(_ sender: UIButton) {
        let ButtonTag = sender.tag
        if ButtonTag == 0 /*Date of birth View*/{
            self.GetDate()
            self.theme.MakeAnimation(view: self.DatePickerView , animation_type: CSAnimationTypeSlideDown)
            self.DateOfBirthValid_Lbl.isHidden = true
            self.DatePickerView.removeFromSuperview()
            self.view.removeBlurEffect()
        }else if ButtonTag == 1 /*Gender View*/{
            self.GetGender()
            self.theme.MakeAnimation(view: self.GenderView , animation_type: CSAnimationTypeSlideDown)
            self.GenderView.removeFromSuperview()
            self.view.removeBlurEffect()
        }
    }
    
    func GetDate(){
        DatePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let selectedDate = dateFormatter.string(from: DatePicker.date)
        print("selectedDate",selectedDate)
        DateofbirthButton.setTitle(selectedDate, for: .normal)
        DateofbirthButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    func GetGender(){
        SelectedGender = GenderData[GenderView.GenderPicker.selectedRow(inComponent: 0)]
    }
    
    @IBAction func didclickRadioBtn(_ sender: UIButton) {
        let ButtonTag = sender.tag
        self.maleRadio_Img.image = UIImage(named: "radio_empty")
        self.femaleRadio_Img.image = UIImage(named: "radio_empty")
        self.othersRadio_Img.image = UIImage(named: "radio_empty")
        if ButtonTag == 0{//male
            self.maleRadio_Img.image = UIImage(named: "radio_filled")
            SelectedGender = male_Lbl.text!
        }else if ButtonTag == 1{//female
            self.femaleRadio_Img.image = UIImage(named: "radio_filled")
            SelectedGender = female_Lbl.text!
        }else if ButtonTag == 2{//others
            self.othersRadio_Img.image = UIImage(named: "radio_filled")
            SelectedGender = others_Lbl.text!
        }
    }
    
    
    @IBAction func didclickUploadImage(_ sender: Any) {
        let ImagePicker_Sheet = UIAlertController(title: nil, message: theme.setLang("select_image"), preferredStyle: .actionSheet)
        let Camera_Picker = UIAlertAction(title: theme.setLang("camera") , style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.Camera_Pick()
        })
        let Gallery_Picker = UIAlertAction(title:theme.setLang("gallery") , style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.Gallery_Pick()
        })
        let cancelAction = UIAlertAction(title: theme.setLang("cancel_small"), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        ImagePicker_Sheet.addAction(Camera_Picker)
        ImagePicker_Sheet.addAction(Gallery_Picker)
        ImagePicker_Sheet.addAction(cancelAction)
        
        self.present(ImagePicker_Sheet, animated: true, completion: nil)
    }
    
    func Camera_Pick()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            DispatchQueue.main.async
            {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.imagePicker.showsCameraControls = true
                self.imagePicker.videoMaximumDuration = 60.0;
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "Sorry, this device has no camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func Gallery_Pick()
    {
        DispatchQueue.main.async
        {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.videoMaximumDuration = 60.0;
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if ((info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage) != nil) {
            self.TaskerImage.image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
            let pickimage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
            let pickedimage = self.theme.rotateImage(pickimage!)
            isimgupload = true
            let Image = pickedimage.ResizeImage(image: pickedimage, targetSize: CGSize(width: 500, height: 500))
            imagedata = Image.jpegData(compressionQuality: 1)!
            self.uploadImageAndData()
        }
        else
        {
            
        }
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: -  Address action
    
    
    @IBAction func didclickAddressButton(_ sender: Any) {
        
        isaddressPresent = false
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            withIdentifier: "ChooseLocationViewController") as?  ChooseLocationViewController{
            if let navigator = self.navigationController
            {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                viewController.delegate = self
                viewController.isFromRegister = true
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
        self.view.endEditing(true)
    }
    //MARK: -  Radius delegate
    
    func passaddressobj(_ addressArray: NSMutableArray, radius: Int) {
        self.radius = radius
        let sampleArray = addressArray
        if  isaddressPresent ?? true
        {
            
        }else{
            let SelectedAddress = sampleArray.object(at: 2) as? String
            self.AddressButton.setTitle(SelectedAddress, for: .normal)
            self.AddressButton.setTitleColor(UIColor.black, for: .normal)
            self.AddressButton.titleLabel?.numberOfLines = 2
            let loc_cord = CLLocationCoordinate2D.init(latitude:Double(theme.CheckNullValue(sampleArray.object(at: 0)))!, longitude:Double(theme.CheckNullValue(sampleArray.object(at: 1)))!)
            self.address_Coord = loc_cord
        }
    }
    
    func uploadImageAndData(){
        let objUserRecs:UserInfoRecord=self.theme.GetUserDetails()
        let param = ["":""]
        
        self.showProgress()
        
        let URL = try! URLRequest(url: registerImageupload, method: .post, headers: ["apptype": "ios", "apptoken":"\(theme.GetDeviceToken())", "providerid":"\(objUserRecs.providerId)"])
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(self.imagedata, withName: "image", fileName: "image.png", mimeType: "")
            
            for (key, value) in param {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
            
        }, with: URL, encodingCompletion: { encodingResult in
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    if let js = response.result.value {
                        let JSON = js as! NSDictionary
                        self.DismissProgress()
                        print("JSON: \(JSON)")
                        
                        let Status = self.theme.CheckNullValue(JSON.object(forKey: "status"))
                        
                        if(Status == "1")
                        {
                            let response = JSON.object(forKey: "response") as! NSDictionary
                            let URL = try! URLRequest(url: self.theme.CheckNullValue(response.object(forKey: "image")), method: .get, headers: nil)
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//                                self.TaskerImage.sd_setImage(with: URL.url , placeholderImage: #imageLiteral(resourceName: "Profile_Avatar"))
                            })
                            self.theme.saveUserImage(self.theme.CheckNullValue(response.object(forKey: "image")) as NSString)
                            self.imageurl = self.theme.CheckNullValue(response.object(forKey: "image"))
                        }
                        else
                        {
                            
                            self.TaskerImage.image = UIImage(named: "Profile_Avatar")
                        }
                    }
                }
            case .failure(let encodingError):
                print(" the encodeing error is \(encodingError)")
            }
        })
    }
    @IBAction func didclickcheckboxbtn(_ sender: UIButton) {
        let checkImage = UIImage(named: "Checked_Checkbox")
        let uncheck_Image = UIImage(named: "Unchecked_Checkbox")
        if CheckBoxButton.imageView?.image == UIImage(named:"Checked_Checkbox"){
            CheckBoxButton.setImage(uncheck_Image, for: UIControl.State())
        }
        else{
            CheckBoxButton.setImage(checkImage, for: UIControl.State())
        }
    }
    
    @IBAction func didclickcheckboxbtn1Action(_ sender: UIButton) {
        let checkImage = UIImage(named: "Checked_Checkbox")
        let uncheck_Image = UIImage(named: "Unchecked_Checkbox")
        if CheckBoxButton1.imageView?.image == UIImage(named:"Checked_Checkbox"){
            CheckBoxButton1.setImage(uncheck_Image, for: UIControl.State())
        }
        else{
            CheckBoxButton1.setImage(checkImage, for: UIControl.State())
        }
    }
    @IBAction func didclickcheckbox2Action(_ sender: UIButton) {
        let checkImage = UIImage(named: "Checked_Checkbox")
        let uncheck_Image = UIImage(named: "Unchecked_Checkbox")
        if CheckBoxButton2.imageView?.image == UIImage(named:"Checked_Checkbox"){
            CheckBoxButton2.setImage(uncheck_Image, for: UIControl.State())
        }
        else{
            CheckBoxButton2.setImage(checkImage, for: UIControl.State())
        }
    }
    
    
        //MARK: - Api call on register
    
    @IBAction func didClickSubmitbtn(_ sender: UIButton) {
        guard let country_code = lblCountryCode.text else { return}
        guard let userPhone_num = txt_PhoneNnumber.text else { return}
        
        UserDefaults.standard.set(country_code, forKey: "countryCode") //setObject
        UserDefaults.standard.set(userPhone_num, forKey: "userPhoneNum") //setObject
        
        self.resignkeyboard() // resig All Keyboard
        self.hidevalidationlbl()// hide all validation
        if FirstnameTxtfield.text == "" {
            self.email_valid_lbl.text = theme.setLang("enter_First_NAme")
            self.FirstnameValid_Lbl.isHidden = false
            FirstnameTxtfield.becomeFirstResponder()
        }else if (FirstnameTxtfield.text?.count)! <= 3 {
            self.email_valid_lbl.text = theme.setLang("first_name_above_4")
            self.FirstnameValid_Lbl.isHidden = false
            FirstnameTxtfield.becomeFirstResponder()
        }
        else if LastNameTxtfield.text == "" {
            self.email_valid_lbl.text = theme.setLang("enter_Last_NAme")
            self.LastNameValid_Lbl.isHidden = false
            LastNameTxtfield.becomeFirstResponder()
        }
        else if email_textField.text == "" {
            self.email_valid_lbl.text = theme.setLang("miss_e_mail")
            self.email_valid_lbl.isHidden = false
            email_textField.becomeFirstResponder()
        }
        else if isEmailVerify == false
        {
            self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Please Verify Email ", comment: nil), ButtonTitle: kOk)
        }
        else if isMobileVerify == false && ((txt_PhoneNnumber.text?.isEmpty) == true){
            self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Please enter Phone number ", comment: nil), ButtonTitle: kOk)
        }
        else if isMobileVerify == false
        {
            self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Please Verify Phone number ", comment: nil), ButtonTitle: kOk)
        }
        else if mobile_valid_lbl.text == ""{
            self.mobile_valid_lbl.text = "Enter Phone number"
            self.mobile_valid_lbl.isHidden = false
            mobile_valid_lbl.becomeFirstResponder()
        }
        else if !(theme.isValidEmailAddress(emailAddressString: email_textField.text!))
        {
            self.email_valid_lbl.text = theme.setLang("email_valid")
            self.email_valid_lbl.isHidden = false
            email_textField.becomeFirstResponder()
        }
//        else if DateofbirthButton.titleLabel?.text == theme.setLang("DOB"){
//            self.DateOfBirthValid_Lbl.text = theme.setLang("dob_empty")
//            self.DateOfBirthValid_Lbl.isHidden = false
//        }
//        else if SelectedGender == " "{
//            self.GenderValid_Lbl.text = theme.setLang("Select_Gender")
//            self.GenderValid_Lbl.isHidden = false
//        }
        else if AddressButton.titleLabel?.text == theme.setLang("Address"){
            self.AddressValid_Lbl.text = theme.setLang("addressIs_mand")
            self.AddressValid_Lbl.isHidden = false
        }/*else if RadiusTxtfield.text == "" {
            self.RadiusValid_Lbl.text = theme.setLang("radius_mand")
            self.RadiusValid_Lbl.isHidden = false
            RadiusTxtfield.becomeFirstResponder()
        }else if Int(RadiusTxtfield.text!)! < 1 {
            self.RadiusValid_Lbl.isHidden = false
            RadiusValid_Lbl.text = self.theme.setLang("radius_valid")
        }*/
//        else if (CheckBoxButton.imageView?.image == UIImage(named:"Unchecked_Checkbox")){
//            theme.AlertView("\(appNameJJ)",Message: theme.setLang("TermsandConditValid"),ButtonTitle: kOk)
//        }
        else if (CheckBoxButton1.imageView?.image == UIImage(named:"Unchecked_Checkbox")){
            theme.AlertView("\(appNameJJ)",Message: theme.setLang("Kindly,Accept the Contractor agreement"),ButtonTitle: kOk)
        }
        else if (CheckBoxButton2.imageView?.image == UIImage(named:"Unchecked_Checkbox")){
            theme.AlertView("\(appNameJJ)",Message: theme.setLang("Kindly,Accept the Professional agreement"),ButtonTitle: kOk)
        }
        else {
            self.showProgress()
            let FirstName = FirstnameTxtfield.text
            let LastName = LastNameTxtfield.text
            let EmailID = email_textField.text
            let DOB = DateofbirthButton.titleLabel?.text
            let Gender = SelectedGender
            let Address = AddressButton.titleLabel?.text
            let Radius = RadiusTxtfield.text
            
            var QuesArray : [NSDictionary] = [NSDictionary]()
            for element in QuestionsArray
            {
                let quesDict : NSMutableDictionary = NSMutableDictionary()
                quesDict["question"] = element.quesId
                quesDict["answer"] = element.question
                quesDict["questitle"] = element.quesTitle
                QuesArray.append(quesDict)
            }
            var Param : NSDictionary = NSDictionary()
            Param = [ "firstname" : "\(FirstName ?? " ")",
                "lastname" : "\(LastName ?? " ")",
                "email": "\(EmailID ?? " ")",
                "dob" : "\(DOB ?? " ")",
                "gender" : "\(Gender )",
                "socialtype": self.socialtype,
                "socialId": self.socialId,
                "availability_address" : "\(Address ?? " ")",
                "location_lat" : "\(address_Coord?.latitude ?? 0.0)" ,
                "location_lng" : "\(address_Coord?.longitude ?? 0.0)",
                "profile_details" : QuesArray
            ]
            
            debugPrint("Register api para \(Param)")
            
            url_handler.makeCall(reg_form1 , param: Param as NSDictionary) {
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
                        let responseObject = responseObject!
                        let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                        if(status == "1")
                        {
                            let responseObject = responseObject as? [String:Any] ?? [:]
                            print(responseObject)
                            let Response = responseObject["response"] as? NSDictionary
                            self.theme.saveDocumentStatus(self.theme.CheckNullValue(responseObject["document_upload_status"]))
                            SessionManager.DocumentStatus = self.theme.CheckNullValue(responseObject["document_upload_status"])
                            Registerrec["firstname"] = self.theme.CheckNullValue(Response?["firstname"])
                            Registerrec["lastname"] = self.theme.CheckNullValue(Response?["lastname"])
                            Registerrec["email"] = self.theme.CheckNullValue(Response?["email"])
                            Registerrec["dob"] = self.theme.CheckNullValue(Response?["dob"])
                            Registerrec["gender"] = self.theme.CheckNullValue(Response?["gender"])
                            Registerrec["availability_address"] = self.theme.CheckNullValue(Response?["availability_address"])
                            Registerrec["location_lat"] = self.theme.CheckNullValue(Response?["location_lat"])
                            Registerrec["location_lng"] = self.theme.CheckNullValue(Response?["location_lng"])
                            Registerrec["message"] = self.theme.CheckNullValue(Response?["message"])
                            Registerrec["profile_details"] = responseObject["profile_details"]
                            Registerrec["phone"] = self.PhoneDict
                            Registerrec["socialtype"] = self.socialtype
                            Registerrec["socialId"] = self.socialId
                            // Availablity ->
                            if AvailableArray.count <= 0{
                                AvailableArray.removeAll()
                                let WorkingDays = responseObject["working_days"] as? [Any]
                                for DaysObj in WorkingDays! {
                                    let DaysObj = DaysObj as? [String:Any]
                                    let AvailRec = AvailableRec()
                                    AvailRec.day =  self.theme.CheckNullValue(DaysObj?["day"])
                                    AvailRec.selected = DaysObj?["selected"] as? Bool
                                    AvailRec.wholeday = DaysObj?["wholeday"] as? Bool

                                    let SlotsArray = DaysObj?["slot"] as? [Any]
                                    for SlotsObj in SlotsArray!{
                                        let SlotsObj = SlotsObj as? [String:Any]
                                        let SlotsRec = Slots()
                                        SlotsRec.slotIndex = SlotsObj?["slot"] as? Int
                                        SlotsRec.TimeInterval = self.theme.CheckNullValue(SlotsObj?["time"])
                                        SlotsRec.selected = SlotsObj?["selected"] as? Bool ?? false
                                        AvailRec.SlotArray.append(SlotsRec)
                                    }
                                    AvailableArray.append(AvailRec)
                                }
                            }
                            
                            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFourthPageViewController") as?  RegFourthPageViewController{
                                if let navigator = self.navigationController
                                {
                                    let backItem = UIBarButtonItem()
                                    backItem.title = ""
                                    viewController.AvailableArray = AvailableArray
                                    self.navigationItem.backBarButtonItem = backItem
                                    navigator.pushViewController(withFade: viewController, animated: false)
                                }
                        }
                            
                            
                            
                        }
                        else
                        {
                            let response = self.theme.CheckNullValue(responseObject.object(forKey:"response"))
                            self.theme.AlertView(appNameJJ, Message: response, ButtonTitle: kOk)
                        }
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
            }
            
        }
    }
    
    func hidevalidationlbl () {
        for ValidLabels in ValidLabelArray
        {
            if ValidLabels.isKind(of:CustomvalidLabel.self)
            {
                let lbl = ValidLabels
                lbl.isHidden = true
            }
        }
    }
    func resignkeyboard ()
    {
        for Texfield in TextFieldsArray{
            if Texfield.isKind(of:BodyTextFieldStyle.self)
            {
                let TxtFld = Texfield
                TxtFld.resignFirstResponder()
            }
        }
    }
}
class RegisterRec : NSObject{
    static let sharedInstance = SocketIOManager()
    var register = [String:Any]()
}

@IBDesignable
class CustomRoundButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = PlumberThemeColor  // break point 2
        
    }
    @IBInspectable var backgrndColor: UIColor  = PlumberThemeColor {
        didSet {
            self.backgroundColor = backgrndColor
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            
        }
    }
    
    @IBInspectable var borderwidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderwidth
        }
    }
    @IBInspectable var setFont: Bool {
        
        get {
            return true
        }
        set {
            
            self.titleLabel?.font = UIFont(name: plumberMediumFontStr, size: 14)
        }
    }
    
    @IBInspectable var bordercolor : UIColor = UIColor.clear
        {
        didSet {
            self.layer.borderColor = bordercolor.cgColor
        }
    }
    
}

//--------------------------------------------
//MARK: - CREATED UITextField & UITextView EXTENSIONS
//--------------------------------------------
extension RegFirstPageViewController : UITextFieldDelegate ,UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == FirstnameTxtfield{
            if (self.theme.TextfieldMaximum(string, Textfield: textField, Count: MaximumFirstNameValidation, range: range))
            {
                return true
            }else
            {
                return false
            }
            
        }
        else if textField == LastNameTxtfield{
            if (self.theme.TextfieldMaximum(string, Textfield: textField, Count: MaximumLastNameValidation, range: range))
            {
                return true
            }else
            {
                return false
            }
        }
        else if textField == email_textField
        {
            if let _ = string.rangeOfCharacter(from: .uppercaseLetters) {
                // Don't allow upper case letters
                return false
            }
            return true
        }
        else
        {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = IndexPath(row: textField.tag, section: 0)
        let cell: QuestionTableViewCell = self.AboutTableView.cellForRow(at: index) as! QuestionTableViewCell
        if textField == cell.quesTxt{
            let getQuesrec = QuestionsArray[textField.tag]
            let replceQuesrec = QuestionRec()
            replceQuesrec.quesId = getQuesrec.quesId
            replceQuesrec.quesTitle = getQuesrec.quesTitle
            replceQuesrec.question = textField.text!
            QuestionsArray[textField.tag] =  replceQuesrec
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.hidevalidationlbl()
            })
    }
    
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView.resignFirstResponder()
//            return false
//        }
//        let getQuesrec = QuestionsArray[textView.tag]
//        let replceQuesrec = QuestionRec()
//        replceQuesrec.quesId = getQuesrec.quesId
//        replceQuesrec.quesTitle = getQuesrec.quesTitle
//        replceQuesrec.question = textView.text!
//        QuestionsArray[textView.tag] =  replceQuesrec
//        return true
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == FirstnameTxtfield{
            if textField.text != "" && LastNameTxtfield.text == ""{
                textField.resignFirstResponder()
                LastNameTxtfield.becomeFirstResponder()
            }
            else
            {
                textField.resignFirstResponder()
            }
        }
        else if textField == LastNameTxtfield{
            if textField.text != "" && email_textField.text == ""{
                textField.resignFirstResponder()
                email_textField.becomeFirstResponder()
            }
            else
            {
                textField.resignFirstResponder()
            }
        }
        else if textField==email_textField
        {
            if  textField.text != ""
            {
                textField.resignFirstResponder()
            }
        }
       /* else if textField==RadiusTxtfield
        {
            if  textField.text != ""
            {
                textField.resignFirstResponder()
            }
        }*/
        self.hidevalidationlbl()
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        print("get character range\(characterRange)")
        
        let get_String:NSString =  textView.text as NSString
        print(get_String.substring(with: NSMakeRange(characterRange.location, characterRange.length)))
        
        let selected_String =  get_String.substring(with: NSMakeRange(characterRange.location, characterRange.length))
        _ = selected_String.replacingOccurrences(of:" ", with: "")
        
        let termsAndCondtns_VC:TermsAndConditionsViewController=self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        termsAndCondtns_VC.url_String = selected_String
        self.navigationController?.pushViewController(withFade: termsAndCondtns_VC, animated: false)
        
        return false
    }
}

extension RegFirstPageViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return QuestionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"question", for: indexPath) as! QuestionTableViewCell
        cell.selectionStyle = .none
        let quesrec = QuestionsArray[indexPath.row]
        cell.quesTxt.placeholder = quesrec.quesTitle
        cell.quesTxt.tag = indexPath.row
        cell.quesTxt.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
//            self.ques_height.constant = self.AboutTableView.contentSize.height
//            self.AboutTableView.layoutIfNeeded()
//            })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension RegFirstPageViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GenderData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return GenderData[row]
    }
    
}

