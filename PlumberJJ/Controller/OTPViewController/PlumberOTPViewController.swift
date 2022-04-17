//
//  PlumberOTPViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 12/11/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit



class PlumberOTPViewController: RootBaseViewController,UITextFieldDelegate {
    //var theme:Theme=Theme()
    @IBOutlet weak var otpDiscLbl: UILabel!
    @IBOutlet weak var titleHeader: UILabel!
    var otpStr:String = ""
    var currencyStr:String = ""
    var priceStr:String = ""
    var jobIDStr:String = ""
    @IBOutlet weak var btnSubmit: ButtonColorView!

    @IBOutlet weak var otpTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTxtField.layer.cornerRadius=5
        otpTxtField.layer.borderWidth=0.75
        otpTxtField.layer.borderColor=PlumberLightGrayColor.cgColor
        otpTxtField.layer.masksToBounds=true
        otpTxtField.textAlignment = .center
        
        
        otpDiscLbl.text = Language_handler.VJLocalizedString("otp_disc", comment: nil)
        titleHeader.text = Language_handler.VJLocalizedString("one_time_pwd", comment: nil);
        otpTxtField.placeholder = Language_handler.VJLocalizedString("otp_placeholder", comment: nil);
        btnSubmit.setTitle(Language_handler.VJLocalizedString("submit", comment: nil), for: UIControl.State())

        GetOTPDetails()
        // Do any additional setup after loading the view.
    }
    
    func GetOTPDetails(){
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
            "job_id":"\(jobIDStr)"]
        print(Param)
        self.showProgress()
        url_handler.makeCall(RequestCashUrl, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status:NSString = self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                    if(status == "1")
                    {
                        self.otpStr=self.theme.CheckNullValue((responseObject.object(forKey: "response") as AnyObject).object(forKey: "otp_string") as AnyObject)
                        self.currencyStr=self.theme.getCurrencyCode(((responseObject.object(forKey: "response") as AnyObject).object(forKey: "currency") as AnyObject) as! String)
                        let prStr=self.theme.CheckNullValue((responseObject.object(forKey: "response") as AnyObject).object(forKey: "receive_amount") as AnyObject)
                        self.priceStr="\(self.currencyStr)\(prStr)"
                        
                        if(self.theme.CheckNullValue((responseObject.object(forKey: "response") as AnyObject).object(forKey: "otp_status") as AnyObject)=="development"){
                            self.otpTxtField.text="\(self.otpStr)";
                    self.otpTxtField.isUserInteractionEnabled = false
                        }
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
            
        }
    }
    
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: MyOrderOpenDetailViewController.self) {
//                self.navigationController?.popToViewController(controller as UIViewController, animated: true)
//                break
//            }
//        }
        

      self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didClickSubmitBtn(_ sender: AnyObject) {
        self.view.endEditing(true)
        if(otpStr as String == otpTxtField.text!){
            let objReceiveCashvc = self.storyboard!.instantiateViewController(withIdentifier: "ReceiveCashVCSID") as! ReceiveCashViewController
            objReceiveCashvc.otpStr = self.otpStr
            objReceiveCashvc.priceString=priceStr
            objReceiveCashvc.jobIDStr=jobIDStr
            self.navigationController!.pushViewController(withFade: objReceiveCashvc, animated: false)
        }else{
            ValidationAlert(Language_handler.VJLocalizedString("otp_alert", comment: nil))

        }
    }
    func ValidationAlert(_ alertMsg:String){
        let popup = NotificationAlertView.popupWithText("\(alertMsg)")
        popup.hideAfterDelay = 3
        //popup.position = NotificationAlertViewPosition.Bottom
        popup.animationDuration = 1
        popup.show()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
