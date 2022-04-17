//
//  LoginViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/18/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit
import CoreLocation



class LoginViewController: RootBaseViewController,UIViewControllerTransitioningDelegate,UITextFieldDelegate {
  //  var theme:Theme=Theme()
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var username_img: UIImageView!
    @IBOutlet weak var password_img: UIImageView!
    
    @IBOutlet weak var Wrapper_View: CSAnimationView!
    
    @IBOutlet var back_btn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginBtn: TKTransitionSubmitButton!
    @IBOutlet weak var loginScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decorateTxtField()
        self.username_img.image = self.username_img.changeImageColor(color: PlumberThemeColor)
        self.password_img.image = self.password_img.changeImageColor(color: PlumberThemeColor)
        Wrapper_View.SpringAnimations()
        loginBtn.SpringButton()
        Wrapper_View.layer.borderWidth=1.0
        Wrapper_View.layer.borderColor=UIColor.lightGray.cgColor
        Wrapper_View.layer.cornerRadius=3.0
        title_lbl.text = theme.setLang("\(appNameJJ)")

        userNameTxtField.delegate=self
        passwordTxtField.delegate=self
        
        forgotPasswordBtn.setTitle(Language_handler.VJLocalizedString("forgot_password_btn", comment: nil), for: UIControl.State())
        loginBtn.setTitle(Language_handler.VJLocalizedString("login", comment: nil), for: UIControl.State())
        userNameTxtField.placeholder = Language_handler.VJLocalizedString("email_placeholder", comment: nil)
        passwordTxtField.placeholder = Language_handler.VJLocalizedString("password_placeholder", comment: nil)

//      Wrapper_View.
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
    override func applicationLanguageChangeNotification(_ notification: Notification) {
        
        forgotPasswordBtn.setTitle(Language_handler.VJLocalizedString("forgot_password_btn", comment: nil), for: UIControl.State())
        loginBtn.setTitle(Language_handler.VJLocalizedString("login", comment: nil), for: UIControl.State())
        userNameTxtField.placeholder = Language_handler.VJLocalizedString("email_placeholder", comment: nil)
        passwordTxtField.placeholder = Language_handler.VJLocalizedString("password_placeholder", comment: nil)
    }

    func decorateTxtField(){
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        userNameTxtField.layer.borderWidth=1
        userNameTxtField.layer.borderColor=UIColor.white.cgColor
        userNameTxtField.layer.masksToBounds=true
        
        passwordTxtField.layer.borderWidth=1
        passwordTxtField.layer.borderColor=UIColor.white.cgColor
        passwordTxtField.layer.masksToBounds=true
        
        loginBtn.layer.cornerRadius=20
        loginBtn.layer.masksToBounds=true
       // loginScrollView.contentSize=CGSizeMake(loginScrollView.frame.size.width, forgotPasswordBtn.frame.origin.y+forgotPasswordBtn.frame.size.height+30)
    }

    @IBAction func didClickLoginBtn(_ sender: AnyObject) {
        self.view.endEditing(true)
        if(validateTxtFields()){
            
            loginBtn.startLoadingAnimation()

            let devicetoken = theme.GetDeviceToken()
            var token:String
            if devicetoken == ""{
                 token = "abcd"
            }
            else {
                token = devicetoken as String
            }
            
            let Param: Dictionary = ["email":"\(userNameTxtField.text!)",
                "password":"\(passwordTxtField.text!)","deviceToken":"\(token)"]
            
            url_handler.makeCall(LoginUrl, param: Param as NSDictionary) {
                (responseObject, error) -> () in
                if(error != nil)
                {
                    print("error responded with: \(String(describing: error))")
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                }
                else
                {
                     if(responseObject != nil)
                    {
                        let responseObject = responseObject!
                        let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"));
                        
                        if(status == "1")
                        {
                            self.theme.saveUserDetail((responseObject.object(forKey: "response"))! as! NSDictionary)
                            
                            let ResponseDict  : NSDictionary = responseObject.object(forKey: "response") as! NSDictionary
                            let currencycode: String = self.theme.getCurrencyCode(self.theme.CheckNullValue(ResponseDict.object(forKey: "currency"))) as String
                            self.theme.saveappCurrencycode( currencycode as String )
                            
                            let _:UserInfoRecord=self.theme.GetUserDetails()
                            SocketIOManager.sharedInstance.establishConnection()
                            SocketIOManager.sharedInstance.establishChatConnection()
                            if(self.theme.isUserLigin()){
                                self.loginBtn.startFinishAnimation(1, completion: {
                                    self.perform(#selector(self.updateAvailbility), with: nil, afterDelay: 0.5)
                                    self.theme.UpdateAvailability("1")
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.setInitialViewcontroller()
                                    let socStr:NSString = ""//dict.objectForKey("soc_key") as! NSString
                                    if(socStr.length>0){
                                        self.theme.saveJaberPassword(socStr as String)
                                    }
                                })
                                
                                //appDelegate.setXmppConnect()
                            }
                        }
                        else
                        {
                            self.loginBtn.returnToOriginalState()
                            self.loginBtn.setOriginalState()
                            self.theme.AlertView("\(appNameJJ)",Message:self.theme.CheckNullValue(responseObject.object(forKey: "response")),ButtonTitle: kOk)
                        }
                    }
                    else
                    {
                          self.loginBtn.returnToOriginalState()
                        self.loginBtn.setOriginalState()
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                    }
                }
            }
        }
    }
    
    @IBAction func didClickforgot(_ sender: Any) {
        let forgotVC = self.storyboard!.instantiateViewController(withIdentifier: "ForgotPasswordViewControllerID") as! ForgotPasswordViewController
        self.navigationController!.pushViewController(withFade: forgotVC, animated: false)
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
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    if(status == "1")
                    {
                        let resDict: NSDictionary = responseObject.object(forKey: "response") as! NSDictionary
                        let tasker_status : String = self.theme.CheckNullValue(resDict.object(forKey: "tasker_status"))
                        
                        
                        if (tasker_status == "1")
                        {
                            self.view.makeToast(message:"Your availability is ON", duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                            
                           
                            // self.avialabilitybtn.setTitle("GO OFFLINE", forState:.Normal)
                            self.theme.saveAvailable_satus("GO OFFLINE")
                            
                            
                        }
                        else
                        {
                            self.view.makeToast(message:"Your availability is OFF", duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                            
                            //  self.avialabilitybtn.setTitle("GO ONLINE", forState:.Normal)
                            self.theme.saveAvailable_satus("GO ONLINE")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }

        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
       // var contentInset:UIEdgeInsets = loginScrollView.contentInset
        //contentInset.bottom = keyboardFrame.size.height+100
        //loginScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
//        
//        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
//        loginScrollView.contentInset = contentInset
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(range.location==0 && string==""){
            return true
            
        }
        return true
    }
    
   
    
    func validateTxtFields () -> Bool
    {
        var isOK:Bool=true
      if(userNameTxtField.text!.count==0){
        
        theme.AlertView("\(appNameJJ)",Message: Language_handler.VJLocalizedString("enter_email_alert", comment: nil),ButtonTitle: kOk)
        

            isOK=false
        }
        else if(passwordTxtField.text!.count==0){
        theme.AlertView("\(appNameJJ)",Message: Language_handler.VJLocalizedString("enter_password_alert", comment: nil),ButtonTitle: kOk)

        isOK=false
        }
            
        
        return isOK
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIButton
{
     func SpringButton(){
        self.transform = CGAffineTransform(scaleX: 0, y: 0);
        UIView.animate(withDuration: 1.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations:{
            self.transform = CGAffineTransform(scaleX: 1, y: 1);
        }) { (finished) in
            print("animation completed")
        }
    }
}
extension UIImageView {
    func changeImageColor( color:UIColor) -> UIImage
    {
        image = image!.withRenderingMode(.alwaysTemplate)
        tintColor = color
        return image!
    }
}
