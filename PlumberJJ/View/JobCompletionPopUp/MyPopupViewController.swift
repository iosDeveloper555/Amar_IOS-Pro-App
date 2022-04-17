//
//  MyPopupViewController.swift
//  SLPopupViewControllerDemo
//
//  Created by Nguyen Duc Hoang on 9/13/15.
//  Copyright © 2015 Nguyen Duc Hoang. All rights reserved.
//

import UIKit

protocol MyPopupViewControllerDelegate {
 
    func submitJob(_ sender: MyPopupViewController, withDesc:NSString , withCost:NSString)
    func pressCancel(_ sender: MyPopupViewController)
}
class MyPopupViewController: RootBaseViewController,UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet weak var job_cost: CustomLabel!
    @IBOutlet weak var job_summary: CustomLabel!
    var delegate:MyPopupViewControllerDelegate?
    
 
    @IBOutlet weak var jobDescTxtView: UITextView!
    @IBOutlet weak var amountTxtField: UITextField!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    
    @IBAction func btnCancel(_ sender:UIButton) {
        self.delegate?.pressCancel(self)
    }
    @IBAction func didClickSubmitBtn(_ sender: AnyObject) {
        if(jobDescTxtView.text==""){
            ValidationAlert(Language_handler.VJLocalizedString("job_summary_alert", comment: nil))
        }else if(amountTxtField.text==""){
            ValidationAlert(Language_handler.VJLocalizedString("job_cost_alert", comment: nil))
        }else{
            self.delegate?.submitJob(self, withDesc: jobDescTxtView.text as! NSString, withCost: amountTxtField.text! as NSString)
        }
        
    }
        override func viewDidLoad() {
        super.viewDidLoad()
            job_summary.text = theme.setLang("job_sum")
            job_cost.text = theme.setLang("job_cos")
        self.view.layer.cornerRadius = 22
        self.view.layer.masksToBounds = true
            
           submitBtn.layer.cornerRadius = 4
            submitBtn.layer.borderWidth=1
            submitBtn.layer.borderColor=PlumberThemeColor.cgColor
            submitBtn.layer.masksToBounds = true
            
            jobDescTxtView.layer.cornerRadius = 4
            jobDescTxtView.layer.masksToBounds = true
            jobDescTxtView.layer.borderWidth=0.5
            jobDescTxtView.layer.borderColor=UIColor.lightGray.cgColor
            
            
            amountTxtField.layer.cornerRadius = 4
            amountTxtField.layer.masksToBounds = true
            amountTxtField.layer.borderWidth=0.5
            amountTxtField.layer.borderColor=UIColor.lightGray.cgColor
            
            
            
            
            
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func ValidationAlert(_ alertMsg:String){
        let popup = NotificationAlertView.popupWithText("\(alertMsg)")
        popup.hideAfterDelay = 3
        //popup.position = NotificationAlertViewPosition.Bottom
        popup.animationDuration = 1
        popup.show()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.frame=CGRect(x: self.view.frame.origin.x, y: 30, width: self.view.frame.size.width, height: self.view.frame.size.height);
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
         self.view.frame=CGRect(x: self.view.frame.origin.x, y: -50, width: self.view.frame.size.width, height: self.view.frame.size.height);
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(range.location==0 && string==" "){
            return false
        }
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 8 // Bool
       
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(range.location==0 && text==" "){
            return false
        }
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
