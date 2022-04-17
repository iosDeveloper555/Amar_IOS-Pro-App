//
//  ChangePasswordViewController.swift
//  Plumbal
//
//  Created by Casperon Tech on 12/10/15.
//  Copyright © 2015 Casperon Tech. All rights reserved.
//

import UIKit

class ChangePasswordViewController: RootBaseViewController {
    
    @IBOutlet weak var pass1_img: UIImageView!
    @IBOutlet weak var pass2_img: UIImageView!
    @IBOutlet weak var pass3_img: UIImageView!
    @IBOutlet var Done_Btn: UIButton!
    @IBOutlet var Change_Pass_ScrollView: UIScrollView!
        @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var old_TextField: UITextField!
    @IBOutlet var Wrapper_View: UIView!

    @IBOutlet var New_TextField: UITextField!
    @IBOutlet var Confirm_textField: UITextField!
    
    @IBOutlet var Back_But: UIButton!
    
    
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
//        self.navigationController?.popViewControllerWithFlip(animated: true)
    }

    
    let themes:Theme=Theme()
    
    var URL_handler:URLhandler=URLhandler()
    override func viewDidLoad() {
        
        self.pass1_img.image = self.pass1_img.changeImageColor(color: PlumberThemeColor)
        self.pass2_img.image = self.pass2_img.changeImageColor(color: PlumberThemeColor)
        self.pass3_img.image = self.pass3_img.changeImageColor(color: PlumberThemeColor)
        
        Wrapper_View.layer.borderWidth=1.0
        Wrapper_View.layer.borderColor=UIColor.lightGray.cgColor
        Wrapper_View.layer.cornerRadius=3.0

        titleHeader.text = Language_handler.VJLocalizedString("change_password", comment: nil)
        Done_Btn.setTitle(Language_handler.VJLocalizedString("done", comment: nil), for: UIControl.State())
        old_TextField.placeholder = Language_handler.VJLocalizedString("old_password", comment: nil)
        New_TextField.placeholder = Language_handler.VJLocalizedString("new_password", comment: nil)
        Confirm_textField.placeholder = Language_handler.VJLocalizedString("confirm_password", comment: nil)
        if (self.navigationController!.viewControllers.count != 1) {
            menuButton.isHidden=true
        }else{
        }
        
        menuButton.addTarget(self, action: #selector(ChangePasswordViewController.openmenu), for: .touchUpInside)
        
        super.viewDidLoad()
        
old_TextField.delegate=self
Confirm_textField.delegate=self
New_TextField.delegate=self
        
        let tapgesture:UITapGestureRecognizer=UITapGestureRecognizer(target:self, action: #selector(ChangePasswordViewController.DismissKeyboard(_:)))
        
        view.addGestureRecognizer(tapgesture)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func openmenu(){
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        // Present the view controller
        //
        self.frostedViewController.presentMenuViewController()
    }

    
    @objc func DismissKeyboard(_ sender:UITapGestureRecognizer)
    {
        Change_Pass_ScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickoptions(_ sender: AnyObject) {
        
        if(sender.tag == 0)
        {
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }
        if(sender.tag == 1)
        {
            
            if(old_TextField.text == "")
            {
                self.view.makeToast(message:Language_handler.VJLocalizedString("old_password_empty", comment: nil), duration: 3, position: HRToastPositionCenter as AnyObject, title: appNameJJ)
            }
            else if(New_TextField.text == "")
            {
                self.view.makeToast(message:Language_handler.VJLocalizedString("new_password_empty", comment: nil), duration: 3, position: HRToastPositionCenter as AnyObject, title: appNameJJ)
            }
            else if (Confirm_textField.text == "")
            {
                self.view.makeToast(message:Language_handler.VJLocalizedString("confirm_password_empty", comment: nil), duration: 3, position: HRToastPositionCenter as AnyObject, title: appNameJJ)
                
            }
                
            else if(New_TextField.text != Confirm_textField.text)
            {
                self.view.makeToast(message:Language_handler.VJLocalizedString("password_unmatch", comment: nil), duration: 3, position: HRToastPositionCenter as AnyObject, title: appNameJJ)
                
            }
            else
                
            {
                self.ChangePassword()
            }
            
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func ChangePassword()
    {
      
        self.showProgress()
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        
        let providerid = objUserRecs.providerId

        let param=["provider_id":"\(providerid)","password":"\(old_TextField.text!)","new_password":"\(New_TextField.text!)"]
        
        URL_handler.makeCall(ChangepasswdUrl, param: param as NSDictionary, completionHandler: { (responseObject, error) -> () in
            self.Done_Btn.isEnabled=true
            self.DismissProgress()
            
            
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionCenter as AnyObject, title: appNameJJ)
            }
                
            else
            {
                
                
                
                 if(responseObject != nil)
                    {
                        let responseObject = responseObject!
                    let dict:NSDictionary=responseObject
                    
                        let responsemsg : NSString = self.theme.CheckNullValue(dict.object(forKey: "response") as AnyObject) as NSString
                        let status : NSString = self.theme.CheckNullValue(dict.object(forKey: "status") as AnyObject) as NSString
                   
                    
                    if(status == "1")
                    {
                        
                        
                        self.view.makeToast(message:responsemsg as String, duration: 3, position: HRToastPositionCenter as AnyObject, title: "Hurray")
                        
                        
//                        let objChatVc = self.storyboard!.instantiateViewControllerWithIdentifier("ChatVCSID") as! MessageViewController
//                        objChatVc.jobId=chatlist.chatJobId
//                        self.navigationController!.pushViewController(withFade: objChatVc, animated: false)

            let loginController = self.storyboard!.instantiateViewController(withIdentifier: "LoginVCSID") as! LoginViewController
                      
                        
  self.navigationController!.pushViewController(withFade: loginController, animated: false)
                        self.old_TextField.text = ""
                        self.New_TextField.text = ""
                        self.Confirm_textField.text = ""
                        
                       
                        
                        
                    }
                    else
                    {
                        self.view.makeToast(message:responsemsg as String, duration: 3, position: HRToastPositionCenter as AnyObject, title: appNameJJ)
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionCenter as AnyObject, title: appNameJJ)
                    
                }
                
            }
            
            
            
        })
        
        
    }


}


extension ChangePasswordViewController:UINavigationControllerDelegate
{
    
}
extension ChangePasswordViewController:UITextFieldDelegate
{
    
}
