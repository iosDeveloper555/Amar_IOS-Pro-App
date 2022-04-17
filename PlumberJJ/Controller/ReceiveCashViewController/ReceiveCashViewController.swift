//
//  ReceiveCashViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 12/11/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit



class ReceiveCashViewController: RootBaseViewController {
  //  var theme:Theme=Theme()
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var btnCashReceived: ButtonColorView!
    @IBOutlet weak var collectDisc: UILabel!

    var otpStr:String = ""
    var jobIDStr:String = ""
    
    var priceString:String = ""
    @IBOutlet weak var priceLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleHeader.text = Language_handler.VJLocalizedString("receive_cash", comment: nil)
        btnCashReceived.setTitle(Language_handler.VJLocalizedString("cash_received", comment: nil), for: UIControl.State())
        collectDisc.text = Language_handler.VJLocalizedString("collect_cash", comment: nil)
        
        priceLbl.text=priceString
        // Do any additional setup after loading the view.
    }
    @IBAction func didClickCashReceivedBtn(_ sender: AnyObject) {
        ReceiveCash()
    }
    func ReceiveCash(){
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                                 "job_id":"\(jobIDStr)" ,"otp" :"\(otpStr)"]
        
        self.showProgress()
        url_handler.makeCall(CashReceivedUrl, param: Param as NSDictionary) {
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
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject)
                    if(status == "1")
                    {
                       /* let objRatingsvc = self.storyboard!.instantiateViewControllerWithIdentifier("RatingsVCSID") as! RatingsViewController
//                        objReceiveCashvc.priceString=priceStr
                        objRatingsvc.jobIDStr=self.jobIDStr
                        self.navigationController!.pushViewController(withFade: objRatingsvc, animated: false)*/
                      
                    }
                    else
                    {
                        self.view.makeToast(message:responseObject.object(forKey: "response") as! NSString as String, duration: 5, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
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
        var isOK:Bool=false
       
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MyOrderOpenDetailViewController.self) {
                self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                 isOK=true
                break
            }
        }
        if(isOK==false){
            self.navigationController?.popViewControllerwithFade(animated: false)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
