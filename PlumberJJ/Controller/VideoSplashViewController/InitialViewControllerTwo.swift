//
//  InitialViewControllerTwo.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 6/10/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class InitialViewControllerTwo: UIViewController,MICountryPickerDelegate {
    
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var MobileNumberView: UIView!
    @IBOutlet weak var CountryFlag: UIImageView!
    @IBOutlet weak var CountryCode: UILabel!
    @IBOutlet weak var MobileTextField: UITextField!
    @IBOutlet weak var InstructionLabel: UILabel!
    @IBOutlet weak var NextButton: TKTransitionSubmitButton!
    @IBOutlet weak var NextView: UIView!
    @IBOutlet weak var BottomViewBottom: NSLayoutConstraint!
    var keyboardheight : CGFloat = 0.0
    let Themes = Theme()    
    var url_handler : URLhandler = URLhandler()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUI()
        // Do any additional setup after loading the view.
    }
    
    func SetUI(){
        NextView.dropShadow(shadowRadius: 8)
        NextButton.dropShadow(shadowRadius: 8)
        NextButton.layer.cornerRadius = NextButton.frame.height/2
        NextView.backgroundColor = PlumberThemeColor
        NextView.layer.cornerRadius = NextView.frame.height/2
        HeaderLabel.text = Language_handler.VJLocalizedString("Enter_Number", comment: nil)
        MobileTextField.delegate = self
        MobileTextField.placeholder = "08123456789"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.MobileTextField.frame.height))
        MobileTextField.leftView = paddingView
        MobileTextField.leftViewMode = UITextField.ViewMode.always
        MobileTextField.becomeFirstResponder()
        CountryCode.adjustsFontSizeToFitWidth = true
        self.Themes.Set(CountryCode: CountryCode, WithFlag: CountryFlag)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardheight = keyboardRectangle.height
        // do whatever you want with this keyboard height
        BottomViewBottom.constant = keyboardheight
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
    
    @IBAction func didclickNextButton(_ sender: Any)
    {
        if (MobileTextField.text?.count)! >= MinimummobileValidation
        {
            self.RemoveDB()
            NextButton.startLoadingAnimation()
            self.NextButton.isUserInteractionEnabled = false
            let PhoneDict : NSDictionary = ["code":"\(CountryCode.text ?? "")",
                                            "number":"\(MobileTextField.text ?? "")"]
            let Parameter : NSDictionary = ["phone" : PhoneDict]
            url_handler.makeCall(MobileLoginUrl , param: Parameter as NSDictionary) {
                (responseObject, error) -> () in
                if(error != nil)
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                    self.NextButton.returnToOriginalState()
                    self.NextButton.isUserInteractionEnabled = true
                }
                else
                {
                    if(responseObject != nil && (responseObject?.count)!>0)
                    {
                        let responseObject = responseObject as? [String:Any] ?? [:]
                        let status=self.Themes.CheckNullValue(responseObject["status"])
                        if(status == "1"){
                            print(responseObject)
                            let OTPStatus = self.Themes.CheckNullValue(responseObject["otp_status"])
                            let UsetType = self.Themes.CheckNullValue(responseObject["user_type"])
                            let Otp = self.Themes.CheckNullValue(responseObject["otp"])
                            let objPhoneDict = responseObject["phone"] as? [String:Any] ?? [:]
                            let PhoneNumber = self.Themes.CheckNullValue(objPhoneDict["number"])
                            let CountryCode = self.Themes.CheckNullValue(objPhoneDict["code"])
                            SessionManager.sharedinstance.ExpertsAvailableRadius = self.Themes.CheckNullValue(responseObject["radius"])
                            Registerrec["radius"] = SessionManager.sharedinstance.ExpertsAvailableRadius
                            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPVCID") as? OTPViewController{
                                if let navigator = self.navigationController
                                {
                                    viewController.Mobilenumber = PhoneNumber
                                    viewController.OTPStatus = OTPStatus
                                    viewController.UserType = UsetType
                                    viewController.OTP = Otp
                                    viewController.CountryCode = CountryCode
                                    navigator.pushViewController(withFade: viewController, animated: false)
                                }
                            }
                            self.NextButton.returnToOriginalState()
                            self.NextButton.isUserInteractionEnabled = true
                        }
                        else{
                             let Error = self.Themes.CheckNullValue(responseObject["msg"])
                            self.Themes.AlertView(appNameJJ, Message: Error, ButtonTitle: kOk)
                            self.NextButton.returnToOriginalState()
                            self.NextButton.isUserInteractionEnabled = true
                            
                        }
                    }else{
                        self.view.makeToast(message:Language_handler.VJLocalizedString("Unable_to_connect", comment: nil), duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                        self.NextButton.returnToOriginalState()
                        self.NextButton.isUserInteractionEnabled = true
                    }
                }
            }
        }else{
            self.Themes.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("valid_Mobile", comment: nil), ButtonTitle: kOk)
        }
    }
    
    @IBAction func didclickCancelButton(_ sender: Any) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {}
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String, countryFlagImage: UIImage) {
        CountryCode.text = dialCode
        CountryFlag.image = countryFlagImage
        picker.navigationController?.popAnimationFade(animated: true)
        MobileTextField.becomeFirstResponder()
    }
    func RemoveDB () {
        ObjCatArray.Sharedinstance.CategoryMainObj.removeAll()
        ObjCatArray.Sharedinstance.CAtRec.id = ""
        ObjCatArray.Sharedinstance.CAtRec.image = ""
        ObjCatArray.Sharedinstance.CAtRec.name = ""
    }
}
//--------------------------------------------
//MARK: - CREATED UITextField & UITextView EXTENSIONS
//--------------------------------------------
extension InitialViewControllerTwo : UITextFieldDelegate {
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
