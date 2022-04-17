//
//  ForgotPasswordViewController.swift
//  Plumbal
//
//  Created by Casperon Tech on 15/10/15.
//  Copyright © 2015 Casperon Tech. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: RootBaseViewController {

    @IBOutlet var send_Btn: UIButton!
    @IBOutlet var EmailID_TextField: UITextField!
    @IBOutlet var Header_lbl: UILabel!
    @IBOutlet var email_img: UIImageView!
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    
    @IBOutlet var ForgotPass_desc: UILabel!
    @IBOutlet var Tellus: UILabel!
    @IBOutlet var ForgotPas_Lbl: UILabel!
    @IBOutlet var Wrapper_View: UIView!

    @IBOutlet var Close_bt: UIButton!
    let themes:Theme=Theme()
    var URL_handler:URLhandler=URLhandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        email_img.image = email_img.changeImageColor(color: PlumberThemeColor)
        //Header_lbl.text="\(Appname)"
        Wrapper_View.layer.borderWidth=1.0
        Wrapper_View.layer.borderColor=UIColor.lightGray.cgColor
        Wrapper_View.layer.cornerRadius=3.0

        EmailID_TextField.placeholder="Phone or Email"
        
      //  EmailID_TextField.layer.borderColor=themes.Lightgray().cgColor
        EmailID_TextField.placeholder=Language_handler.VJLocalizedString("email_address", comment: nil)
        send_Btn.setTitle(Language_handler.VJLocalizedString("reset_password", comment: nil), for: UIControl.State())
        ForgotPas_Lbl.text = Language_handler.VJLocalizedString("forgot_password", comment: nil)
        ForgotPass_desc.text = Language_handler.VJLocalizedString("reset_instruct", comment: nil)
        ForgotPas_Lbl.adjustsFontSizeToFitWidth = true
        
        //Delegate method
        EmailID_TextField.delegate=self
       // EmailID_TextField.layer.cornerRadius=20
        EmailID_TextField.layer.borderWidth=1
        EmailID_TextField.layer.borderColor=UIColor.white.cgColor
        EmailID_TextField.layer.masksToBounds=true
      //  EmailID_TextField.textAlignment = .Center
        
        send_Btn.layer.cornerRadius=20
        send_Btn.layer.masksToBounds=true

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.theme.yesTheDeviceisHavingNotch()
        {
            HeaderViewHeight.constant=100
        }
    }
    
     override func applicationLanguageChangeNotification(_ notification: Notification) {
        EmailID_TextField.placeholder=Language_handler.VJLocalizedString("email_address", comment: nil)
        send_Btn.setTitle(Language_handler.VJLocalizedString("reset_password", comment: nil), for: UIControl.State())
        ForgotPas_Lbl.text = Language_handler.VJLocalizedString("forgot_password", comment: nil)
        ForgotPass_desc.text = Language_handler.VJLocalizedString("reset_instruct", comment: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if(textField == EmailID_TextField)
        {
            
            EmailID_TextField.resignFirstResponder()
         }
        
        
        return true
        
    }
    
    
   

     @IBAction func didClickoption(_ sender: UIButton) {
        
        
        if(sender.tag == 10)
        {
            self.navigationController?.popViewControllerWithFlip(animated: true)
        }
        
        if(sender.tag == 1)
        {
            
            
            if(EmailID_TextField.text == "")
            {
                self.themes.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enter_email_alert", comment: nil), ButtonTitle: kOk)
                            }
//            if(theme.isValidEmail(EmailID_TextField.text!))
//            {
//                 self.themes.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("valid_email_alert", comment: nil) , ButtonTitle: kOk)
//              
//            }
            else
            {
                self.send_Btn.isEnabled=false

                self.showProgress()
                
                let parameter=["email":"\(EmailID_TextField.text!)"]

                URL_handler.makeCall(ForgotpasswdUrl, param: parameter as NSDictionary, completionHandler: { (responseObject, error) -> () in
                    self.send_Btn.isEnabled=true

                    if(error != nil)
                    {
                        self.view.makeToast(message:"", duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                    }
                        
                    else
                    {
                        
                        if(responseObject != nil)
                        {
                    
                            
                            let dict:NSDictionary=responseObject!
                            let response:NSString=dict.object(forKey: "response") as! NSString
                            if(response == "Reset Code Sent Successfully!")
                            {
                           
                            self.DismissProgress()
                                
                                self.themes.AlertView("\(appNameJJ)", Message:response as String as String, ButtonTitle: kOk)
                                
                                _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ForgotPasswordViewController.update), userInfo: nil, repeats: false)
                                
                            }
                            else
                            {
                                
                                self.themes.AlertView("\(appNameJJ)", Message:response as String as String, ButtonTitle: kOk)
                           
                                    self.DismissProgress()

                            }
                            
                        }
                        else
                        {
                            self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                                self.DismissProgress()

                        
                        }

                    }
                
                })
            }
        }
    }
    
    
    @objc func update() {
        
          self.navigationController?.popViewControllerWithFlip(animated: true)
        
//        var appDelegate = (UIApplication.sharedApplication().delegate! as! AppDelegate)
//        var loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InitialVCSID")
//        //or the homeController
//        var navController = UINavigationController(rootViewController: loginController)
//        appDelegate.window!.rootViewController = navController
//        loginController.navigationController!.setNavigationBarHidden(true, animated: true)
        

    }
}


extension ForgotPasswordViewController:UITextFieldDelegate
{
    
}
