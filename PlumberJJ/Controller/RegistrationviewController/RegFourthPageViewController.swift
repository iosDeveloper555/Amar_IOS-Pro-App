//
//  RegFourthPageViewController.swift
//  PlumberJJ
//
//  Created by Gurulakshmi's Mac Mini on 30/07/18.
//  Copyright © 2018 Casperon Technologies. All rights reserved.
//

import UIKit
import DropDown
class CategoryRecord: NSObject
{
    var name : String = ""
    var id : String = ""
    var image : String = ""
}
class subCategoryRecord: NSObject
{
    var name : String = ""
    var id : String = ""
    var image : String = ""
}

class AddCategoryModel: NSObject
{
    var parentid : String = ""
    var childid : String = ""
    var experienceid : String = ""
    var hourlyrate : String = ""
    var quickpitch :String = ""
    var subcatname : String = ""
    var maincatname : String = ""
    var experiencelev:String = ""
}

class ObjCatArray: NSObject {
    static let Sharedinstance = ObjCatArray()
    var CategoryMainObj = [AddCategoryModel]()
    var CAtRec = CategoryRecord()
}

extension UITextField
{
    func borderTextfield()
    {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
}
class RegFourthPageViewController: RootBaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,PassTheSelectedDatadelegate{
    
    
    
    
    @IBOutlet weak var categoryTbl: UITableView!
    @IBOutlet weak var submitBtn: TKTransitionSubmitButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var editsaveBtn: UIButton!
    @IBOutlet weak var experienceValid: CustomvalidLabel!
    @IBOutlet weak var maincatBtn: UIButton!
    @IBOutlet weak var titelLbl: CustomLabelHeader!
    @IBOutlet weak var editexptblheight: NSLayoutConstraint!
    @IBOutlet weak var editquickvalid: CustomvalidLabel!
    @IBOutlet weak var editquicktext: UITextView!
    @IBOutlet weak var editquicktextLbl: CustomLabel!
    @IBOutlet weak var editexpValid: CustomvalidLabel!
    @IBOutlet weak var editexpeTbl: UITableView!
    @IBOutlet weak var editepeBtn: UIButton!
    @IBOutlet weak var editexpeLbl: CustomLabel!
    @IBOutlet weak var edithourlyrateValid: CustomvalidLabel!
    @IBOutlet weak var edithourlyRate: CustomTextField!
    @IBOutlet weak var edithourlyrateLbl: CustomLabel!
    @IBOutlet weak var editsubcatBtn: UIButton!
    @IBOutlet weak var editsubcatLbl: CustomLabel!
    @IBOutlet weak var editmaincatLbl: CustomLabel!
    @IBOutlet weak var editmaincatBtn: UIButton!
    @IBOutlet weak var editStackview: UIStackView!
    @IBOutlet weak var editTitle: CustomLabelLarge!
    @IBOutlet weak var editscrollview: UIScrollView!
    @IBOutlet weak var quickValid: CustomvalidLabel!
    @IBOutlet weak var quickTxt: UITextView!
    @IBOutlet weak var experienceBtn: UIButton!
    @IBOutlet weak var experienceLbl: CustomLabel!
    @IBOutlet weak var quickpintchLbl: CustomLabel!
    @IBOutlet weak var hourlyValid: CustomvalidLabel!
    @IBOutlet weak var hourlyTxt: UITextField!
    @IBOutlet weak var hourlyLbl: CustomLabel!
    @IBOutlet weak var subcatBtn: UIButton!
    @IBOutlet weak var addtionalBtn: UIButton!
    @IBOutlet weak var subcatLbl: CustomLabel!
    @IBOutlet weak var maincatLbl: CustomLabel!
    @IBOutlet weak var catDescLabl: CustomLabelLightGray!
    @IBOutlet weak var experiencetbl: UITableView!
    @IBOutlet weak var quickPitchView: UIView!
    @IBOutlet weak var subCatView: UIView!
    @IBOutlet weak var mainCatView: UIView!
    @IBOutlet weak var HrRateLblHeight: NSLayoutConstraint!
    @IBOutlet weak var HourlyTxtHeight: NSLayoutConstraint!
    @IBOutlet weak var subCatHeight: NSLayoutConstraint!
    @IBOutlet weak var hourlyvalidHeight: NSLayoutConstraint!
    @IBOutlet weak var expvalidHeight: NSLayoutConstraint!
    @IBOutlet weak var quickvalidHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryHeight: NSLayoutConstraint!
    @IBOutlet var categoryView: UIView!
    @IBOutlet weak var catSearchTbl: UITableView!
    @IBOutlet weak var categoryTxt: UITextField!
    @IBOutlet weak var categorysearch: UIImageView!
    @IBOutlet weak var BackButtonView: UIView!
    
    let experienceDropDown = DropDown()
    var EditexperienceDropDown = DropDown()
    
    
    @IBOutlet weak var searchcatTbl: NSLayoutConstraint!
    var CatleadingConstraint : NSLayoutConstraint!
    var iscatSelect :Bool?
    var CategoryArr = [CategoryRecord]()
    var CategorySearchArr = [CategoryRecord]()
    var SubcategorArr = [subCategoryRecord]()
    var ExperienceArr = [CategoryRecord]()
    var experiencenameArray = [String]()
    var savecategoryarr = [AddCategoryModel]()
    var select_Cat : CategoryRecord?
    var select_SubCat : subCategoryRecord?
    var min_Rate: Int = 0
    var AvailableArray = [AvailableRec]()
    //MARK: -  New changes
    
    var subCatId = "5d3069abf7fdfb13e0045679"

    var TableViewArray = [documentList]()
    @IBOutlet weak var CheckBoxButton: UIButton!
    @IBOutlet weak var Contractor_agreement_lbl: UITextView!
    @IBOutlet weak var viewAgrrement: UIView!
 var isBackgroundEnable = false
    var paymet_url = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewAgrrement.isHidden=true
        self.CheckBoxButton.tintColor = PlumberThemeColor
        self.CheckBoxButton.setImage(UIImage(named: "Unchecked_Checkbox"), for: .normal)
        Contractor_agreement_lbl.font = PlumberMediumBoldFont
        let MaintremsString : String = self.theme.setLang("pay_and_user")
        Contractor_agreement_lbl.text = MaintremsString
        let checkImage = UIImage(named: "Checked_Checkbox")
        self.CheckBoxButton.setImage(checkImage, for: UIControl.State())

        self.theme.getAppinformation()
        
        let appearance = DropDown.appearance()
//        BackButtonView.SetBackButtonShadow()
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        addtionalBtn.layer.cornerRadius = 5.0
        titelLbl.text = theme.setLang("Add_Category")
        editTitle.text = theme.setLang("edit_category")
        editscrollview.isHidden = true
        editmaincatLbl.text = theme.setLang("Main_Catcaps")
        editmaincatBtn.setTitle(theme.setLang("Main_Category"), for: .normal)
        editsubcatLbl.text = theme.setLang("sub_Catcaps")
        editsubcatBtn.setTitle(theme.setLang("Sub_Category"), for: .normal)
        edithourlyrateLbl.text = theme.setLang("hourlyCaps")
        editepeBtn.setTitle("experience", for: .normal)
        editexpeLbl.text = theme.setLang("levelExpe")
        editquicktextLbl.text = theme.setLang("quickCaps")
        editsaveBtn.setTitle(theme.setLang("save"), for: .normal)
        editsaveBtn.layer.cornerRadius = 5.0
        editsaveBtn.layer.masksToBounds = true
        self.submitBtn.setTitle(theme.setLang("Continue"), for: .normal)
        self.submitBtn.isHidden = true 
        catDescLabl.text = theme.setLang("select_category")
        maincatLbl.text = theme.setLang("Main_Catcaps")
        maincatBtn.setTitle(theme.setLang("Select_Category"), for: .normal)
        subcatLbl.text = theme.setLang("sub_Catcaps")
        subcatBtn.setTitle(theme.setLang("Select_Sub_Category"), for: .normal)
        hourlyLbl.text = theme.setLang("hourlyCaps")
        hourlyValid.text = theme.setLang("Minimun hourly rate is")
        experienceValid.text = "experience is required"
        quickValid.text = "quick pitch  is required"
        experienceBtn.setTitle(theme.setLang("Select_Level"), for: .normal)
        experienceLbl.text = theme.setLang("levelExpe")
        quickpintchLbl.text = theme.setLang("quickCaps")
        saveBtn.setTitle(theme.setLang("save"), for: .normal)
        closeBtn.setTitle(theme.setLang("cancel"), for: .normal)

        self.maincatBtn.layer.cornerRadius = self.maincatBtn.frame.height/2
        self.subcatBtn.layer.cornerRadius = self.subcatBtn.frame.height/2
        self.hourlyTxt.layer.cornerRadius = self.hourlyTxt.frame.height/2
        self.experienceBtn.layer.cornerRadius = self.experienceBtn.frame.height/2
        self.saveBtn.layer.cornerRadius = self.saveBtn.frame.height/2
        self.closeBtn.layer.cornerRadius = self.closeBtn.frame.height/2
        self.closeBtn.layer.borderWidth = 1.0
        self.closeBtn.layer.borderColor = UIColor.black.cgColor
        self.saveBtn.backgroundColor = PlumberThemeColor
        self.saveBtn.setTitleColor(.white, for: .normal)
        
        self.experiencetbl.delegate = self
        self.experiencetbl.dataSource = self
        self.categoryTbl.delegate = self
        self.categoryTbl.dataSource = self
        self.categoryTbl.register(UINib(nibName:"AddCategoryTableViewCell", bundle: nil), forCellReuseIdentifier:"addcell")
        self.experiencetbl.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
        self.experiencetbl.tableFooterView = UIView()
        addtionalBtn.isHidden = false
        
        self.editexpeTbl.delegate = self
        self.editexpeTbl.dataSource = self
        self.editexptblheight.constant = 0
        
        
        self.editexpeTbl.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
        self.editexpeTbl.tableFooterView = UIView()
        self.categoryHeight.constant = 0
        if ObjCatArray.Sharedinstance.CategoryMainObj.count > 0 {
            self.hideallviews()
            self.categoryTbl.isHidden = false
            self.categoryTbl.reloadData()
            maincatBtn.setTitle(theme.setLang("Select_Category"), for: .normal)
            subcatBtn.setTitle(theme.setLang("Select_Sub_Category"), for: .normal)
            categoryHeight.constant = self.categoryTbl.contentSize.height+20
            self.categoryTbl.layoutIfNeeded()
            self.view.layoutIfNeeded()
            self.submitBtn.isHidden = false
        }else{
            self.hideallviews()
        }
        self.GetCategoryList()
        self.GetexperienceList()
        self.makedesign(sender:self.quickTxt)
        self.makedesign(sender:self.editquicktext)
        self.makedesign(sender:self.experiencetbl)
        self.makedesign(sender:self.editexpeTbl)
        
        self.edithourlyRate.borderTextfield()
        
        let tapgesture = UITapGestureRecognizer.init(target:self, action:#selector(tapcatview(sender:)))
        tapgesture.delegate = self
        self.categoryView.addGestureRecognizer(tapgesture)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.theme.DismissProgress()

    }
    
    @IBAction func didclickcheckboxbtn(_ sender: UIButton) {
        let checkImage = UIImage(named: "Checked_Checkbox")
        let uncheck_Image = UIImage(named: "Unchecked_Checkbox")
        if CheckBoxButton.imageView?.image == UIImage(named:"Checked_Checkbox")
        {
            CheckBoxButton.setImage(uncheck_Image, for: UIControl.State())
        }
        else
        {
            
            CheckBoxButton.setImage(checkImage, for: UIControl.State())
        }
    }
    
    func makedesign (sender:UIView)
    {
        sender.layer.borderWidth = 1.0
        sender.layer.borderColor = UIColor.lightGray.cgColor
        sender.layer.cornerRadius = 5
        sender.layer.masksToBounds = true
    }
    func hideeditvalid()
    {
        self.edithourlyrateValid.isHidden = true
        self.editexpValid.isHidden = true
        //        self.editquickvalid.isHidden = true
    }
    
    @IBAction func addBtnAct(_ sender: Any) {
        self.mainCatView.isHidden = false
        if self.submitBtn.isHidden == false{
            self.submitBtn.isHidden = true
        }
    }
    
    func hideallviews()
    {
        self.mainCatView.isHidden = true
        self.subCatHeight.constant = 0
        self.subCatView.isHidden = true
        self.quickPitchView.isHidden = true
        self.categoryTbl.isHidden = true
        self.experiencetbl.isHidden = true
        self.hourlyTxt.text = ""
        experienceBtn.setTitle(theme.setLang("Select_Level"), for: .normal)
        self.quickTxt.text = ""
    }
    
    @objc func tapcatview(sender:UITapGestureRecognizer)
    {
        self.categoryView.backgroundColor = UIColor.clear
        UIView.animate(withDuration:0.5) {
            self.CatleadingConstraint.constant = self.view.frame.size.width
            self.categoryView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.submitBtn.applyGradientwithcorner()
        self.view.addSubview(self.categoryView)
        self.catSearchTbl.delegate = self
        self.catSearchTbl.dataSource = self
        self.catSearchTbl.estimatedRowHeight = 150
        self.catSearchTbl.rowHeight = UITableView.automaticDimension
        self.catSearchTbl.register(UINib(nibName:"CategorySearchTableViewCell" , bundle: nil), forCellReuseIdentifier: "catcell")
        self.categoryTxt.delegate = self
//        self.categoryTxt.addTarget(self, action:#selector(searchaction(sender:)) , for:.editingChanged)
        
        self.categoryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item:self.categoryView! , attribute: .top, relatedBy:.equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        CatleadingConstraint =  NSLayoutConstraint(item:self.categoryView! , attribute: .left, relatedBy:.equal, toItem: view, attribute: .left, multiplier: 1, constant: self.view.frame.size.width)
        CatleadingConstraint.isActive = true
        NSLayoutConstraint(item:self.categoryView! , attribute: .bottom, relatedBy:.equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:self.categoryView! , attribute: .width, relatedBy:.equal, toItem:nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.size.width).isActive = true
        NSLayoutConstraint(item:self.categoryView! , attribute: .height, relatedBy:.equal, toItem:nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.size.height).isActive = true
    }
    
//    @objc func searchaction(sender:UITextField)
//    {
//        if !((sender.text?.isEmpty)!)
//        {
//            if  iscatSelect!
//            {
//                let arr = self.SubcategorySearchArr.filter {
//                    $0.name.range(of: sender.text!, options: .caseInsensitive) != nil
//                }
//                self.CategoryArr.removeAll()
//                self.CategoryArr = arr
//            }else
//            {
//                let arr = self.CategorySearchArr.filter {
//                    $0.name.range(of: sender.text!, options: .caseInsensitive) != nil
//                }
//                self.CategoryArr.removeAll()
//                self.CategoryArr = arr
//            }
//        }
//        else
//        {
//            self.CategoryArr.removeAll()
//            if  iscatSelect!
//            {
//                self.CategoryArr = self.SubcategorySearchArr
//            }
//            else{
//                self.CategoryArr = self.CategorySearchArr
//            }
//        }
//        self.catSearchTbl.reloadData()
//    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if categoryView.bounds.contains(touch.location(in: self.catSearchTbl)) {
            return false
        }
        return true
    }
    
    func GetCategoryList(){
        let parameters:Dictionary=["":""]
        
        // print(Param)
        self.showProgress()
        url_handler.makeCall(GetCategories , param: parameters as NSDictionary) {
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
                        let CategoryArray:NSArray=(responseObject.object(forKey: "response")! as AnyObject).object(forKey: "category") as! NSArray
                        for Dictionary in CategoryArray{
                            print(Dictionary)
                            let catmodel = CategoryRecord()
                            catmodel.name = self.theme.CheckNullValue((Dictionary as AnyObject).object(forKey: "cat_name"))
                            catmodel.id = self.theme.CheckNullValue((Dictionary as AnyObject).object(forKey: "cat_id"))
                            catmodel.image = self.theme.CheckNullValue((Dictionary as AnyObject).object(forKey: "active_icon"))
                            self.CategoryArr.append(catmodel)
                            self.CategorySearchArr.append(catmodel)
                        }
                        self.catSearchTbl.reloadData()
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
        }
    }
    
    func GetexperienceList(){
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
                    let responseObject = responseObject!
                    let Dict:NSDictionary=responseObject
                    self.ExperienceArr.removeAll()
                    self.experiencenameArray.removeAll()
                    let Status=self.theme.CheckNullValue(Dict.object(forKey: "status") as AnyObject) as NSString
                    if Status == "1"
                    {
                        let experience_Arr = responseObject.object(forKey: "experiencelist")as! NSArray
                        for experience in experience_Arr{
                            let catmodel = CategoryRecord()
                            catmodel.name = self.theme.CheckNullValue((experience as AnyObject).object(forKey: "name"))
                            catmodel.id = self.theme.CheckNullValue((experience as AnyObject).object(forKey: "id"))
                            self.ExperienceArr.append(catmodel)
                            self.experiencenameArray.append(self.theme.CheckNullValue((experience as AnyObject).object(forKey: "name")))
                        }
                        self.experiencetbl.reloadData()
                        self.setupDropDown()
                        self.setupeditDropDown()
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
        }
    }
    
    func GetSubCategoryList(){
        let parameters:Dictionary=["category":select_Cat?.id]
        self.showProgress()
        url_handler.makeCall(GetCategories , param: parameters as NSDictionary) {
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
                        let CategoryArray:NSArray=(responseObject.object(forKey: "response")! as AnyObject).object(forKey: "category") as! NSArray
                       // self.CategoryArr.removeAll()
                      self.SubcategorArr.removeAll()
                        for Dictionary in CategoryArray{
                            let catmodel = subCategoryRecord()
                            catmodel.name = self.theme.CheckNullValue((Dictionary as AnyObject).object(forKey: "cat_name"))
                            catmodel.id = self.theme.CheckNullValue((Dictionary as AnyObject).object(forKey: "cat_id"))
                            catmodel.image = self.theme.CheckNullValue((Dictionary as AnyObject).object(forKey: "active_icon"))
                           // self.CategoryArr.append(catmodel)
                           
                             self.SubcategorArr.append(catmodel)
//                           self.SubcategorySearchArr.append(catmodel)
                        }
                        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CatSubCatVCID") as?  CatSubCatViewController{
                            if let navigator = self.navigationController
                            {
                                let backItem = UIBarButtonItem()
                                backItem.title = ""
                                self.navigationItem.backBarButtonItem = backItem
                                viewController.isfromMainCat = false
                                viewController.SubCategoryArry = self.SubcategorArr
                                viewController.Delegate = self
                                navigator.pushViewController(withFade: viewController, animated: false)
                            }
                        }
                        self.catSearchTbl.reloadData()
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.experiencetbl || tableView ==  self.editexpeTbl
        {
            return self.ExperienceArr.count
        }
        else if tableView == self.categoryTbl
        {
//            return self.savecategoryarr.count
            return ObjCatArray.Sharedinstance.CategoryMainObj.count
        }
        else
        {
            return self.CategoryArr.count
        }
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        if tableView ==  experiencetbl
    //        {
    //        return 35
    //        }
    //        else
    //        {
    //            return UITableViewAutomaticDimension
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.experiencetbl || tableView ==  self.editexpeTbl
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath)
            cell.selectionStyle = .none
            let expModel = ExperienceArr[indexPath.row]
            cell.textLabel?.text = expModel.name
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = UIColor.black
            
            return cell
        }
        else if tableView == self.categoryTbl
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"addcell", for: indexPath) as! AddCategoryTableViewCell
            cell.borderView.layer.cornerRadius = 7
            cell.layer.masksToBounds = true
//            let savedata = savecategoryarr[indexPath.row]
            let CatArr = ObjCatArray.Sharedinstance.CategoryMainObj[indexPath.row]
            cell.categoryLbl.text = CatArr.subcatname
            cell.editBtn.tag = indexPath.row
            cell.deleteBtn.tag = indexPath.row
            cell.editBtn.addTarget(self, action: #selector(editCtegoryData(sender:)), for: .touchUpInside)
            cell.deleteBtn.addTarget(self, action: #selector(deleteCtegoryData(sender:)), for: .touchUpInside)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"catcell", for: indexPath) as! CategorySearchTableViewCell
            let catrec = self.CategoryArr[indexPath.row]
            cell.catimage.backgroundColor = PlumberThemeColor
            cell.catimage.layer.cornerRadius = cell.catimage.frame.height/2
            cell.catimage.layer.borderColor = UIColor.darkGray.cgColor
            cell.catimage.layer.borderWidth = 1.0
            cell.catimage.sd_setImage(with: URL(string:catrec.image), placeholderImage: UIImage(named: "PlaceHolderSmall"))
            cell.catlable.text = catrec.name
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func getSubcategory_Dtls(_ subCat_ID:String,isedit:Bool){
        self.showProgress()
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
                                let getMin_Rate = self.theme.CheckNullValue((responseDtl as AnyObject).object(forKey: "minrate"))
                                let ratetype = self.theme.CheckNullValue((responseDtl as AnyObject).object(forKey: "ratetype"))
                                let Currency_Code = self.theme.CheckNullValue((responseDtl as AnyObject).object(forKey: "currency_code"))
                                self.theme.saveappCurrencycode(self.theme.getCurrencyCode(Currency_Code))
                                self.hourlyTxt.addSubview(self.theme.SetPaddingViewwithText(self.hourlyTxt))
                            self.edithourlyRate.addSubview(self.theme.SetPaddingViewwithText(self.edithourlyRate))
                                
                                if getMin_Rate == ""
                                {
                                    self.min_Rate = 0
                                }else
                                {
                                    self.min_Rate = Int(getMin_Rate)!
                                }
                                if  isedit
                                {
                                    if ratetype == "Flat"
                                    {
                                        self.edithourlyrateLbl.text = self.theme.setLang("flatrate")
//                                        self.edithourlyrateLbl.text = "\(self.theme.setLang("flatrate")) (Miniumum rate is \(self.theme.getappCurrencycode())\(self.min_Rate))"
                                        self.edithourlyRate.text = getMin_Rate
                                        self.edithourlyRate.isUserInteractionEnabled = false
                                    }
                                    else
                                    {
//                                        self.edithourlyrateLbl.text = self.theme.setLang("hourlyCaps")
                                        self.edithourlyrateLbl.text = "\(self.theme.setLang("hourlyCaps")) (Miniumum rate is \(self.theme.getappCurrencycode())\(self.min_Rate))"
                                        self.edithourlyRate.isUserInteractionEnabled = true
                                    }
                                }
                                else
                                {
                                    if ratetype == "Flat"
                                    {
                                        self.hourlyLbl.text = self.theme.setLang("flatrate")
//                                        self.hourlyLbl.text = "\(self.theme.setLang("flatrate")) (Miniumum rate is \(self.theme.getappCurrencycode())\(self.min_Rate))"
                                        self.hourlyLbl.text = ratetype
                                        self.hourlyTxt.text = getMin_Rate
                                        self.hourlyTxt.isUserInteractionEnabled = false
                                    }
                                    else
                                    {
//                                        self.hourlyLbl.text = self.theme.setLang("hourlyCaps")
                                        self.hourlyLbl.text = "\(self.theme.setLang("hourlyCaps")) (Miniumum rate is \(self.theme.getappCurrencycode())\(self.min_Rate))"
                                        self.hourlyTxt.isUserInteractionEnabled = true
                                    }
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
    
    @objc func editCtegoryData(sender:UIButton)
    {
        if ObjCatArray.Sharedinstance.CategoryMainObj.count > 0
        {
            self.CatleadingConstraint.constant = self.view.frame.size.width
            self.categoryTxt.isHidden = true
            categorysearch.isHidden = true
            self.catSearchTbl.isHidden = true
            self.editscrollview.isHidden = false
            print("CategoryArr---->",CategoryArr)
            self.catSearchTbl.reloadData()
            UIView.animate(withDuration: 0.5, animations: {
                self.CatleadingConstraint.constant = 0
                self.categoryView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }, completion: {(_) -> Void in
                self.categoryView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
            })
            let editcatData = ObjCatArray.Sharedinstance.CategoryMainObj[sender.tag]
            editsaveBtn.tag = sender.tag
            editmaincatBtn.setTitle(editcatData.maincatname, for: .normal)
            editsubcatBtn.setTitle(editcatData.subcatname, for: .normal)
            edithourlyRate.text = editcatData.hourlyrate
            editepeBtn.setTitle(editcatData.experiencelev, for:.normal)
            editquicktext.text = editcatData.quickpitch
            editexpeTbl.isHidden = true
            edithourlyrateValid.isHidden = true
            //      editquickvalid.isHidden = true
            editexpValid.isHidden = true
            self.getSubcategory_Dtls(editcatData.childid, isedit: true)
        }
    }
    
    @objc func deleteCtegoryData(sender:UIButton)
    {
        if ObjCatArray.Sharedinstance.CategoryMainObj.count > 0
        {
            ObjCatArray.Sharedinstance.CategoryMainObj.remove(at: sender.tag)
            self.categoryTbl.reloadData()
            categoryHeight.constant = self.categoryTbl.contentSize.height+CGFloat(ObjCatArray.Sharedinstance.CategoryMainObj.count*20)
            self.categoryTbl.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        else if ObjCatArray.Sharedinstance.CategoryMainObj.count == 0
        {
            ObjCatArray.Sharedinstance.CategoryMainObj.remove(at: sender.tag)
            self.categoryTbl.reloadData()
            categoryHeight.constant = self.categoryTbl.contentSize.height+CGFloat(ObjCatArray.Sharedinstance.CategoryMainObj.count*20)
            self.categoryTbl.layoutIfNeeded()
            self.view.layoutIfNeeded()
            self.submitBtn.isHidden = true
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == experiencetbl
        {
            let expModel = ExperienceArr[indexPath.row]
            experienceBtn.setTitle(expModel.name, for: .normal)
            self.experiencetbl.isHidden = true
            ObjCatArray.Sharedinstance.CAtRec = expModel
        }
        else if tableView ==  catSearchTbl{
            let catrec = self.CategoryArr[indexPath.row]
            if iscatSelect!
            {
                let arr = ObjCatArray.Sharedinstance.CategoryMainObj.filter {
                    $0.childid.contains(catrec.id)
                }
                if arr.count > 0
                {
                    self.categoryView.backgroundColor = UIColor.clear
                    UIView.animate(withDuration:0.5) {
                        self.CatleadingConstraint.constant = self.view.frame.size.width
                        self.categoryView.layoutIfNeeded()
                        self.view.layoutIfNeeded()
                    }
                    self.theme.AlertView(Appname, Message:"This Category already exist", ButtonTitle: kOk)
                    return
                }
                self.subCatHeight.constant = 65
                self.subCatView.isHidden = false
                //select_SubCat = catrec
                self.subcatBtn.setTitle(select_SubCat?.name, for: .normal)
                iscatSelect = false
                self.getSubcategory_Dtls((select_SubCat?.id)!, isedit: false)
                self.quickPitchView.isHidden = false
                self.categoryTbl.isHidden = true
                self.categoryView.backgroundColor = UIColor.clear
                UIView.animate(withDuration:0.5) {
                    self.CatleadingConstraint.constant = self.view.frame.size.width
                    if ObjCatArray.Sharedinstance.CategoryMainObj.count > 0
                    {
                        self.categoryTbl.isHidden = false
                    }
                    self.categoryView.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                }
            }
            else
            {
                select_Cat = catrec
                self.maincatBtn.setTitle(select_Cat?.name, for: .normal)
                iscatSelect = true
                self.categoryTxt.text = ""
                self.subCatHeight.constant = 65
                subCatView.isHidden = false
                self.quickPitchView.isHidden = true
                self.categoryTbl.isHidden = true
                self.categoryView.backgroundColor = UIColor.clear
                UIView.animate(withDuration:0.5) {
                    self.categoryView.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                }
                    self.CatleadingConstraint.constant = self.view.frame.size.width
//                self.GetSubCategoryList()
            }
        }
        else if tableView == editexpeTbl
        {
            ObjCatArray.Sharedinstance.CAtRec =  ExperienceArr[indexPath.row]; self.editepeBtn.setTitle(theme.CheckNullValue(ExperienceArr[indexPath.row].name), for: .normal)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.editexptblheight.constant = 0
                self.editexpeTbl.layoutIfNeeded()
                self.editStackview.layoutIfNeeded()
            })
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= self.min_Rate
    }
    //MARK: - Register api
    
    @IBAction func submitAct(_ sender: Any) {
        /*
        if self.TableViewArray.count>0
        {
            Registerrec["deviceToken"] = self.theme.GetDeviceToken() as String

            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentsViewController") as?  UploadDocumentsViewController{
                if let navigator = self.navigationController
                {
                    let backItem = UIBarButtonItem()
                    backItem.title = ""
                    self.navigationItem.backBarButtonItem = backItem
                    viewController.TableViewArray = self.TableViewArray
                    viewController.delgate=self
                    navigator.pushViewController(withFade: viewController, animated: false)
                }
            }
        }
        else
        {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegSecondPageViewController") as?  RegSecondPageViewController{
                if let navigator = self.navigationController
                {
                    let backItem = UIBarButtonItem()
                    backItem.title = ""
                    self.navigationItem.backBarButtonItem = backItem
                    viewController.AvailableArray = self.AvailableArray
                    
                    navigator.pushViewController(withFade: viewController, animated: false)
                }
            }
        }
       */
        
        
        if ObjCatArray.Sharedinstance.CategoryMainObj.count == 0 {
            self.theme.AlertView(appNameJJ, Message:"select atleast one of the skills", ButtonTitle: kOk)
        }
        //MARK: - Payment url
        else if (CheckBoxButton.imageView?.image == UIImage(named:"Unchecked_Checkbox")) || self.isBackgroundEnable == true
        {
            
            self.viewAgrrement.isHidden=false
            let checkImage = UIImage(named: "Checked_Checkbox")
            self.CheckBoxButton.setImage(checkImage, for: UIControl.State())
            self.CheckBoxButton.isUserInteractionEnabled=false
        self.getPaymetApi()
           
        }
        else
        {
            
            if self.TableViewArray.count>0
            {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentsViewController") as?  UploadDocumentsViewController{
                    if let navigator = self.navigationController
                    {
                        let backItem = UIBarButtonItem()
                        backItem.title = ""
                        self.navigationItem.backBarButtonItem = backItem
                        viewController.TableViewArray = self.TableViewArray
                            viewController.delgate=self
                        
                        navigator.pushViewController(withFade: viewController, animated: false)
                    }
                }
            }
            
            else{
        
                self.submitApiCall()
                /*
            self.submitBtn.isEnabled = false
            var ParameterDict = [NSDictionary]()
            for element in ObjCatArray.Sharedinstance.CategoryMainObj
            {
                let paramDict  = NSMutableDictionary()
                paramDict["categoryid"] = element.parentid
                paramDict["childid"] = element.childid
                UserDefaults.standard.set(element.childid, forKey: "SubCatID")
                UserDefaults.standard.synchronize()
                //paramDict["quick_pitch"] = element.quickpitch
                paramDict["hour_rate"] =  element.hourlyrate
                paramDict["experience"] =  element.experienceid
                paramDict["gcm_id"] = ""
                ParameterDict.append(paramDict)
            }
            Registerrec["deviceToken"] = self.theme.GetDeviceToken() as String
            Registerrec["taskerskills"] = ParameterDict
            print("params for 3rd form\(Registerrec)")
            self.submitBtn.startLoadingAnimation()
                
                
              
            url_handler.makeCall(reg_form4 , param: Registerrec as NSDictionary) {
                (responseObject, error) -> () in
                self.submitBtn.isEnabled = true
                if(error != nil)
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
                        self.submitBtn.returnToOriginalState()
    ()
                        self.submitBtn.isUserInteractionEnabled = true
                    })
                }
                else
                {
                    if(responseObject != nil && (responseObject?.count)!>0)
                    {
                        let responseObject = responseObject as? [String:Any] ?? [:]
                        let status=self.theme.CheckNullValue(responseObject["status"])
                        if(status == "1")
                        {
                            selectedDays.removeAll()
                            self.theme.saveUserDetail(responseObject["response"] as! NSDictionary)
                            let ResponseDict = responseObject["response"] as? [String : Any] ?? [:]
                            let CurrencyCode : String = self.theme.getCurrencyCode(self.theme.CheckNullValue(ResponseDict["currency"]))
                            self.theme.saveappCurrencycode(CurrencyCode as String)
                            let FirstName = self.theme.CheckNullValue(ResponseDict["firstname"])
                            let LastName = self.theme.CheckNullValue(ResponseDict["lastname"])
                            let FullName = "\(FirstName)\(" ")\(LastName)"
                            self.theme.saveFullName(UserName: FullName)
                            let VerifiedStatus = self.theme.CheckNullValue(responseObject["verified_status"])
                            if VerifiedStatus == "3"{
                                self.theme.saveVerifiedStatus(VerifiedStatus: 0)
                            }else{
                                self.theme.saveVerifiedStatus(VerifiedStatus: 1)
                            }
                            let _:UserInfoRecord=self.theme.GetUserDetails()
                            SocketIOManager.sharedInstance.establishConnection()
                            SocketIOManager.sharedInstance.establishChatConnection()
                            if(self.theme.isUserLigin()){
//                                self.MoveToApp()
//                                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentsVCID") as? UploadDocumentsViewController {
//                                    if let navigator = self.navigationController {
//                                        navigator.pushViewController(withFade: viewController, animated: false)
//                                    }
//                                }
                                //MARK: - Push after selector
                                /*
                                if self.TableViewArray.count>0
                                {
                                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentsViewController") as?  UploadDocumentsViewController{
                                        if let navigator = self.navigationController
                                        {
                                            let backItem = UIBarButtonItem()
                                            backItem.title = ""
                                            self.navigationItem.backBarButtonItem = backItem
                                            viewController.TableViewArray = self.TableViewArray
                                                viewController.delgate=self
                                            navigator.pushViewController(withFade: viewController, animated: false)
                                        }
                                    }
                                }
                                else
                                {
                                    */
                                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegSecondPageViewController") as?  RegSecondPageViewController{
                                        if let navigator = self.navigationController
                                        {
                                            let backItem = UIBarButtonItem()
                                            backItem.title = ""
                                            self.navigationItem.backBarButtonItem = backItem
                                            viewController.AvailableArray = self.AvailableArray
                                            
                                            navigator.pushViewController(withFade: viewController, animated: false)
                                        }
                                    }
                                //}
                            
                                
                            }
                        }
                        else
                        {
                            let response = self.theme.CheckNullValue(responseObject["response"])
                            self.theme.AlertView(appNameJJ, Message: response, ButtonTitle: kOk)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
                                self.submitBtn.returnToOriginalState()
                                self.submitBtn.isUserInteractionEnabled = true
                            })
                        }
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
                            self.submitBtn.returnToOriginalState()
                            self.submitBtn.isUserInteractionEnabled = true
                        })
                    }
                }
            }
                
                */
        }
        }
    }
    
    func MoveToApp(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setInitialViewcontroller()
            let socStr:NSString = ""//dict.objectForKey("soc_key") as! NSString
            if(socStr.length>0){
                self.theme.saveJaberPassword(socStr as String)
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
            self.submitBtn.returnToOriginalState()
            self.submitBtn.isUserInteractionEnabled = true
            })
    }
    
//    @objc func update() {
//        self.DismissProgress()
//        self.view.isUserInteractionEnabled = true
//        let appDelegate = (UIApplication.shared.delegate! as! AppDelegate)
//        let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVCSID")
//        //or the homeController
//        let navController = UINavigationController(rootViewController: loginController)
//        appDelegate.window!.rootViewController! = navController
//        loginController.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
    @IBAction func maiCatAction(_ sender: Any) {
        iscatSelect = false
        print("CategoryArr---->",CategoryArr)
        self.CatleadingConstraint.constant = self.view.frame.size.width
        self.categoryTxt.text = ""
        self.CategoryArr.removeAll()
        self.CategoryArr = self.CategorySearchArr
        self.subcatBtn.setTitle(theme.setLang("Select_Sub_Category"), for: .normal)
        self.subCatHeight.constant = 65
        self.subCatView.isHidden = true
        self.editscrollview.isHidden = true
        self.quickPitchView.isHidden = true
        self.categoryTxt.isHidden = false
        categorysearch.isHidden = false
        self.catSearchTbl.isHidden = false
        self.editscrollview.isHidden = true
        print("CategoryArr---->",CategoryArr)
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CatSubCatVCID") as?  CatSubCatViewController{
            if let navigator = self.navigationController
            {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                viewController.isfromMainCat = true
                viewController.MainCategoryArray = CategoryArr
                viewController.Delegate = self
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
//        self.catSearchTbl.reloadData()
//        UIView.animate(withDuration: 0.5, animations: {
//            self.CatleadingConstraint.constant = 0
//            self.categoryView.layoutIfNeeded()
//            self.view.layoutIfNeeded()
//        }, completion: {(_) -> Void in
//            self.categoryView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
//        })
        
    }
    
    func PassMainCategory(MainCat: CategoryRecord) {
        select_Cat = MainCat
        self.maincatBtn.setTitle(select_Cat?.name, for: .normal)
        iscatSelect = true
        self.categoryTxt.text = ""
        self.subCatHeight.constant = 65
        subCatView.isHidden = false
        self.quickPitchView.isHidden = true
        self.categoryTbl.isHidden = true
        self.categoryView.backgroundColor = UIColor.clear
        UIView.animate(withDuration:0.5) {
            self.categoryView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        self.CatleadingConstraint.constant = self.view.frame.size.width
    }
    
    //MARK: - After select sub cat
    
    func PassSubCategory(SubCat: subCategoryRecord) {
        let arr = ObjCatArray.Sharedinstance.CategoryMainObj.filter {
            $0.childid.contains(SubCat.id)
        }
       
        if arr.count > 0
        {
            self.categoryView.backgroundColor = UIColor.clear
            UIView.animate(withDuration:0.5) {
                self.CatleadingConstraint.constant = self.view.frame.size.width
                self.categoryView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
            self.theme.AlertView(Appname, Message:"This Category already exist", ButtonTitle: kOk)
            return
        }
        self.subCatHeight.constant = 65
        self.subCatView.isHidden = false
        select_SubCat = SubCat
        self.subcatBtn.setTitle(SubCat.name, for: .normal)
        iscatSelect = false
        self.getSubcategory_Dtls(SubCat.id, isedit: false)
        self.quickPitchView.isHidden = false
        self.subCatId=SubCat.id
        self.getDocumentsList()
//        self.categoryTbl.isHidden = true
//        self.categoryView.backgroundColor = UIColor.clear
//        UIView.animate(withDuration:0.5) {
//
//            if ObjCatArray.Sharedinstance.CategoryMainObj.count > 0
//            {
//                self.categoryTbl.isHidden = false
//            }
//            self.categoryView.layoutIfNeeded()
//            self.view.layoutIfNeeded()
//        }
//         self.CatleadingConstraint.constant = self.view.frame.size.width
    }
    
    
    
    
    
    
    
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewControllerwithFade(animated: false)
        
    }
    
    @IBAction func subCatAction(_ sender: Any) {
        self.iscatSelect = true
        self.CatleadingConstraint.constant = self.view.frame.size.width
        self.categoryTxt.text = ""
        self.categoryTxt.isHidden = false
        self.categorysearch.isHidden = false
        self.GetSubCategoryList()
        self.quickPitchView.isHidden = true
//        UIView.animate(withDuration: 0.5, animations: {
//            self.CatleadingConstraint.constant = 0
//            self.categoryView.layoutIfNeeded()
//            self.view.layoutIfNeeded()
//        }, completion: {(_) -> Void in
//            self.categoryView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
//        })
        self.hourlyTxt.text = ""
        experienceBtn.setTitle(theme.setLang("Select_Level"), for: .normal)
        self.quickTxt.text = ""
    }
    
    @IBAction func explevAction(_ sender: Any) {
        //       self.experiencetbl.isHidden = false
        //        self.experiencetbl.reloadData()
        hourlyTxt.resignFirstResponder()
        self.experienceDropDown.show()
    }
    
    func setupeditDropDown() {
        EditexperienceDropDown.anchorView = editepeBtn
        //        EditexperienceDropDown = DropDown.init(frame: CGRect(x:editepeBtn.frame.origin.x,y:editepeBtn.frame.maxY,width:editepeBtn.frame.size.width,height:editepeBtn.frame.size.height))
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        EditexperienceDropDown.bottomOffset = CGPoint(x: 0, y: editepeBtn.bounds.height)
        // You can also use localizationKeysDataSource instead. Check the docs.
        EditexperienceDropDown.dataSource = self.experiencenameArray
        
        // Action triggered on selection
        EditexperienceDropDown.selectionAction = { [weak self] (index, item) in
            self?.editepeBtn.setTitle(item, for: .normal)
            let expModel = self?.ExperienceArr[index]
            ObjCatArray.Sharedinstance.CAtRec = expModel!
            self?.EditexperienceDropDown.hide()
        }
    }
    func setupDropDown() {
        experienceDropDown.anchorView = experienceBtn
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        experienceDropDown.bottomOffset = CGPoint(x: 0, y: experienceBtn.bounds.height)
        // You can also use localizationKeysDataSource instead. Check the docs.
        experienceDropDown.dataSource = self.experiencenameArray
        // Action triggered on selection
        experienceDropDown.selectionAction = { [weak self] (index, item) in
            self?.experienceBtn.setTitle(item, for: .normal)
            let expModel = self?.ExperienceArr[index]
            ObjCatArray.Sharedinstance.CAtRec = expModel!
            self?.experienceDropDown.hide()
        }
    }
    @IBAction func editexplevAction(_ sender: Any) {
        
        self.view.endEditing(true)
        self.EditexperienceDropDown.show()
        //        self.editexpeTbl.reloadData()
        //        if self.editexptblheight.constant != CGFloat(self.ExperienceArr.count*30){
        //                self.editexpeTbl.isHidden = false
        //                UIView.animate(withDuration: 0.5, animations: {
        //                    self.editexptblheight.constant = CGFloat(self.ExperienceArr.count*40)
        //                    self.editexpeTbl.layoutIfNeeded()
        //                    self.editStackview.layoutIfNeeded()
        //                })
        //            }
    }
    
    @IBAction func editsaveBtnAction(_ sender: UIButton) {
        hideeditvalid()
        if edithourlyRate.text == ""
        {
            self.edithourlyrateValid.text = self.theme.setLang("Hourly Rate is required")
            self.edithourlyrateValid.isHidden = false
            self.editStackview.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        else if Int(edithourlyRate.text!)! < self.min_Rate
        {
            self.edithourlyrateValid.text = "\(self.theme.setLang("Minimun hourly rate is")) \(self.theme.getappCurrencycode())\(self.min_Rate)"
            self.edithourlyrateValid.isHidden = false
            self.editStackview.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        else if editepeBtn.currentTitle == ""
        {
            
            self.experienceValid.text = self.theme.setLang("Kindly Select your Experience Level.")
            self.editexpValid.isHidden = false
            self.editStackview.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        //        else if editquicktext.text == ""
        //        {
        //               self.editquickvalid.text = self.theme.setLang("Quick Pinch field was empty")
        //            self.editquickvalid.isHidden = false
        //            self.editStackview.layoutIfNeeded()
        //            self.view.layoutIfNeeded()
        //        }
        let indexValue = sender.tag
        ObjCatArray.Sharedinstance.CategoryMainObj[indexValue].hourlyrate = edithourlyRate.text!
        ObjCatArray.Sharedinstance.CategoryMainObj[indexValue].experiencelev = self.editepeBtn.currentTitle!
        ObjCatArray.Sharedinstance.CategoryMainObj[indexValue].experienceid = (ObjCatArray.Sharedinstance.CAtRec.id)
        ObjCatArray.Sharedinstance.CategoryMainObj[indexValue].quickpitch = editquicktext.text
        print("The ObjCatArray.Sharedinstance.CategoryMainObj ===>\(ObjCatArray.Sharedinstance.CategoryMainObj)")
        self.categoryView.backgroundColor = UIColor.clear
        UIView.animate(withDuration:0.5) {
            self.CatleadingConstraint.constant = self.view.frame.size.width
            self.categoryView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if hourlyTxt.text == ""
        {
            self.hourlyvalidHeight.constant = 20
            self.hourlyValid.text = self.theme.setLang("Hourly Rate is required")
            self.expvalidHeight.constant = 0
            self.quickvalidHeight.constant = 0
            self.quickPitchView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        else if Int(hourlyTxt.text!) ?? 0 < self.min_Rate
        {
            self.hourlyValid.text = "\(self.theme.setLang("Minimun hourly rate is")) \(self.theme.getappCurrencycode())\(self.min_Rate)"
            self.hourlyvalidHeight.constant = 20
            self.expvalidHeight.constant = 0
            self.quickvalidHeight.constant = 0
            self.quickPitchView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        else if experienceBtn.currentTitle == theme.setLang("Select_Level")
        {
            self.hourlyvalidHeight.constant = 0
            self.expvalidHeight.constant = 20
            self.experienceValid.text = self.theme.setLang("Kindly Select your Experience Level.")
            self.quickvalidHeight.constant = 0
            self.quickPitchView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
            //        else if quickTxt.text == ""
            //        {
            //            self.hourlyvalidHeight.constant = 0
            //            self.expvalidHeight.constant = 0
            //            self.quickvalidHeight.constant = 20
            //            self.quickValid.text = self.theme.setLang("Quick Pinch field was empty")
            //            self.quickPitchView.layoutIfNeeded()
            //            self.view.layoutIfNeeded()
            //        }
        else
        {
            self.hourlyvalidHeight.constant = 0
            self.expvalidHeight.constant = 0
            self.quickvalidHeight.constant = 0
            self.quickPitchView.layoutIfNeeded()
            self.view.layoutIfNeeded()
            
            let savedata = AddCategoryModel()
            savedata.parentid = (select_Cat?.id)!
            savedata.childid = (select_SubCat?.id)!
            savedata.experienceid = (ObjCatArray.Sharedinstance.CAtRec.id)
            savedata.quickpitch = quickTxt.text!
            savedata.hourlyrate = self.hourlyTxt.text!
            savedata.subcatname = (select_SubCat?.name)!
            savedata.maincatname = (select_Cat?.name)!
            savedata.experiencelev = (ObjCatArray.Sharedinstance.CAtRec.name)
            ObjCatArray.Sharedinstance.CategoryMainObj.append(savedata)
            self.hideallviews()
            self.categoryTbl.isHidden = false
            maincatBtn.setTitle(theme.setLang("Select_Category"), for: .normal)
            subcatBtn.setTitle(theme.setLang("Select_Sub_Category"), for: .normal)
            self.categoryTbl.reloadData()
            categoryHeight.constant = self.categoryTbl.contentSize.height+20
            self.categoryTbl.layoutIfNeeded()
            self.view.layoutIfNeeded()
            self.submitBtn.isHidden = false
        }
    }
    
    @IBAction func didClickCalendar(_ sender: Any) {
    }
    @IBAction func closeBtnAction(_ sender: Any) {
        self.quickPitchView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Api call
extension RegFourthPageViewController:UploadDocDelgate,paymentFuctDelegate{
    func paymentFuctionDelegate(_ url: String)
    {
        self.viewAgrrement.isHidden=false
        
        let checkImage = UIImage(named: "Checked_Checkbox")
        let uncheck_Image = UIImage(named: "Unchecked_Checkbox")
        //observeValue https://dev.via-hive.com/
        if url.contains("https://dev.via-hive.com/")
        {
          
        CheckBoxButton.setImage(checkImage, for: UIControl.State())
            CheckBoxButton.isUserInteractionEnabled=false
            
            if self.TableViewArray.count>0
            {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentsViewController") as?  UploadDocumentsViewController{
                    if let navigator = self.navigationController
                    {
                        let backItem = UIBarButtonItem()
                        backItem.title = ""
                        self.navigationItem.backBarButtonItem = backItem
                        viewController.TableViewArray = self.TableViewArray
                            viewController.delgate=self
                        
                        navigator.pushViewController(withFade: viewController, animated: false)
                    }
                }
            }
            
            else{
        
                self.submitApiCall()
            }

        }
        else
        {
            CheckBoxButton.setImage(uncheck_Image, for: UIControl.State())
            self.isBackgroundEnable=true
            CheckBoxButton.isUserInteractionEnabled=true

        }
    }
    
    func UploadDocFuctionDelegate(_ uploadDocArray: [Any]) {
        
        print("The uploadDocArray in delagte \(uploadDocArray)")
         Registerrec["documents"] = uploadDocArray

        print("The uploadDocArray Registerrec \(Registerrec)")
        submitApiCall()
    }
    //MARK: - Api call
    
    func submitApiCall()
    {
    
        self.submitBtn.isEnabled = false
        var ParameterDict = [NSDictionary]()
        for element in ObjCatArray.Sharedinstance.CategoryMainObj
        {
            let paramDict  = NSMutableDictionary()
            paramDict["categoryid"] = element.parentid
            paramDict["childid"] = element.childid
            UserDefaults.standard.set(element.childid, forKey: "SubCatID")
            UserDefaults.standard.synchronize()
            //paramDict["quick_pitch"] = element.quickpitch
            paramDict["hour_rate"] =  element.hourlyrate
            paramDict["experience"] =  element.experienceid
            paramDict["gcm_id"] = ""
            ParameterDict.append(paramDict)
        }
        Registerrec["deviceToken"] = self.theme.GetDeviceToken() as String
        Registerrec["radius"] = DataManager.userRadius

        Registerrec["taskerskills"] = ParameterDict
        print("params for 3rd form\(Registerrec)")
        self.submitBtn.startLoadingAnimation()
            
            
          
        url_handler.makeCall(reg_form4 , param: Registerrec as NSDictionary) {
            (responseObject, error) -> () in
            self.submitBtn.isEnabled = true
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
                    self.submitBtn.returnToOriginalState()
()
                    self.submitBtn.isUserInteractionEnabled = true
                })
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.theme.CheckNullValue(responseObject["status"])
                    if(status == "1")
                    {
                        selectedDays.removeAll()
                        self.theme.saveUserDetail(responseObject["response"] as! NSDictionary)
                        let ResponseDict = responseObject["response"] as? [String : Any] ?? [:]
                        let CurrencyCode : String = self.theme.getCurrencyCode(self.theme.CheckNullValue(ResponseDict["currency"]))
                        self.theme.saveappCurrencycode(CurrencyCode as String)
                        let FirstName = self.theme.CheckNullValue(ResponseDict["firstname"])
                        let LastName = self.theme.CheckNullValue(ResponseDict["lastname"])
                        let FullName = "\(FirstName)\(" ")\(LastName)"
                        self.theme.saveFullName(UserName: FullName)
                        let VerifiedStatus = self.theme.CheckNullValue(responseObject["verified_status"])
                        if VerifiedStatus == "3"{
                            self.theme.saveVerifiedStatus(VerifiedStatus: 0)
                        }else{
                            self.theme.saveVerifiedStatus(VerifiedStatus: 1)
                        }
                        let _:UserInfoRecord=self.theme.GetUserDetails()
                        SocketIOManager.sharedInstance.establishConnection()
                        SocketIOManager.sharedInstance.establishChatConnection()
                        if(self.theme.isUserLigin()){
//                                self.MoveToApp()
//                                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentsVCID") as? UploadDocumentsViewController {
//                                    if let navigator = self.navigationController {
//                                        navigator.pushViewController(withFade: viewController, animated: false)
//                                    }
//                                }
                            //MARK: - Push after selector
                            /*
                            if self.TableViewArray.count>0
                            {
                                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentsViewController") as?  UploadDocumentsViewController{
                                    if let navigator = self.navigationController
                                    {
                                        let backItem = UIBarButtonItem()
                                        backItem.title = ""
                                        self.navigationItem.backBarButtonItem = backItem
                                        viewController.TableViewArray = self.TableViewArray
                                            viewController.delgate=self
                                        navigator.pushViewController(withFade: viewController, animated: false)
                                    }
                                }
                            }
                            else
                            {
                                */
                                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegSecondPageViewController") as?  RegSecondPageViewController{
                                    if let navigator = self.navigationController
                                    {
                                        let backItem = UIBarButtonItem()
                                        backItem.title = ""
                                        self.navigationItem.backBarButtonItem = backItem
                                        viewController.AvailableArray = self.AvailableArray
                                        
                                        navigator.pushViewController(withFade: viewController, animated: false)
                                    }
                                }
                            //}
                        
                            
                        }
                    }
                    else
                    {
                        let response = self.theme.CheckNullValue(responseObject["response"])
                        self.theme.AlertView(appNameJJ, Message: response, ButtonTitle: kOk)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
                            self.submitBtn.returnToOriginalState()
                            self.submitBtn.isUserInteractionEnabled = true
                        })
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
                        self.submitBtn.returnToOriginalState()
                        self.submitBtn.isUserInteractionEnabled = true
                    })
                }
            }
        }
            
    }
    
    //MARK: - GetDocumentsList API
    func getDocumentsList() {
        self.theme.showProgress(View: self.view)

        
        let Parameter : NSDictionary = ["id":self.subCatId]
        url_handler.makeNewApiCall(GetDocReqById , param: Parameter as NSDictionary) {
            (responseObject, error) -> () in
            if(error != nil)
            {
                self.view.makeToast(message:error?.localizedDescription ??  "", duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                self.theme.DismissProgress()

            }
            else
            {
                self.theme.DismissProgress()
               debugPrint("responseObject = \(responseObject)")
                if (responseObject != nil) {
                    self.theme.DismissProgress()
                    let responseObject = responseObject!
                    print("DocumentsList is  \(responseObject)")
                    let documentsData = responseObject.object(forKey: "documentlist") as! NSArray
                    print("DocumentsArray is  \(documentsData)")
                    for documentDetails in documentsData {
                        
                        let status = self.theme.CheckNullValue((documentDetails as AnyObject).object(forKey: "status"))
                        let name = self.theme.CheckNullValue((documentDetails as AnyObject).object(forKey: "name"))
                        if status == "1" //&& !name.contains("Background Check")
                        {
                            
                            if name.contains("Background Check")
                               
                            {
                                self.isBackgroundEnable = true
                            }
                            else
                            {
                                //self.viewAgrrement.isHidden=true

                                let documents = documentList()
                                documents.name = self.theme.CheckNullValue((documentDetails as AnyObject).object(forKey: "name"))
                                //self.theme.CheckNullValue((documentDetails as AnyObject).object(forKey: "status"))
                                documents._id = self.theme.CheckNullValue((documentDetails as AnyObject).object(forKey: "_id"))
                                documents.status = status
                                documents.image = ""
                                documents.fileType = ""
                                documents.expdate = ""
                                self.TableViewArray.append(documents)
                            }
                        }
                    }
                   // self.UploadDocTableView.reloadData()
                }
                else {
                    self.theme.DismissProgress()
                    self.view.makeToast(message:Language_handler.VJLocalizedString("no_document", comment: nil), duration: 3, position: HRToastPositionDefault as AnyObject, title: Language_handler.VJLocalizedString("sorry", comment: nil))
                }
            }}
        
        
        /*
        
      //  debugPrint("getDocumentsList \(GetDocumentsList)")
        url_handler.makeGetCall(GetDocumentsList as NSString) { (responseObject) in
            if (responseObject != nil) {
                self.theme.DismissProgress()
                let responseObject = responseObject!
                print("DocumentsList is  \(responseObject)")
                let documentsData = responseObject.object(forKey: "documents") as! NSArray
                print("DocumentsArray is  \(documentsData)")
                for documentDetails in documentsData {
                    let documents = documentList()
                    documents.name = self.theme.CheckNullValue((documentDetails as AnyObject).object(forKey: "name"))
                    documents.image = ""
                    documents.fileType = ""
                    documents.expdate = ""
                    self.TableViewArray.append(documents)
                }
                self.UploadDocTableView.reloadData()
            } else {
                self.theme.DismissProgress()
                self.view.makeToast(message:Language_handler.VJLocalizedString("no_document", comment: nil), duration: 3, position: HRToastPositionDefault as AnyObject, title: Language_handler.VJLocalizedString("sorry", comment: nil))
            }
        }
        */
    }
    
    //MARK: - getPaymetApi API
    func getPaymetApi()
    {
        self.theme.showProgress(View: self.view)

        
        let Parameter : NSDictionary = [:]
        url_handler.makeNewApiCall(background_check_payment , param: Parameter as NSDictionary) {
            (responseObject, error) -> () in
            if(error != nil)
            {
                self.view.makeToast(message:error?.localizedDescription ??  "", duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                self.theme.DismissProgress()

            }
            else
            {
                if let payment = (responseObject as? [String:Any])//responseObject?.object(forKey: "payment") as? [String:Any]
                {
                   if let pay = payment["payment"] as? [String:Any]
                    
                    {
                        self.paymet_url = self.theme.CheckNullValue((pay as AnyObject).object(forKey: "url"))

                    }
                    
                    
                }
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BackgroundpaymentVC") as?  BackgroundpaymentVC{
                    if let navigator = self.navigationController
                    {
                        let backItem = UIBarButtonItem()
                        backItem.title = ""
                        self.navigationItem.backBarButtonItem = backItem
                        viewController.link = self.paymet_url
                        viewController.delegate=self
                       
                        navigator.pushViewController(withFade: viewController, animated: false)
                    }
                }

                
                self.theme.DismissProgress()
            }
        }
    }
}
