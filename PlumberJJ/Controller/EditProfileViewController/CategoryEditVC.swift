//
//  CategoryEditVC.swift
//  PlumberJJ
//
//  Created by Casperon on 19/05/17.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class CategoryEditVC: RootBaseViewController,ListPickerDelegate {
    @IBOutlet weak var parent_cat: UILabel!
    @IBOutlet weak var cat_name: UILabel!
    @IBOutlet weak var exe_lev: UILabel!
    @IBOutlet var category_scroll: UIScrollView!
    @IBOutlet var expLevel_Btn: UIButton!
    @IBOutlet var hourly_Txt: UITextField!
    @IBOutlet var subCat_Btn: UIButton!
    @IBOutlet var mainCat_Btn: UIButton!
    @IBOutlet var addCatgry_Btn: UIButton!
    @IBOutlet var title_Lbl: UILabel!
    
    @IBOutlet weak var MainCatView: UIView!
    @IBOutlet weak var SubCatView: UIView!
    @IBOutlet weak var RateView: UIView!
    @IBOutlet weak var ExperienceView: UIView!
    @IBOutlet var ViewsArr: [UIView]!
    @IBOutlet var DownArrowImgArr: [UIImageView]!
    
    @IBOutlet weak var SubmitView: UIView!
    
    @IBOutlet var hourlyRate_Lbl: UILabel!
   
    var dropDown :  NIDropDown = NIDropDown()
    var category_Array : NSMutableArray = NSMutableArray()
    var category_IdArray: NSMutableArray = NSMutableArray()
    var experience_Array:NSMutableArray = NSMutableArray()
    var experienceID_Array:NSMutableArray = NSMutableArray()
    var subCategory_Array : NSMutableArray = NSMutableArray()
    var subCategory_IdArray : NSMutableArray = NSMutableArray()
    var checkCategory:String = String()
     var selectedCat_ID :String = String()
    var selectSubCat_ID:String = String()
    var selectExp_ID:String = String()
    var drop_Selection:String = String()
    var min_Rate:Int = Int()
    var rate_Type:String = String()
    var editCatDtl_Array:NSMutableArray = NSMutableArray()
    var listisDisplayed:Bool = false
    
    private var isAnyfieldEdited = true{
        didSet{
            self.SubmitView.isHidden = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.theme.addGradient(self.SubmitView, colo1: lightorangecolor, colo2: darkorangecolor, direction: .LefttoRight, Frame: CGRect(x: 0, y: 0, width: self.SubmitView.frame.width, height: self.SubmitView.frame.height), CornerRadius: true, Radius: self.SubmitView.frame.height/2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUI_Alignments()
        if checkCategory ==  "Edit Category"{
            setEditCat_Details()
        }
        else{
            setAddCatTxtAlign()
        }
    }
    
    func setUI_Alignments(){
        hourly_Txt.delegate = self
        hourly_Txt.layer.cornerRadius = hourly_Txt.frame.height/2
        hourly_Txt.addSubview(self.theme.SetPaddingViewwithText(hourly_Txt))
        mainCat_Btn.layer.cornerRadius = mainCat_Btn.frame.height/2
        subCat_Btn.layer.cornerRadius = subCat_Btn.frame.height/2
        expLevel_Btn.layer.cornerRadius = expLevel_Btn.frame.height/2
        mainCat_Btn.setTitle(theme.setLang("Select_Category"), for: .normal)
        subCat_Btn.setTitle(theme.setLang("Select_Sub_Category"), for: .normal)
        expLevel_Btn.setTitle(theme.setLang("Select_Level"), for: .normal)
    }
    
    func setAddCatTxtAlign(){
        addCatgry_Btn.setTitle(Language_handler.VJLocalizedString("submit", comment: nil), for: UIControl.State())
        mainCat_Btn.isUserInteractionEnabled = true
        subCat_Btn.isUserInteractionEnabled = true
        self.ViewsArr.forEach{($0.isHidden = true)}
        self.DownArrowImgArr.forEach{($0.isHidden = false)}
        //  title_Lbl.text = "Add Category"
        //     quickPinch_TxtView.text = Language_handler.VJLocalizedString("pinch_manditory", comment: nil)
        //        quickPinch_TxtView.textColor = UIColor.lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.category_scroll.isHidden = true
          if  checkCategory ==  "Edit Category"{
        title_Lbl.text =  theme.setLang("edit_category")
        }
          else{
             title_Lbl.text =  theme.setLang("add_category")
        }
        
        self.SubmitView.isHidden = true
        self.addCatgry_Btn.layer.cornerRadius = self.addCatgry_Btn.frame.height/2
        parent_cat.text=theme.setLang("Main_Category")
        cat_name.text = theme.setLang("Sub_Category")
        exe_lev.text = theme.setLang("Experience_level")
        hourlyRate_Lbl.text = theme.setLang("Hourly_Rate")
        
        self.Done_Toolbar()
        self.GetCategoryList()
        // Do any additional setup after loading the view.
    }
    
    func getSelected_ListValue(value: String, index: Int) {
        if drop_Selection == "Main Category"{
            mainCat_Btn.setTitle(value, for: .normal)
            subCat_Btn.setTitle(theme.setLang("Select_Sub_Category"), for: .normal)
            expLevel_Btn.setTitle(theme.setLang("Select_Level"), for: .normal)
            self.RateView.isHidden = true
            self.ExperienceView.isHidden = true
            self.SubmitView.isHidden = true
            selectedCat_ID = category_IdArray.object(at: index) as! String
            subCat_API(selectedCat_ID)
            self.SubCatView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.SubCatView.layoutIfNeeded()
            })
        }else if drop_Selection == "Sub Category"{
            subCat_Btn.setTitle(value, for: .normal)
            selectSubCat_ID = subCategory_IdArray.object(at: index) as! String
            expLevel_Btn.setTitle(theme.setLang("Select_Level"), for: .normal)
            self.RateView.isHidden = true
            getSubcategory_Dtls(selectSubCat_ID)
            self.RateView.isHidden = false
            self.ExperienceView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.RateView.layoutIfNeeded()
                self.ExperienceView.layoutIfNeeded()
            })
        }else if drop_Selection == "Experience Category"{
            if checkCategory ==  "Edit Category"{
                isAnyfieldEdited = true
            }
            expLevel_Btn.setTitle(value, for: .normal)
            selectExp_ID = experienceID_Array.object(at: index) as! String
            self.SubmitView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.SubmitView.layoutIfNeeded()
            })
        }
    }
    
    func Done_Toolbar()
    {
        //ADD Done button for Contatct Field
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.backgroundColor=UIColor.white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: theme.setLang("done"), style: UIBarButtonItem.Style.done, target: self, action: #selector(CategoryEditVC.doneButtonAction))
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        hourly_Txt.inputAccessoryView = doneToolbar
        
    }
    
    
    @objc func doneButtonAction()
    {
        hourly_Txt.resignFirstResponder()
    }
    
    func GetCategoryList(){
        let parameters:Dictionary=["":""]
        url_handler.makeCall(get_mainCategory , param: parameters as NSDictionary) {
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
                        self.category_scroll.isHidden = false
                        let responseObject = responseObject!
                    let Dict:NSDictionary=responseObject
                   
                    
                        let Status=self.theme.CheckNullValue(Dict.object(forKey: "status") as AnyObject) as NSString
                    if Status == "1"
                         {
                            self.category_Array.removeAllObjects()
                            self.category_IdArray.removeAllObjects()
                            self.experience_Array.removeAllObjects()
                            self.experienceID_Array.removeAllObjects()
                            
                        let ResponseArr = responseObject.object(forKey: "response")as! NSArray
                        let experience_Arr = responseObject.object(forKey: "experiencelist")as! NSArray
                        for experience in experience_Arr{
                            
                            let exp_ID  = self.theme.CheckNullValue((experience as AnyObject).object(forKey: "id") as AnyObject)
                            
                        let exp_Lvl = self.theme.CheckNullValue((experience as AnyObject).object(forKey: "name") as AnyObject)
                            
                            self.experience_Array.add(exp_Lvl)
                            self.experienceID_Array.add(exp_ID)
                            
//                        self.experience_Array.addObject(CategoryExperience.init(experience_Lvl: exp_Lvl!, experience_ID: exp_ID!))
                        }
                           
                             for (_, element) in ResponseArr.enumerated() {
                                let category = self.theme.CheckNullValue((element as AnyObject).object(forKey: "name") as AnyObject)
                                let category_id = self.theme.CheckNullValue((element as AnyObject).object(forKey: "id") as AnyObject)
                                self.category_Array.add(category)
                                self.category_IdArray.add(category_id)
                                
                            }
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
            
        }
    }


   // pragma mark - MKDropdownMenuDataSource
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didclick_BtnAction(_ sender: AnyObject) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
    @IBAction func categoryBtn_Act(_ sender: AnyObject) {

        drop_Selection = "Main Category"
        if category_Array.count>0
        {
            ListPicker.sharedInstance.show(self, list: category_Array as! [String], header: theme.setLang("Main_Category"))
        }
        else{
            self.view.makeToast(message: "There are no main category to show", duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
        }
    }

    func getSubcategory_Dtls(_ subCat_ID:String){
        let _:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["subcategory_id":"\(subCat_ID)"]
        url_handler.makeCall(getSubCategory_Dtl, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                    
                    if(status == "1")
                    {
                        let response = responseObject.object(forKey: "response") as! NSArray
                        if  response.count>0{
                            for responseDtl in response{
                                self.rate_Type = self.theme.CheckNullValue((responseDtl as AnyObject).object(forKey: "ratetype") as AnyObject)
                                let getMin_Rate =  self.theme.CheckNullValue((responseDtl as AnyObject).object(forKey: "minrate") as AnyObject)
                                self.min_Rate = Int(getMin_Rate)!
                                
                                if self.rate_Type == "Flat"
                                {
                                    self.hourlyRate_Lbl.text = self.theme.setLang("fixed_rate")
                                    self.hourly_Txt.text = ""
                                    self.hourly_Txt.text = "\(self.min_Rate)"
                                    self.hourly_Txt.isUserInteractionEnabled = false
                                    self.hourly_Txt.placeholder = self.theme.setLang("Enter_fixed_Rate")
                                }
                                else
                                {
                                    self.hourly_Txt.isUserInteractionEnabled = true
                                    self.hourlyRate_Lbl.text = "Hourly rate (Min rate \(self.theme.getappCurrencycode())\(self.min_Rate))"
                                    self.hourly_Txt.text = ""
                                    self.hourly_Txt.placeholder = self.theme.setLang("Enter_Hourly_Rate")
                                }
                        }
               }
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
                    }
                }
            }
        }
    }

    func subCat_API(_ selectedCat_ID:String){
        
        let parameters:Dictionary=["category_id":"\(selectedCat_ID)"]
        
        // print(Param)
        
        url_handler.makeCall(Get_SubCategory , param: parameters as NSDictionary) {
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
                        let responseObject = responseObject!
                    let Dict:NSDictionary=responseObject
                    
                    
                        let Status=self.theme.CheckNullValue(Dict.object(forKey: "status") as AnyObject) as NSString
                    if Status == "1"
                    {
                        self.subCategory_Array.removeAllObjects()
                        self.subCategory_IdArray.removeAllObjects()
                        let ResponseArr = responseObject.object(forKey: "response")as! NSArray
                        
                        for (_, element) in ResponseArr.enumerated() {
                            
                            let category = self.theme.CheckNullValue((element as AnyObject).object(forKey: "name") as AnyObject)
                            let category_id = self.theme.CheckNullValue((element as AnyObject).object(forKey: "id") as AnyObject)
                            self.subCategory_Array.add(category)
                            self.subCategory_IdArray.add(category_id)
                        }
                        
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    
                }
            }
            
        }

        
    }
    @IBAction func subCategoryBtn_Act(_ sender: AnyObject) {

        drop_Selection = "Sub Category"
        if subCategory_Array.count>0
        {
//            if listisDisplayed == false
//            {
//                selectCat_tbl.isHidden = false
//                selectCat_tbl.reload()
//
//                selectCat_tbl.frame = CGRect(x: self.subCat_Btn.frame.origin.x,y: self.subCat_Btn.frame.origin.y+self.subCat_Btn.frame.size.height+3, width: self.subCat_Btn.frame.size.width, height: self.subCat_Btn.frame.maxY)
//                let tableViewCellHeight = 44
//                selectCat_tbl.frame.size.height = CGFloat(subCategory_Array.count*tableViewCellHeight)
//                if selectCat_tbl.frame.size.height > 250{
//                    selectCat_tbl.frame.size.height = 250
//                }
//                listisDisplayed=true
//            }
//            else
//            {
//                selectCat_tbl.isHidden = true
//                listisDisplayed=false
//            }
       ListPicker.sharedInstance.show(self, list: subCategory_Array as! [String], header: theme.setLang("Sub_Category"))
        }
        else
        {
            self.view.makeToast(message: "There are no subcategory to show", duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
        }
    }
    
    @IBAction func expLevel_Action(_ sender: UIButton) {
        
        drop_Selection = "Experience Category"
        if experience_Array.count>0
        {
            ListPicker.sharedInstance.show(self, list: experience_Array as! [String], header: theme.setLang("Sub_Category"))
        }
    }
    
    
    @IBAction func addCatgry_Action(_ sender: UIButton) {
        
        let rate = Int(hourly_Txt.text!)
        if mainCat_Btn.titleLabel!.text! == "Select Category"{
            
            self.theme.AlertView("\(appNameJJ)", Message:theme.setLang("Please select main category"), ButtonTitle: kOk)
        }
        else if subCat_Btn.titleLabel!.text! == "Select Sub Category"{
            self.theme.AlertView("\(appNameJJ)", Message:theme.setLang("Please select sub category"), ButtonTitle: kOk)
        }
//        else if quickPinch_TxtView.text == "" ||  quickPinch_TxtView.text == Language_handler.VJLocalizedString("pinch_manditory", comment: nil){
//            self.theme.AlertView("\(appNameJJ)", Message:theme.setLang("Quick Pinch field was empty"), ButtonTitle: kOk)
//
//        }
        else if hourly_Txt.text == ""  {
            if self.rate_Type == "Flat"
            {
           self.theme.AlertView("\(appNameJJ)", Message:theme.setLang("Fixed Rate is required"), ButtonTitle: kOk)
            }
            else
            {
                 self.theme.AlertView("\(appNameJJ)", Message:theme.setLang("Hourly Rate is required"), ButtonTitle: kOk)
            }
        }
        else if rate!<min_Rate{
            if self.rate_Type == "Flat"
            {
                   self.theme.AlertView("\(appNameJJ)", Message:"\(theme.setLang("Minimum rate is")) \(min_Rate)", ButtonTitle: kOk)
            }
            else
            {
                self.theme.AlertView("\(appNameJJ)", Message:"\(theme.setLang("Minimum hourly rate is")) \(min_Rate)", ButtonTitle: kOk)
            }
            
           
        }
        else if expLevel_Btn.titleLabel!.text! == "Select Level"{
               self.theme.AlertView("\(appNameJJ)", Message:theme.setLang("Kindly Select your Experience Level."), ButtonTitle: kOk)
        }
        else{
       // let parameters:Dictionary=["category_id":"\(selectedCat_ID)"]
         let objUserRecs:UserInfoRecord=theme.GetUserDetails()
         let parameters:Dictionary=["tasker":"\(objUserRecs.providerId)","childid":"\(selectSubCat_ID)","parentcategory":"\(selectedCat_ID)","hourrate":"\(hourly_Txt.text!)","experience":"\(selectExp_ID)"]
       
        // print(Param)
         var url:String = String()
         if  checkCategory ==  "Edit Category"{
            url =  update_Category
            }
         else{
             url =  add_Category
            }
            url_handler.makeCall(url , param: parameters as NSDictionary) {
            (responseObject, error) -> () in
            self.DismissProgress()
            
            if(error != nil)
            {
                self.theme.AlertView("\(appNameJJ)"  , Message:HRToastPositionDefault, ButtonTitle: kOk)
            }
            else
            {
                 if(responseObject != nil)
                    {
                        let responseObject = responseObject!
                    let Dict:NSDictionary=responseObject
                    
                    
                        let Status=self.theme.CheckNullValue(Dict.object(forKey: "status") as AnyObject) as NSString
                    if Status == "1"
                    {
                        let getResponse = responseObject.object(forKey: "response") as! String
                        self.theme.AlertView("\(appNameJJ)", Message:getResponse, ButtonTitle: kOk)
                       
                        self.navigationController?.popViewControllerwithFade(animated: false)
                    }
                    else{
                        let getResponse = responseObject.object(forKey: "response") as! String
                        self.theme.AlertView("\(appNameJJ)", Message:getResponse, ButtonTitle: kOk)
                    }
                }
                else
                {
                    self.theme.AlertView("\(appNameJJ)", Message:kErrorMsg, ButtonTitle: kOk)
                }
            }
            
        }
        }
        
    }
    
    func setEditCat_Details(){
        mainCat_Btn.isUserInteractionEnabled = false
        subCat_Btn.isUserInteractionEnabled = false
        self.DownArrowImgArr.forEach{($0.isHidden = true)}
        addCatgry_Btn.setTitle("\(Language_handler.VJLocalizedString("update", comment: nil))", for: UIControl.State())
        let getCurrentEdit_Dtl = editCatDtl_Array[0] as! EditCategoryDetails
        mainCat_Btn.setTitle(getCurrentEdit_Dtl.mainCat_Name, for: UIControl.State())
        subCat_Btn.setTitle(getCurrentEdit_Dtl.subCat_Name, for: UIControl.State())
//        quickPinch_TxtView.text = getCurrentEdit_Dtl.quickPinch
        min_Rate = Int(getCurrentEdit_Dtl.min_Rate)!
        self.rate_Type = getCurrentEdit_Dtl.rate_Type
        if getCurrentEdit_Dtl.rate_Type == "Flat"
        {
//            self.hourlyRate_Lbl.text = "Fixed rate (Min rate \(theme.getappCurrencycode())\(self.min_Rate))"
            self.hourlyRate_Lbl.text = self.theme.setLang("fixed_rate")
            self.hourly_Txt.text = "\(min_Rate)"
            self.hourly_Txt.isUserInteractionEnabled = false
        }
        else
        {
            self.hourlyRate_Lbl.text = "Hourly rate (Min rate \(theme.getappCurrencycode())\(self.min_Rate))"
            self.hourly_Txt.isUserInteractionEnabled = true
        }
        hourly_Txt.placeholder = "Fixed Rate"
        hourly_Txt.text = getCurrentEdit_Dtl.hour_Rate
        expLevel_Btn.setTitle(getCurrentEdit_Dtl.expereince_Name, for: UIControl.State())
        selectExp_ID = getCurrentEdit_Dtl.experience_ID
        selectSubCat_ID = getCurrentEdit_Dtl.subCat_ID
        selectedCat_ID = getCurrentEdit_Dtl.mainCat_ID
    }
}

extension CategoryEditVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if checkCategory ==  "Edit Category"{
        isAnyfieldEdited = true
        }
    }
}
