//
//  BankingInfoViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 10/30/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class BankingInfoViewController: RootBaseViewController, UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var topView: SetColorView!
    @IBOutlet weak var bankingScrollView: UIScrollView!
    @IBOutlet weak var routingTxtField: UITextField!
    @IBOutlet weak var AccHolderNameTxtField: UITextField!
    @IBOutlet weak var Container_View: UIView!
    @IBOutlet weak var AccHolderTxtView: UITextView!
    @IBOutlet weak var AccNumberTxtField: UITextField!
    @IBOutlet weak var BankNameTxtField: UITextField!
    @IBOutlet weak var BranchNameTxtField: UITextField!
    @IBOutlet weak var BranchAddressTxtView: UITextView!
    @IBOutlet weak var SwiftCodeTxtField: UITextField!
    @IBOutlet weak var lblHolderName: SMIconLabel!
    @IBOutlet weak var lblHolderAdd: SMIconLabel!
    @IBOutlet weak var lblHolderNum: SMIconLabel!
    @IBOutlet weak var lblBranchName: SMIconLabel!
    @IBOutlet weak var lblBankName: SMIconLabel!
    @IBOutlet weak var lblBranchAdd: SMIconLabel!
    @IBOutlet weak var lblIfcCode: SMIconLabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleHeader: UILabel!
    
    @IBOutlet weak var routingLbl: UILabel!
    

    
   // var theme:Theme=Theme()
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //  self.Container_View.SpringAnimations()

        
        lblHolderName.text = Language_handler.VJLocalizedString("account_holder_name", comment: nil)
        lblHolderAdd.text = Language_handler.VJLocalizedString("account_holder_address", comment: nil)
        lblHolderNum.text = Language_handler.VJLocalizedString("account_number", comment: nil)
        lblBranchName.text = Language_handler.VJLocalizedString("bank_name", comment: nil)
        lblBankName.text = Language_handler.VJLocalizedString("branch_name", comment: nil)
        lblBranchAdd.text = Language_handler.VJLocalizedString("branch_address", comment: nil)
        lblIfcCode.text = Language_handler.VJLocalizedString("ifsc_code", comment: nil)
        routingLbl.text = Language_handler.VJLocalizedString("routing_number", comment: nil)
        titleHeader.text = Language_handler.VJLocalizedString("banking_details", comment: nil)
        saveButton.setTitle(Language_handler.VJLocalizedString("save", comment: nil), for: UIControl.State())
        setViewForBanking()
        GetDatasForBanking()
        barButton.addTarget(self, action: #selector(BankingInfoViewController.openmenu), for: .touchUpInside)
       
        // Do any additional setup after loading the view.
    
    }
    
    func labelAnimation(array:NSArray){
        
    }
    
   @objc func openmenu(){
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        // Present the view controller
        //
        self.frostedViewController.presentMenuViewController()
    }
    func setViewForBanking(){
        if (self.navigationController!.viewControllers.count != 1) {
            backBtn.isHidden=false;
            barButton.isHidden=true
        }else{
         
        }
       
        AccHolderTxtView.layer.borderWidth=1;
        AccHolderTxtView.layer.borderColor=PlumberLightGrayColor.cgColor;
        BranchAddressTxtView.layer.borderWidth=1;
        BranchAddressTxtView.layer.borderColor=PlumberLightGrayColor.cgColor;
        bankingScrollView.contentSize=CGSize(width: bankingScrollView.frame.size.width, height: routingTxtField.frame.maxY+20);
        setMandatoryFields()
    }
    func GetDatasForBanking(){
        showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)"]
        
        url_handler.makeCall(GetBankingDetails ,param: Param as NSDictionary) {
            (responseObject, error) -> () in
            self.DismissProgress()
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil)
              {
                    self.setDatasToBankingView(responseObject!)
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
        }
    }
    @IBAction func didClickSaveBtn(_ sender: AnyObject) {
        if(validateTxtFields()){
            showProgress()
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                "acc_holder_name":"\(AccHolderNameTxtField.text!)",
                "acc_holder_address":"\(AccHolderTxtView.text!)",
                "acc_number":"\(AccNumberTxtField.text!)",
                "bank_name":"\(BankNameTxtField.text!)",
                "branch_name":"\(BranchNameTxtField.text!)",
                "branch_address":"\(BranchAddressTxtView.text!)",
                "swift_code":"\(SwiftCodeTxtField.text!)",
                "routing_number":"\(routingTxtField.text!)"]
            
            url_handler.makeCall(SaveBankingDetails , param: Param as NSDictionary) {
                (responseObject, error) -> () in
                self.DismissProgress()
                if(error != nil)
                {
                    print("error responded with: \(String(describing: error))")
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
                else
                {
                     if(responseObject != nil)
                    {
                        let responseObject = responseObject!
                        
                      
                        let resDict: NSDictionary = responseObject.object(forKey: "response") as! NSDictionary
                        self.view.makeToast(message:self.theme.CheckNullValue(resDict.object(forKey: "message") as AnyObject), duration: 5, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")

                        self.setDatasToBankingView(responseObject)
                        
                                                                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
            }
        }
        
        
        
    }
    func setDatasToBankingView(_ Dict:NSDictionary){
    
        let status=self.theme.CheckNullValue(Dict.value(forKey:"status") as AnyObject) as NSString
        
        if(status == "1")
        {
             let resDict: NSDictionary = (Dict.object(forKey: "response") as AnyObject).object(forKey: "banking") as! NSDictionary
            AccHolderNameTxtField.text=theme.CheckNullValue((resDict.object( forKey: "acc_holder_name" )as! NSString) as String as String as AnyObject)
            AccHolderTxtView.text=theme.CheckNullValue((resDict.object( forKey: "acc_holder_address" ) as! NSString) as String as String as AnyObject)
            AccNumberTxtField.text=theme.CheckNullValue((resDict.object( forKey: "acc_number" ) as! NSString) as String as String as AnyObject)
            BankNameTxtField.text=theme.CheckNullValue((resDict.object( forKey: "bank_name" ) as! NSString) as String as String as AnyObject)
            BranchNameTxtField.text=theme.CheckNullValue((resDict.object( forKey: "branch_name" ) as! NSString) as String as String as AnyObject)
            BranchAddressTxtView.text=theme.CheckNullValue((resDict.object( forKey: "branch_address" ) as! NSString) as String as String as AnyObject)
            SwiftCodeTxtField.text=theme.CheckNullValue((resDict.object( forKey: "swift_code" ) as! NSString) as String as String as AnyObject)
            routingTxtField.text=theme.CheckNullValue((resDict.object( forKey: "routing_number" )as! NSString) as String as String as AnyObject)
                   }
        else
        {
           self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
        }
    }

    @IBAction func didClickBackBtn(_ sender: UIButton) {
//        self.navigationController?.popViewControllerWithFlip(animated: true)
    }
  

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setMandatoryFields(){
        for subView:UIView in bankingScrollView.subviews{
            if(subView.isKind(of: SMIconLabel.self)){
                 let lbl: SMIconLabel = (subView as? SMIconLabel)!
                if !lbl.isEqual(routingLbl) {
                    lbl.icon = UIImage(named: "MandatoryImg")
                    lbl.iconPadding = 5
                    lbl.iconPosition = SMIconLabelPosition.right
                }
            }else if(subView.isKind(of: UITextField.self)){
                let txtField: UITextField = (subView as? UITextField)!
                let arrow: UIView = UILabel()
                arrow.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                txtField.leftView = arrow
                txtField.leftViewMode = UITextField.ViewMode.always
            }
        }
    }

    func validateTxtFields () -> Bool{
        var isOK:Bool=true
        if(AccHolderNameTxtField.text!.count==0){
            ValidationAlert(Language_handler.VJLocalizedString("holder_name_mand", comment: nil))
            isOK=false
        }else if(AccHolderTxtView.text.count==0){
            ValidationAlert(Language_handler.VJLocalizedString("address_mand", comment: nil))
            isOK=false
        }
        else if(AccNumberTxtField.text!.count==0){
            ValidationAlert(Language_handler.VJLocalizedString("account_number_mand", comment: nil))
            isOK=false
        }
            
        else if(BankNameTxtField.text!.count==0){
            ValidationAlert(Language_handler.VJLocalizedString("bank_name_mand", comment: nil))
            isOK=false
        }
            
        else if(BranchNameTxtField.text!.count==0){
            ValidationAlert(Language_handler.VJLocalizedString("branch_name_mand", comment: nil))
            isOK=false
        }
            
        else if(BranchAddressTxtView.text!.count==0){
            ValidationAlert(Language_handler.VJLocalizedString("branch_address_mand", comment: nil))
            isOK=false
        }
        else if(SwiftCodeTxtField.text!.count==0){
            ValidationAlert(Language_handler.VJLocalizedString("ifsc_code_mand", comment: nil))
            isOK=false
        } 
        return isOK
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(range.location==0 && string==" "){
            return false
        }
        
        if string == "."{
            return false
        }
        return true
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
