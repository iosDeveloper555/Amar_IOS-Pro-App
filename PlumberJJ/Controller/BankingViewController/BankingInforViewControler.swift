//
//  BankingInforViewControler
//  PlumberJJ
//
//  Created by Casperon on 24/01/18.
//  Copyright © 2018 Casperon Technologies. All rights reserved.
//

import UIKit

class BankingInforViewControler: RootBaseViewController, UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var topView: SetColorView!
    @IBOutlet weak var bankingScrollView: UIScrollView!
    @IBOutlet weak var routingTxtField: UITextField!
    @IBOutlet weak var AccHolderNameTxtField: UITextField!
    @IBOutlet weak var AccNumberTxtField: UITextField!
    @IBOutlet weak var BankNameTxtField: UITextField!
    @IBOutlet weak var SwiftCodeTxtField: UITextField!
    @IBOutlet weak var lblHolderName: SMIconLabel!
    @IBOutlet weak var lblHolderNum: SMIconLabel!
    @IBOutlet weak var lblBankName: SMIconLabel!
    @IBOutlet weak var lblIfcCode: SMIconLabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleHeader: UILabel!
    
    @IBOutlet weak var SaveView: UIView!
    @IBOutlet weak var AccNameView: UIView!
    @IBOutlet weak var AccNumberView: UIView!
    @IBOutlet weak var BankNameView: UIView!
    @IBOutlet weak var SwiftorIFSCView: UIView!
    @IBOutlet weak var Routingview: UIView!
    @IBOutlet var TxtFldArray: [UITextField]!
    @IBOutlet weak var routingLbl: UILabel!
    // var theme:Theme=Theme()
    
    

    
    @IBOutlet weak var ssnTextFiled: UITextField!
    @IBOutlet weak var aptTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var stateTextFiled: UITextField!
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var referralTextField: UITextField!
    

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        self.SaveView.layer.cornerRadius = self.SaveView.frame.height/2
        self.theme.addGradient(self.SaveView, colo1: lightorangecolor, colo2: darkorangecolor, direction: .LefttoRight, Frame: CGRect(x: 0, y: 0, width: self.SaveView.frame.width, height: self.SaveView.frame.height), CornerRadius: true, Radius: self.SaveView.frame.height/2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.bankingScrollView.SpringAnimations()
       //self.bankingScrollView.contentSize = CGSize(width : self.view.frame.size.width,height: self.saveButton.frame.maxY+40)
        self.bankingScrollView.isScrollEnabled = true
        lblHolderName.text = Language_handler.VJLocalizedString("account_holder_name", comment: nil)
        lblHolderNum.text = Language_handler.VJLocalizedString("account_number", comment: nil)
        lblBankName.text = Language_handler.VJLocalizedString("bank_name", comment: nil)
        lblIfcCode.text = Language_handler.VJLocalizedString("ifsc_code", comment: nil)
        routingLbl.text = Language_handler.VJLocalizedString("routing_number", comment: nil)
        titleHeader.text = Language_handler.VJLocalizedString("banking_details", comment: nil)
        saveButton.setTitle(Language_handler.VJLocalizedString("save", comment: nil), for: UIControl.State())
        setViewForBanking()
        GetDatasForBanking()
        barButton.addTarget(self, action: #selector(BankingInforViewControler.openmenu), for: .touchUpInside)
        
        // Do @objc @objc @objc @objc any additional setup after loading the view.
        for TxtFld in TxtFldArray{
            TxtFld.layer.cornerRadius = TxtFld.frame.height/2
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: TxtFld.frame.height))
            TxtFld.leftView = paddingView
            TxtFld.leftViewMode = UITextField.ViewMode.always
        }
        self.SwiftorIFSCView.isHidden = true
    }
    
    func labelAnimation(array:NSArray){
        
    }
    
   @objc func openmenu(){
//        self.view.endEditing(true)
//        self.frostedViewController.view.endEditing(true)
//        // Present the view controller
//        //
//        self.frostedViewController.presentMenuViewController()
    self.findHamburguerViewController()?.showMenuViewController()
    }
    func setViewForBanking(){
        if (self.navigationController!.viewControllers.count != 1) {
            backBtn.isHidden=false;
            barButton.isHidden=true
        }else{
            
        }
        
        bankingScrollView.contentSize=CGSize(width: bankingScrollView.frame.size.width, height: routingTxtField.frame.maxY+20);
        setMandatoryFields()
    }
    func GetDatasForBanking(){
        self.showProgress()
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
    
    //MARK: - Amarendra changes
    
    
    @IBAction func didClickSaveBtn(_ sender: AnyObject) {
        if(validateTxtFields()){
        
        if (ssnTextFiled.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterSSN", comment: nil), ButtonTitle: kOk)
            return
        } else if (aptTextField.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterATP", comment: nil), ButtonTitle: kOk)
            return
        } else if (cityTextField.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterCity", comment: nil), ButtonTitle: kOk)
            return
        } else if (stateTextFiled.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterState", comment: nil), ButtonTitle: kOk)
            return
        } else if (zipCodeTextField.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterZip", comment: nil), ButtonTitle: kOk)
            return
        } else if (addressTextField.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterAddress", comment: nil), ButtonTitle: kOk)
            return
        }
        else{
            
            
            //MARK: - 1 st api
            
            self.showProgress()
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                "acc_holder_name":"\(AccHolderNameTxtField.text!)",
                "acc_number":"\(AccNumberTxtField.text!)",
                "bank_name":"\(BankNameTxtField.text!)",
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
            
            
            
            
            //MARK: - 2 nd api
            
            let objUserRecs2:UserInfoRecord=theme.GetUserDetails()
            
            
           
            self.showProgress()
            
            
            let address = Address(apt: aptTextField.text!, city: cityTextField.text!, state: stateTextFiled.text!, zipcode: zipCodeTextField.text!, line1: addressTextField.text!)
            
            let obj = UpdateSSN(ssn: ssnTextFiled.text!, address: address, providerID: objUserRecs2.providerId)
            
            let jsonEncoder = JSONEncoder()
            var jsonData = try! jsonEncoder.encode(obj)
            
//            let params = ["ssn":"\(ssnTextFiled.text!)",
//                         "address[apt]":"\(aptTextField.text!)",
//                         "address[city]":cityTextField.text!,
//                         "address[state]":stateTextFiled.text!,
//                         "address[zipcode]":zipCodeTextField.text!,
//                         "address[line1]":addressTextField.text!,
//                        "provider_id"  :objUserRecs.providerId
//            ]
//
//            let params = ["ssn":"\(ssnTextFiled.text!)",
//                         "apt":"\(aptTextField.text!)",
//                         "city":cityTextField.text!,
//                         "state":stateTextFiled.text!,
//                         "zipcode":zipCodeTextField.text!,
//                         "line1":addressTextField.text!,
//                        "provider_id"  :objUserRecs.providerId
//            ]
            
            
            url_handler.makePostCall(updatePersonalInformation , jsonData: jsonData) {
                (responseObject, error) -> ()  in
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
                        
                        
                        let a = responseObject["response"]
                        
//                        let resDict: NSDictionary = responseObject.object(forKey: "response") as? String
                        self.view.makeToast(message:self.theme.CheckNullValue(a), duration: 5, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                        
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
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
            AccHolderNameTxtField.text=theme.CheckNullValue(resDict.object( forKey: "acc_holder_name" ))
            AccNumberTxtField.text=theme.CheckNullValue(resDict.object( forKey: "acc_number" ))
            BankNameTxtField.text=theme.CheckNullValue(resDict.object( forKey: "bank_name" ))
            SwiftCodeTxtField.text=theme.CheckNullValue(resDict.object( forKey: "swift_code" ))
            routingTxtField.text=theme.CheckNullValue(resDict.object( forKey: "routing_number" ))
        }
        else
        {
            self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
        }
    }
    
    @IBAction func didClickBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewControllerwithFade(animated: false)
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
        }else if(AccNumberTxtField.text!.count==0){
            ValidationAlert(Language_handler.VJLocalizedString("account_number_mand", comment: nil))
            isOK=false
        }
        else if(BankNameTxtField.text!.count==0){
            ValidationAlert(Language_handler.VJLocalizedString("bank_name_mand", comment: nil))
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
        popup.hideAfterDelay = 2
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

