 //
 //  TaskerProfileViewController.swift
 //  Plumbal
 //
 //  Created by Casperon on 27/09/17.
 //  Copyright © 2017 Casperon Tech. All rights reserved.
 //
 
 import UIKit
 //import SDWebImage
 class Stack {
    
    var stackArray = [NSDictionary]()
    
    func push(stringToPush: NSDictionary){
        self.stackArray.append(stringToPush)
    }
    
    func pop() -> NSDictionary? {
        if self.stackArray.first != nil {
            let stringToReturn = self.stackArray.last
            self.stackArray.removeLast()
            return stringToReturn!
        } else {
            return nil
        }
    }
    
    func isEmpty() -> Bool {
        return stackArray.isEmpty
    }
 }
 
 class categoryModel : NSObject{
    var catname =  String()
    var cattype = String()
    var catamount = String()
    var catimage  = String()
   
 }
 class TaskerProfileViewController: RootBaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet var myprofile: UILabel!
    var availabilityDict : NSMutableArray = NSMutableArray()
    var AvailableDaysArray :NSMutableArray = NSMutableArray()
    var AvailableAllDaysArray :NSMutableArray = NSMutableArray()
    var CategoryArray = [categoryModel]()
    var weekFullDay = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var ProfileContentArray:NSMutableArray = [];
    var reviewsArray:NSMutableArray = [];
    var nextPageStr:NSInteger!
    var providerid:String = ""
    var minCost : String = ""
    var hourlyCost : String = ""
    @IBOutlet var categorytable_height: NSLayoutConstraint!
    @IBOutlet var categorytable: UITableView!
    @IBOutlet var radiuslabl: UILabel!
    @IBOutlet var reviewtableview: UITableView!
    @IBOutlet var segmentView: UIView!
    @IBOutlet var taskerimg: UIImageView!
    @IBOutlet var taskername: UILabel!
    @IBOutlet var taskeremail: UILabel!
    @IBOutlet var taskermobile: UILabel!
    @IBOutlet var avgrating: UILabel!
    @IBOutlet var ratingview: SetColorView!
    
    @IBOutlet var addresslabl: UILabel!
    
    @IBOutlet var workinglocation: UILabel!
    @IBOutlet var Avialbletable: UITableView!
    @IBOutlet var taskerscroll: UIScrollView!
    @IBOutlet var detailtableview: UITableView!
    
    @IBOutlet var address: UILabel!
    @IBOutlet var working: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var radius: UILabel!
    @IBOutlet var availability: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    var messageQueue = Stack()
    var ObjAvailArray = [AvailableRec]()
    
    
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var BottomBtnHeight: NSLayoutConstraint!
    @IBOutlet var tbl_height: NSLayoutConstraint!
    
    fileprivate var loading = false {
        didSet {
            
        }
    }
    var bottomBorder = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.theme.yesTheDeviceisHavingNotch(){
            self.HeaderViewHeight.constant = 100
            self.BottomBtnHeight.constant = self.BottomBtnHeight.constant+20
        }
        
        myprofile.text = theme.setLang("my_profile")
        
        address.text = theme.setLang("address")
        working.text = theme.setLang("working_loc")
        category.text = theme.setLang("category")
        radius.text = theme.setLang("radius")
        availability.text = theme.setLang("availability")
        backBtn.tintColor = PlumberThemeColor
        editBtn.setTitle(theme.setLang("edit_profile"), for: UIControl.State())
        if (self.navigationController!.viewControllers.count != 1) {
            backBtn.isHidden=false;
            barButton.isHidden=true
        }else{
            
        }
        barButton.addTarget(self, action: #selector(TaskerProfileViewController.openmenu), for: .touchUpInside)
        
        taskerscroll.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        taskerimg.layer.cornerRadius = taskerimg.frame.width/2;
        taskerimg.layer.masksToBounds = true;
        
        let segmentedControl1 = HMSegmentedControl(sectionTitles: [theme.setLang("profile"),theme.setLang("reviewtitle")])
        segmentedControl1?.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        segmentedControl1?.frame = CGRect(x: 0, y:0, width: segmentView.frame.size.width, height: segmentView.frame.size.height)
        segmentedControl1?.segmentEdgeInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        segmentedControl1?.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segmentedControl1?.selectionIndicatorLocation = .down
        segmentedControl1?.selectionIndicatorColor = PlumberThemeColor
        segmentedControl1?.isVerticalDividerEnabled = true
        segmentedControl1?.verticalDividerColor = UIColor.white
        segmentedControl1?.verticalDividerWidth = 1.0
        segmentedControl1?.verticalDividerWidth = 1.0
        
        let titleDict: NSDictionary = [NSAttributedString.Key.font: PlumberLargeFont!, NSAttributedString.Key.foregroundColor:UIColor.black]
        segmentedControl1?.titleTextAttributes = titleDict as? [AnyHashable: Any]
        let selectitleDict: NSDictionary = [NSAttributedString.Key.font: PlumberLargeFont!, NSAttributedString.Key.foregroundColor:PlumberThemeColor]
        
        segmentedControl1?.selectedTitleTextAttributes = selectitleDict as? [AnyHashable: Any]
        
        segmentedControl1?.addTarget(self, action: #selector(TaskerProfileViewController.segmentedControlChangedValue(_:)), for: .valueChanged)
        
        self.segmentView.addSubview(segmentedControl1!)
        
        ratingview.layer.cornerRadius = 15;
        ratingview.layer.masksToBounds = true;
        
        categorytable.register(UINib(nibName: "TaskerdetailTableViewCell", bundle: nil), forCellReuseIdentifier: "taskercell")
        categorytable.estimatedRowHeight = 50
        categorytable.rowHeight = UITableView.automaticDimension
        categorytable.tableFooterView = UIView()
        categorytable.delegate = self
        categorytable.dataSource = self
        
        Avialbletable.register(UINib(nibName:"AvailableDaysTableCell", bundle: nil), forCellReuseIdentifier: "availabledayscell")
        Avialbletable.estimatedRowHeight = 70
        Avialbletable.rowHeight = UITableView.automaticDimension
        Avialbletable.tableFooterView  = UIView()
        Avialbletable.isHidden = false
        Avialbletable.delegate = self
        Avialbletable.dataSource = self
        
        reviewtableview.register(UINib(nibName: "TaskerReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewsTblIdentifier")
        reviewtableview.estimatedRowHeight = 130
        reviewtableview.rowHeight = UITableView.automaticDimension
        reviewtableview.tableFooterView = UIView()
        reviewtableview.delegate = self
        reviewtableview.dataSource = self
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        providerid = objUserRecs.providerId
        
        // Do any additional setup after loading the view.
    }
    
    @objc func openmenu(){
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        // Present the view controller
        //
        self.frostedViewController.presentMenuViewController()
    }
    
    @IBAction func didClickBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reviewtableview.isHidden=true
        nextPageStr=1
        if(ProfileContentArray.count>0){
            ProfileContentArray.removeAllObjects()
            self.availabilityDict.removeAllObjects()
            self.AvailableDaysArray.removeAllObjects()
            self.reviewsArray.removeAllObjects()
            self.CategoryArray.removeAll()
        }
        self.GetReviews()
        self.GetUserDetails()
        
    }
    
    @objc func segmentedControlChangedValue(_ segmentedControl: HMSegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0
        {
            self.reviewtableview.isHidden = true
            self.editBtn.isHidden = false
        }
        else{
            self.reviewtableview.isHidden = false
            self.editBtn.isHidden = true
            //            if self.reviewsArray.count == 0  {
            //                self.theme.AlertView("\(Appname)", Message:self.theme.setLang("not_yet_reviews") , ButtonTitle: kOk)
            //            }
        }
        print("Selected index \(Int(segmentedControl.selectedSegmentIndex)) (via UIControlEventValueChanged)")
    }
    
    func uisegmentedControlChangedValue(_ segmentedControl: UISegmentedControl) {
        print("Selected index \(Int(segmentedControl.selectedSegmentIndex))")
    }
    
    @IBAction func didclickback(_ sender: AnyObject) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func GetUserDetails(){
        self.showProgress()
        
        let Param: Dictionary = ["provider_id":"\(providerid)"]
        
        url_handler.makeCall(viewProfile, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            if(error != nil)
            {
                self.view.makeToast(message: kErrorMsg, duration: 3, position: HRToastActivityPositionDefault as AnyObject, title: Appname)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                    
                    if(status == "1") || (status == "3")
                    {
                        self.taskername.text=self.theme.CheckNullValue((responseObject.object(forKey: "response") as AnyObject).object(forKey: "provider_name") as AnyObject)
                        let Doublerat =  Double(self.theme.CheckNullValue((responseObject.object(forKey: "response")! as AnyObject).object(forKey: "avg_review") as AnyObject))
                        let doubleStr = String(format: "%.1f", Doublerat!)
                        self.avgrating.text = doubleStr
                        self.taskeremail.text = self.theme.CheckNullValue((responseObject.object(forKey: "response")! as AnyObject).object(forKey: "email") as AnyObject)
                        
                        let code = self.theme.CheckNullValue((responseObject.object(forKey: "response")! as AnyObject).object(forKey: "dial_code") as AnyObject)
                        let mob = self.theme.CheckNullValue((responseObject.object(forKey: "response")! as AnyObject).object(forKey: "mobile_number") as AnyObject)
                        self.taskermobile.text = "\(code) \(mob)"
                        self.radiuslabl.text = self.theme.CheckNullValue((responseObject.object(forKey: "response")! as AnyObject).object(forKey: "radius") as AnyObject)
                        
                        self.workinglocation.numberOfLines=0
                        self.workinglocation.sizeToFit()
                        
                        self.workinglocation.text = self.theme.CheckNullValue((responseObject.object(forKey: "response")! as AnyObject).object(forKey: "Working_location") as AnyObject)
                        
                        let Dict : NSDictionary = (responseObject.object(forKey: "response"))! as! NSDictionary
                        let imgurl = self.theme.CheckNullValue(Dict.object(forKey: "image"))
                        
                        self.taskerimg.sd_setImage(with: URL(string:imgurl)) { (image, error, cache, urls) in
                            if (error != nil) {
                                self.taskerimg.image = UIImage(named: "PlaceHolderSmall")
                            } else {
                                self.taskerimg.image = image
                            }
                        }
                        
                        self.theme.saveUserImage(self.theme.CheckNullValue(Dict.object(forKey: "image")as! NSString as String) as NSString)
                        if(((responseObject.object(forKey: "response") as AnyObject).object(forKey: "category_Details")! as AnyObject).count>0){
                            let cat_array : NSArray = (responseObject.object(forKey: "response") as AnyObject).object(forKey: "category_Details") as! NSArray
                            
                            for (_,element) in cat_array.enumerated()
                            {
                                let category = categoryModel()
                                category.catname = self.theme.CheckNullValue((element as AnyObject).object(forKey: "categoryname") as AnyObject)
                                category.cattype = self.theme.CheckNullValue((element as AnyObject).object(forKey: "ratetype") as AnyObject)
                                category.catamount = self.theme.CheckNullValue((element as AnyObject).object(forKey: "hourlyrate") as AnyObject)
                                self.CategoryArray.append(category)
                            }
                        }
                       
                        
                        self.categorytable.reloadData()
//                        self.categorytable_height.constant = self.categorytable.contentSize.height + 20
                        
                        if(((responseObject.object(forKey: "response") as AnyObject).object(forKey: "details")! as AnyObject).count>0){
                            let  listArr:NSArray=(responseObject.object(forKey: "response") as AnyObject).object(forKey: "details") as! NSArray
                            
//                            self.availabilityDict = (responseObject.object(forKey: "response") as AnyObject).object(forKey: "availability_days") as! NSMutableArray
                            
                            for (_, element) in listArr.enumerated() {
                                
                                if self.theme.CheckNullValue((element as AnyObject).object(forKey: "desc") as AnyObject) == ""
                                {
                                    print("remove bio field")
                                }
                                else{
                                    if self.theme.CheckNullValue((element as AnyObject).object(forKey: "title") as AnyObject) == "Email" || self.theme.CheckNullValue((element as AnyObject).object(forKey: "title") as AnyObject) == "Mobile" ||  self.theme.CheckNullValue((element as AnyObject).object(forKey: "title") as AnyObject) == "Bio" || self.theme.CheckNullValue((element as AnyObject).object(forKey: "title") as AnyObject) == "Experience" || self.theme.CheckNullValue((element as AnyObject).object(forKey: "title") as AnyObject) == "Radius"
                                    {
                                        
                                    }
                                    else{
                                        let result1 = self.theme.CheckNullValue((element as AnyObject).object(forKey: "desc") as AnyObject).replacingOccurrences(of: "\n", with:",")
                                        
                                        let rec = ProfileContentRecord(userTitle: self.theme.CheckNullValue((element as AnyObject).object(forKey: "title") as AnyObject), desc: result1)
                                        self.ProfileContentArray .add(rec)
                                    }
                                }
                            }
                            if self.ObjAvailArray.count != 0{
                                self.ObjAvailArray.removeAll()
                            }
                            let AvailablityArray = ((responseObject.object(forKey: "response")as AnyObject).object(forKey: "availability_days")as AnyObject) as? [Any]
                            for objDict in AvailablityArray!{
                                let objDict = objDict as? [String:Any]
                                let objAvailRec = AvailableRec()
                                objAvailRec.day = self.theme.CheckNullValue(objDict?["day"])
                                objAvailRec.selected = objDict?["selected"] as? Bool
                                objAvailRec.wholeday = objDict?["wholeday"] as? Bool
                                
                                let SlotsArray = objDict?["slot"] as? [Any]
                                for SlotsObj in SlotsArray!{
                                    let SlotsObj = SlotsObj as? [String:Any]
                                    let SlotsRec = Slots()
                                    SlotsRec.slotIndex = SlotsObj?["slot"] as? Int
                                    SlotsRec.TimeInterval = self.theme.CheckNullValue(SlotsObj?["time"])
                                    SlotsRec.selected = SlotsObj?["selected"] as? Bool ?? false
                                    objAvailRec.SlotArray.append(SlotsRec)
                                }
                                self.ObjAvailArray.append(objAvailRec)
                            }
                            
                            
                            //                            let record  = AvailableRecord (dayrec: Language_handler.VJLocalizedString("days", comment: nil)
                            //                                ,mornigrec:Language_handler.VJLocalizedString("morning", comment: nil)
                            //                                ,Afterrec:Language_handler.VJLocalizedString("afternoon", comment: nil)
                            //                                ,eveningrec:Language_handler.VJLocalizedString("evening", comment: nil))
                            //                            self.AvailableDaysArray.add(record)
                            //                            var justI = 1
                            //                            self.AvailableAllDaysArray = NSMutableArray()
                            //
                            //                            for (_, element) in self.availabilityDict.enumerated() {
                            //                                let result1 = self.theme.CheckNullValue((element as AnyObject).object(forKey: "day") as AnyObject)
                            //
                            //                                let avaialbletime  : String = self.theme.CheckNullValue((((element as AnyObject).object(forKey: "hour"))! as AnyObject).object(forKey: "morning") as AnyObject)
                            //                                let avaialbleAftertime  : String =   self.theme.CheckNullValue((((element as AnyObject).object(forKey: "hour"))! as AnyObject).object(forKey: "afternoon") as AnyObject)
                            //                                let avaialbleevetime  : String = self.theme.CheckNullValue((((element as AnyObject).object(forKey: "hour"))! as AnyObject).object(forKey: "evening") as AnyObject)
                            //                                let record  = AvailableRecord (dayrec: result1,mornigrec: avaialbletime ,Afterrec: avaialbleAftertime,eveningrec: avaialbleevetime)
                            //                                self.AvailableDaysArray.add(record)
                            //
                            //                            }
                            //
                            //                            for i in 0...6
                            //                            {
                            //                                let availableObj = self.AvailableDaysArray.object(at: justI) as! AvailableRecord
                            //                                if availableObj.AvailDays as String == self.weekFullDay[i]{
                            //                                    let record  = AvailableRecord (dayrec: availableObj.AvailDays as String,mornigrec: availableObj.AvailMornigtime as String,Afterrec: availableObj.AvailAftertime as String,eveningrec: availableObj.Availeveningtime as String)
                            //                                    self.AvailableAllDaysArray.add(record)
                            //                                    if  justI < self.AvailableDaysArray.count-1{
                            //                                        justI += 1
                            //                                    }
                            //                                }else{
                            //                                    let record  = AvailableRecord (dayrec: self.weekFullDay[justI],mornigrec: "0" ,Afterrec: "0",eveningrec: "0")
                            //                                    self.AvailableAllDaysArray.add(record)
                            //                                }
                            //                            }
                            //
                            //                            print(self.AvailableDaysArray.count)
                            //                            self.tbl_height.constant = CGFloat((self.AvailableDaysArray.count+1)*44)
                            self.Avialbletable.reloadData()
                            self.Avialbletable.layoutIfNeeded()
                            self.view.layoutIfNeeded()
                            
                        }else{
                            //self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionCenter, title: appNameJJ)
                        }
                    }
                    else
                    {
                        self.view.makeToast(message: kErrorMsg, duration: 3, position: HRToastActivityPositionDefault as AnyObject, title: Appname)
                    }
                }
                else
                {
                    self.view.makeToast(message: kErrorMsg, duration: 3, position: HRToastActivityPositionDefault as AnyObject, title: Appname)
                }
            }
            
        }
    }
    @IBAction func didClickEditProfile(_ sender: AnyObject) {
        
        //        if AvailableAllDaysArray.count > 0
        //        {
        let myViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "EditProfileVCSID") as? EditProfileViewController
        
        myViewController!.availabilityStorage = self.AvailableAllDaysArray
        myViewController!.AvailablityArray = self.ObjAvailArray
        self.navigationController!.pushViewController(withFade: myViewController!, animated: false)
        //        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView==reviewtableview){
            if reviewsArray.count == 0 {
                loadNoData()
                return 1
            }
            reviewtableview.backgroundView = nil
            reviewtableview.separatorStyle = .singleLine
            return 1
        }
        return 1
    }
    func loadNoData() {
        let nibView = Bundle.main.loadNibNamed("EmptyDataView", owner: self, options: nil)![0] as! EmptyDataView
        nibView.frame = self.reviewtableview.bounds;
        nibView.msgLbl.text = self.theme.setLang("no_reviews")
        nibView.msgLbl.font = PlumberLargeFont
        self.reviewtableview.backgroundView=nibView
        reviewtableview.backgroundView = nibView
        reviewtableview.separatorStyle = .none
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView ==  Avialbletable)
        {
            //            return AvailableDaysArray.count
            return ObjAvailArray.count
        }
        else if tableView == categorytable
        {
            return CategoryArray.count
        }
        else if(tableView==reviewtableview){
            return reviewsArray.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->     UITableViewCell {
        
        var cell3:UITableViewCell = UITableViewCell()
        
        if (tableView == Avialbletable)
        {
            let avialCell:AvailableDaysTableCell = tableView.dequeueReusableCell(withIdentifier: "availabledayscell") as! AvailableDaysTableCell
            avialCell.DayLbl.text = ObjAvailArray[indexPath.row].day
            avialCell.TimeLbl.text = self.theme.setLang("Not_Selected")
            if ObjAvailArray[indexPath.row].wholeday == true {
                avialCell.TimeLbl.text = self.theme.setLang("Wholeday")
            }
            else
            {
             let ShowingArry = ObjAvailArray[indexPath.row].SlotArray.filter {($0.selected == true)}
            let titleArray = ShowingArry.map{(self.theme.CheckNullValue($0.TimeInterval))}
            if titleArray.count > 0{
                let combainedString = titleArray.joined(separator: ",")
                avialCell.TimeLbl.text = combainedString
            }
            else{
                avialCell.TimeLbl.text = self.theme.setLang("Not_Selected")
            }
        }
            //
            //            if indexPath.row == 0
            //            {
            //                avialCell.Morning.isHidden = false
            //                avialCell.afternoon.isHidden = false
            //                avialCell.Evning.isHidden = false
            //                avialCell.mrnbtn.isHidden = true
            //                avialCell.afternbtn.isHidden = true
            //                avialCell.evebtn.isHidden = true
            //            }
            //            else
            //            {
            //                avialCell.Morning.isHidden = true
            //                avialCell.afternoon.isHidden = true
            //                avialCell.Evning.isHidden = true
            //                avialCell.mrnbtn.isHidden = false
            //                avialCell.afternbtn.isHidden = false
            //                avialCell.evebtn.isHidden = false
            //            }
            //
            //
            //            if AvailableDaysArray.count > 0
            //            {
            //                avialCell.loadProfileTableCell(self.AvailableDaysArray .object(at: indexPath.row) as! AvailableRecord)
            //
            //            }
            avialCell.selectionStyle=UITableViewCell.SelectionStyle.none
            
            cell3=avialCell
            
            
        }
        else if tableView == reviewtableview{
            let cell:TaskerReviewCell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTblIdentifier") as! TaskerReviewCell
            
            if (reviewsArray.count > 0)
            {
                cell.loadReviewTableCell((reviewsArray .object(at: indexPath.row) as! ReviewRecords), currentView:TaskerProfileViewController() as UIViewController)
                
            }
            cell.selectionStyle=UITableViewCell.SelectionStyle.none
            cell3=cell
        }
            
        else{
            
            let cell:TaskerdetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "taskercell") as! TaskerdetailTableViewCell
            let catmodel = self.CategoryArray[indexPath.row]
            cell.categorylabl.text = catmodel.catname
            if catmodel.cattype == "Flat"
            {
                cell.cat_amount.text = "\(theme.getappCurrencycode())\(catmodel.catamount)"
            }else
            {
                cell.cat_amount.text = "\(theme.getappCurrencycode())\(catmodel.catamount)/hr"
            }
            cell.cat_amount.layer.borderWidth = 1.0
            cell.cat_amount.layer.borderColor = UIColor.init(red:40.0/255.0, green: 186.0/255.0, blue: 225.0/255.0, alpha: 1.0).cgColor
            
            cell.selectionStyle=UITableViewCell.SelectionStyle.none
            cell3=cell
            
        }
        
        return cell3
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        self.categorytable_height.constant = self.categorytable.contentSize.height
        tbl_height.constant = Avialbletable.contentSize.height
        Avialbletable.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == reviewtableview{
            return 120
        }else{
           return 70
        }
    }
    
    func GetReviews(){
        
        let Param: Dictionary = ["provider_id":"\(providerid)",
            
            "page":"\(nextPageStr)" as String,
            "perPage":kPageCount]
        
        url_handler.makeCall(reviewsUrl, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            
            
            self.reviewtableview.dg_stopLoading()
            self.loading = false
            if(error != nil)
            {
                self.view.makeToast(message: kErrorMsg, duration: 3, position: HRToastActivityPositionDefault as AnyObject, title: Appname)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as? NSString) as NSString
                    
                    if(status == "1")
                    {
                        let Dict:NSDictionary=responseObject.object(forKey: "response") as! NSDictionary
                        if((Dict.object(forKey: "rated_users") as AnyObject).count>0){
                            let  listArr:NSArray=Dict.object(forKey: "rated_users") as! NSArray
                            
                            self.reviewsArray.removeAllObjects()
                            self.messageQueue.isEmpty()
                            
                            for (index, element) in listArr.enumerated() {
                                self.messageQueue.push(stringToPush: (element as! NSDictionary))
                                
                            }
                            repeat {
                                if let message = self.messageQueue.pop() {
                                    let rec = ReviewRecords(name: self.theme.CheckNullValue(message.object(forKey: "user_name") as AnyObject), time: self.theme.CheckNullValue(message.object(forKey: "rating_time") as AnyObject), desc: self.theme.CheckNullValue(message.object(forKey: "comments") as AnyObject), rate:self.theme.CheckNullValue(message.object(forKey: "ratings") as AnyObject), img: self.theme.CheckNullValue(message.object(forKey: "user_image") as AnyObject),ratting:self.theme.CheckNullValue(message.object(forKey: "ratting_image") as AnyObject),jobid :self.theme.CheckNullValue(message.object(forKey: "job_id") as AnyObject))
                                    
                                    self.reviewsArray.add(rec)
                                }
                            }while !self.messageQueue.isEmpty()
                            
                            self.reviewtableview.reloadData()
                            self.nextPageStr=self.nextPageStr+1
                        }else{
                            if(self.nextPageStr>1){
                                self.view.makeToast(message:self.theme.setLang("no_leads"), duration: 3, position: HRToastPositionDefault as AnyObject, title:"\(Appname)")
                            }
                        }
                    }
                    else
                    {
                        
                        //  self.theme.AlertView("\(Appname)", Message:"\(self.theme.CheckNullValue("\(Dict.objectForKey("response"))")!)", ButtonTitle:kOk)
                    }
                }
                else
                {
                    self.view.makeToast(message: kErrorMsg, duration: 3, position: HRToastActivityPositionDefault as AnyObject, title: Appname)
                }
            }
            
        }
        
    }
    let loadingView =  DGElasticPullToRefreshLoadingViewCircle()
    func refreshNewLeads(){
        
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        reviewtableview.dg_addPullToRefreshWithActionHandler({
            self.nextPageStr=1
            self.GetReviews()
            
        }, loadingView: loadingView)
        reviewtableview.dg_setPullToRefreshFillColor(PlumberLightGrayColor)
        reviewtableview.dg_setPullToRefreshBackgroundColor(reviewtableview.backgroundColor!)
    }
    func refreshNewLeadsandLoad(){
        if (!loading) {
            loading = true
            GetReviews()
        }
    }
 }
