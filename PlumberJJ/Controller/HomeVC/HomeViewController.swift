//
//  HomeViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 10/27/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI


class HomeViewController: RootBaseViewController,MFMailComposeViewControllerDelegate,UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate{
    
    
    @IBOutlet var chaticon: UIButton!
    @IBOutlet var availability: UISwitch!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var title_lbl: UILabel!
    
    @IBOutlet weak var myJobsCount: UILabel!
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var GradientView: UIView!
    @IBOutlet weak var inScrollView: UIView!
    @IBOutlet weak var TaskerInfoView: UIView!
    @IBOutlet weak var TaskerImgView: UIView!
    @IBOutlet weak var TaskerImg: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingStarImg: UIImageView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var TaskerName: UILabel!
    @IBOutlet weak var TaskerCategory: UILabel!
    
    @IBOutlet weak var newLeadsView: UIView!
    @IBOutlet weak var lastTasksView: UIView!
    @IBOutlet weak var myJobsView: UIView!
    @IBOutlet weak var todayEarningsVIew: UIView!
    @IBOutlet weak var workLocationLbl: UILabel!
    @IBOutlet weak var workLocationView: UIView!
    @IBOutlet weak var work_location_main: UILabel!
    
    @IBOutlet weak var leads_count_lbl: UILabel!
    @IBOutlet weak var new_leads_lbl: UILabel!
    @IBOutlet weak var my_jobs_lbl: UILabel!
    @IBOutlet weak var last_tasks_lbl: UILabel!
    @IBOutlet weak var last_tasks_display_lbl: UILabel!
    @IBOutlet weak var last_task_hrs_lbl: UILabel!
    @IBOutlet weak var today_earning_lbl: UILabel!
    @IBOutlet weak var today_tasks_display_lbl: UILabel!
    @IBOutlet weak var today_tasks_hrs_display_lbl: UILabel!
    @IBOutlet weak var radius_lbl: UILabel!
    @IBOutlet weak var last_task_earning: UILabel!
    @IBOutlet weak var today_earnings_lbl: UILabel!
    @IBOutlet weak var HomepageScrollview: UIScrollView!
    @IBOutlet weak var verifiedLblView: UIView!
    @IBOutlet weak var AccountVerified_Lbl: UILabel!
    @IBOutlet weak var Verified_Lblview_Height: NSLayoutConstraint!
    
    
    @IBOutlet var ShadowViews: [UIView]!
    
    var lat:String = ""
    var lon:String = ""
    var available_status : String = ""
    var themes:Theme = Theme()
    var collectionviewheight : CGFloat = 0.0
    var CellHeight : CGFloat = 0.0
    var TodayDate : String = ""
    var CategoryArray = [Any]()
    let objHomePageRec = HomePageRec()
    var refreshControl = UIRefreshControl()
    
    let ShortCutImages = ["MyOrders","myjobs","MyStatistics","MySupport"]
    
    let ShortCutTitle = [Language_handler.VJLocalizedString("new_leads", comment: nil),Language_handler.VJLocalizedString("my_jobs", comment: nil), Language_handler.VJLocalizedString("statistics", comment: nil),Language_handler.VJLocalizedString("support", comment: nil)]
    
    @IBAction func didClickChatBtn(_ sender: AnyObject) {
        let objChatVc = self.storyboard!.instantiateViewController(withIdentifier: "ChatListVcSID") as! ChatListViewController
        self.navigationController!.pushViewController(withFade: objChatVc, animated : false)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["\(GetReceipientMail)"])
        mailComposerVC.setSubject(appNameJJ)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func showSendMailErrorAlert() {
        
        self.theme.AlertView(Language_handler.VJLocalizedString("not_send_email_title", comment: nil), Message: Language_handler.VJLocalizedString("not_send_email", comment: nil), ButtonTitle: kOk)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("The Current Device is ===>!\(UIDevice.current.modelName)")
        
        if self.theme.yesTheDeviceisHavingNotch() {
            HeaderViewHeight.constant=100
        }
        self.GetHomePage()
        self.UpdateAvailabilityStatus()
        EnableAvailablity(Status: self.theme.CheckNullValue(self.theme.getVerifiedStatus()))
        self.getExpireDocStatus()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setShadows()
        self.setGradient()
    }
    @IBAction func btnEditProfileAction(_ sender : AnyObject)
    {
        let myViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "EditProfileVCSID") as? EditProfileViewController
        //        myViewController!.availabilityStorage = self.AvailableAllDaysArray
//        myViewController!.AvailablityArray = self.ObjAvailArray
//        myViewController?.delegate = self
        self.navigationController?.pushViewController(withFade: myViewController!, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.changeAccountStatus(_:)), name:NSNotification.Name(rawValue: "AccountStatusChanged"), object: nil)
//        
//        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.curveEaseInOut, .repeat], animations: {
//            self.newLeadsView.frame = CGRect(x: self.newLeadsView.frame.origin.x - 15, y: self.newLeadsView.frame.origin.y - 15, width: self.newLeadsView.frame.width + 15, height: self.newLeadsView.frame.height + 15)
//        }) { _ in
//            self.newLeadsView.frame = CGRect(x: self.newLeadsView.frame.origin.x + 15, y: self.newLeadsView.frame.origin.y + 15, width: self.newLeadsView.frame.width - 15, height: self.newLeadsView.frame.height - 15)
//        }
        
        Verified_Lblview_Height.constant = 0
        self.inScrollView.isHidden = true
        self.showProgress()
        self.GetCurrentDate()

        self.title_lbl.text=Language_handler.VJLocalizedString( (ProductShortAppName), comment: nil)
        
//        menuButton.addTarget(self, action: #selector(HomeViewController.openmenu), for: .touchUpInside)
       
        self.TaskerCategory.textColor = PlumberThemeColor
        self.lastTasksView.backgroundColor = LastTasksColor
        self.ratingView.backgroundColor = PlumberThemeColor
        self.ratingView.layer.cornerRadius = self.ratingView.frame.height/2
        self.TaskerImg.image = UIImage(named: "MenuProfile")
        self.TaskerImg.layer.cornerRadius = self.TaskerImgView.frame.width/2
        self.TaskerImgView.layer.cornerRadius = self.TaskerImgView.frame.width/2
        self.TaskerImgView.layer.borderColor = PlumberThemeColor.cgColor
        self.TaskerImgView.layer.borderWidth = 1.5
        self.new_leads_lbl.text = self.theme.setLang("new_leads")
        self.my_jobs_lbl.text = self.theme.setLang("My_jobs")
        self.last_tasks_lbl.text = self.theme.setLang("Last_tasks")
        self.today_earning_lbl.text = self.theme.setLang("today_earning")
        self.AccountVerified_Lbl.text = self.theme.setLang("Acc_Not_Verified")
        self.theme.PulsateAnimation(self.verifiedLblView)
        refreshControl.attributedTitle = NSAttributedString(string: self.theme.setLang("pull_to_refresh"))
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        HomepageScrollview.addSubview(refreshControl)
        
        let Tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.CategoryTap))
        self.TaskerCategory.isUserInteractionEnabled = true
        self.TaskerCategory.addGestureRecognizer(Tapgesture)
    }
    @IBAction func btnMenuAction(_ sender : AnyObject)
    {
//        if themes.getEmailID() != ""
//        {
            self.findHamburguerViewController()?.showMenuViewController()
//        }
//        else
//        {
//            btnLogin.startLoadingAnimation(withloader: false)
//            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "signinVCID")
//        }

    }
    @objc func CategoryTap(sender: UITapGestureRecognizer){
        print("Tap Recognised ===> sucessfully")
    }
    
    @objc func changeAccountStatus(_ notification : Notification){
        guard let Data = notification.userInfo else {
            return // or throw
        }
        let StatusKey = self.theme.CheckNullValue(Data["Key"])
        if StatusKey == "1"{
            Verified_Lblview_Height.constant = 0
            self.theme.saveVerifiedStatus(VerifiedStatus: 1)
        }else{
            Verified_Lblview_Height.constant = 30
            self.theme.saveVerifiedStatus(VerifiedStatus: 0)
        }
        EnableAvailablity(Status: self.theme.CheckNullValue(self.theme.getVerifiedStatus()))
    }
    
    @objc func ShowVerified(){
        Verified_Lblview_Height.constant = 0
    }
    
    @objc func refresh() {
        self.GetHomePage()
        EnableAvailablity(Status: self.theme.CheckNullValue(self.theme.getVerifiedStatus()))
        // Code to refresh table view
        refreshControl.endRefreshing()
    }
    
   func GetCurrentDate(){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        print(formattedDate)
        TodayDate = formattedDate
    }
    
    func setShadows(){
        for SingleView in self.ShadowViews{
            SingleView.layer.cornerRadius = 10
//            SingleView.layer.masksToBounds = true
            SingleView.dropShadow(shadowRadius: 10)
        }
    }
    
    func setGradient(){
        self.theme.addGradient(self.myJobsView, colo1: lightorangecolor, colo2: darkorangecolor, direction: .ToptoBottom, Frame: CGRect(x: 0, y: 0, width: self.myJobsView.frame.width, height: self.myJobsView.frame.height), CornerRadius: true, Radius: 10)
        self.theme.addGradient(self.GradientView, colo1: .white, colo2: PlumberBottomGradient, direction: .ToptoBottom, Frame: CGRect(x: 0, y: 0, width: UIDevice.current.screenWidth, height: UIDevice.current.screenHeight), CornerRadius: false, Radius: 0)
    }
    
    @objc func openmenu(){
//        self.view.endEditing(true)
//        self.frostedViewController.view.endEditing(true)

        // Present the view controller
//        self.frostedViewController.presentMenuViewController()
//        self.findHamburguerViewController()?.showMenuViewController()
        
    }
    
    func GetHomePage(){
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)","task_date":TodayDate]
        url_handler.makeCall(HomePageDatas, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.theme.CheckNullValue(responseObject["status"])
                    if(status == "1") || (status == "2") || (status == "3")
                    {
                        if self.theme.getVerifiedStatus() == 0{
                            self.Verified_Lblview_Height.constant = 30
                        }else{
                            self.Verified_Lblview_Height.constant = 0
                        }
                        let Response = responseObject["response"] as? [String:Any] ?? [:]
                        let uploadStatus = self.theme.CheckNullValue(Response["document_upload_status"])
                        self.theme.saveDocumentStatus(uploadStatus)
                        print("The Home Page Document Status is --->\(self.themes.getDocumentStatus())")
                        self.objHomePageRec.tasker_name = self.theme.CheckNullValue(Response["username"])
                        self.theme.saveFullName(UserName: self.objHomePageRec.tasker_name)
                        self.objHomePageRec.tasker_img = self.theme.CheckNullValue(Response["image"])
                        UserDefaults.standard.set(self.objHomePageRec.tasker_img, forKey: "userDP")
                        UserDefaults.standard.synchronize()
                        
                        self.objHomePageRec.work_location = self.themes.CheckNullValue(Response["Working_location"])
                        self.objHomePageRec.distance_unit = self.theme.CheckNullValue(Response["distanceby"])
                        self.objHomePageRec.radius = self.themes.CheckNullValue(Response["radius"])
                        let myFloat = (Response["avg_review"] as! NSString).floatValue
                        let formatter : NSString = NSString(format: "%.01f", myFloat)
                        if formatter == "0.0"{
                            self.objHomePageRec.average_review = "0"
                        }else{
                            self.objHomePageRec.average_review = formatter as String
                        }
                        self.objHomePageRec.new_leads = self.theme.CheckNullValue(Response["newleads"])
                        
                        let Category_details = Response["category_Details"] as? [Any] ?? []
                        var tempCat = [String]()
                        self.CategoryArray.removeAll()
                        for category in Category_details {
                            let category = category as? [String:Any] ?? [:]
                            let objcategory = categories()
                            let _id = category["_id"] as! String
                            if  !tempCat.contains(_id){
                                tempCat.append(_id)
                                objcategory.id = self.theme.CheckNullValue(category["_id"])
                                objcategory.category_name = self.theme.CheckNullValue(category["categoryname"])
                                self.CategoryArray.append(objcategory)
                            }
                        }
                        self.objHomePageRec.category_details  = self.CategoryArray as! [categories]
                        
                        let CurrencyDict = Response["currency"] as? [String:Any] ?? [:]
                            let objCurrency = currency()
                            objCurrency.code = self.theme.CheckNullValue(CurrencyDict["code"])
                            objCurrency.symbole = self.theme.CheckNullValue(CurrencyDict["symbol"])
                        self.objHomePageRec.currency_details = objCurrency
                        
                        let tasksDetails = Response["taskdetails"] as? [String:Any] ?? [:]
                            let objTasksDetails = tasks()
                        let lasttask_earnings = self.theme.CheckNullValue(tasksDetails["last_task_earning"])
                        let lasttask_hours = self.theme.CheckNullValue(tasksDetails["last_task_hours"])
                        let lasttask_starttime = self.theme.CheckNullValue(tasksDetails["last_task_starttime"])
                        let task_count = self.theme.CheckNullValue(tasksDetails["task_count"])
                        let task_earnings = self.theme.CheckNullValue(tasksDetails["task_earnings"])
                        let task_hours = self.theme.CheckNullValue(tasksDetails["task_hours"])
                        let JobsCompletedCount = self.theme.CheckNullValue(Response["completed_count"])
                        
                        objTasksDetails.JobsCount = JobsCompletedCount == "" ? "00":JobsCompletedCount
                        objTasksDetails.lasttask_earnings = lasttask_earnings == "" ? "00.00":lasttask_earnings
                        objTasksDetails.lasttask_hours = lasttask_hours == "" ? "0h 0m 0s" : lasttask_hours
                        objTasksDetails.lasttask_starttime = lasttask_starttime == "" ? "@00:00":lasttask_starttime
                        objTasksDetails.task_count = task_count == "" ? "0" : task_count
                        objTasksDetails.task_earnings = task_earnings == "" ? "00.00" : task_earnings
                        objTasksDetails.task_hours = task_hours == "" ? "0.0" : task_hours
                        self.objHomePageRec.tasks_details = objTasksDetails
                        
                        self.SetHomePageDatas()
                    }else{
                        
                        
                    }
                }else {
                }
            }
        }
    }
    
    //MARK :- SetupHopageDatas
    
    func SetHomePageDatas(){
        self.TaskerName.text = self.objHomePageRec.tasker_name
        
        let imgstr = self.objHomePageRec.tasker_img
        self.TaskerImg.sd_setImage(with: URL(string: imgstr), placeholderImage: UIImage(named: "PlaceHolderSmall"))
        self.ratingLbl.text = self.objHomePageRec.average_review
        self.work_location_main.text = self.objHomePageRec.work_location
        self.radius_lbl.text = "\(self.objHomePageRec.radius)\(" ")\(self.objHomePageRec.distance_unit)\(" ")\(self.theme.setLang("radius"))"
        self.leads_count_lbl.text = self.objHomePageRec.new_leads
        
        let catShowArray = self.objHomePageRec.category_details.map{($0.category_name)}
       /* if catShowArray.count >= 1{
            let CombinedStrs = catShowArray.joined(separator: " / ")
            self.TaskerCategory.text = CombinedStrs
        }else*/ if catShowArray.count>2{
            let AtributeArray = NSMutableAttributedString()
//            let CombinedStrs = catShowArray.joined(separator: " / ")
            let CombinedStrs = "\(catShowArray[0])/\(catShowArray[1])"
            let CatAttribute = [NSAttributedString.Key.font:UIFont(name: plumberMediumFontStr, size: 17) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor:PlumberThemeColor ] as [NSAttributedString.Key : Any]
            let CategoryAttrStr = NSAttributedString(string: CombinedStrs, attributes: CatAttribute)
            AtributeArray.append(CategoryAttrStr)
            let AdditionWords = "+\(catShowArray.count-2)\(self.theme.setLang("more"))"
            let AdditionalAttribute = [NSAttributedString.Key.font: UIFont(name: plumberMediumFontStr, size: 12) ?? UIFont.systemFont(ofSize: 12) , NSAttributedString.Key.foregroundColor: UIColor.gray , NSAttributedString.Key.baselineOffset: -1] as [NSAttributedString.Key : Any]
            let AdditionalAttrStr = NSAttributedString(string: AdditionWords, attributes: AdditionalAttribute)
            AtributeArray.append(AdditionalAttrStr)
            self.TaskerCategory.attributedText = AtributeArray
        }else if (catShowArray.count<3) && (catShowArray.count>1){
            let CombinedStrs = "\(catShowArray[0])/\(catShowArray[1])"
            self.TaskerCategory.text = CombinedStrs
        }
        else{
            self.TaskerCategory.text = catShowArray.joined(separator: "")
        }
        
        let objTasksDetails = objHomePageRec.tasks_details
        let objCurrency = objHomePageRec.currency_details
        
        self.last_task_earning.attributedText = setfontForPrice(with: objCurrency.symbole, objTasksDetails.lasttask_earnings, using: .white)
        self.myJobsCount.text = objTasksDetails.JobsCount
        self.myJobsCount.textColor = .white
        self.last_task_earning.adjustsFontSizeToFitWidth = true
        self.today_earnings_lbl.attributedText = setfontForPrice(with: objCurrency.symbole, objTasksDetails.task_earnings, using: .gray, currencyColor: PlumberThemeColor)
        self.today_earnings_lbl.adjustsFontSizeToFitWidth = true
        let last_task_hrs_Split = objTasksDetails.lasttask_hours.replacingOccurrences(of: " ", with: ":")
        self.last_task_hrs_lbl.text = last_task_hrs_Split
        self.last_task_hrs_lbl.adjustsFontSizeToFitWidth = true
        self.last_tasks_display_lbl.text = objTasksDetails.lasttask_starttime
        self.today_tasks_display_lbl.text = "\(objTasksDetails.task_count)\(" ")\(self.theme.setLang("tasks"))"
        let splittime = objTasksDetails.task_hours.components(separatedBy: ".")
        
        var HrsVal = ""
        var MinsVal = ""
        
        for (i,time) in splittime.enumerated(){
            i == 0 ? (HrsVal = "\(time)h") : (MinsVal = "\(time)m")
        }
        
        self.today_tasks_hrs_display_lbl.text = "\(HrsVal):\(MinsVal)"/*objTasksDetails.task_hours*/
        self.inScrollView.isHidden = false
        self.DismissProgress()
    }
    
    private func setfontForPrice(with currency:String, _ amount:String, using baseColor:UIColor, currencyColor:UIColor? = nil) -> NSAttributedString{
        
        let localAmounts = amount.components(separatedBy: ".")
        var currencyAttribute = [NSAttributedString.Key.baselineOffset: 10,
                                 NSAttributedString.Key.font: UIFont(name: plumberMediumFontStr, size: 25) ?? UIFont.systemFont(ofSize: 25)] as [NSAttributedString.Key : Any]
        if let color = currencyColor{
            currencyAttribute[NSAttributedString.Key.foregroundColor] = color
        }else{
            currencyAttribute[NSAttributedString.Key.foregroundColor] = baseColor
        }
        let decimalAttribute = [NSAttributedString.Key.font: UIFont(name: plumberMediumFontStr, size: 15) ?? UIFont.systemFont(ofSize: 15),
                                NSAttributedString.Key.foregroundColor : baseColor] as [NSAttributedString.Key : Any]
        let normalAttribute = [NSAttributedString.Key.font: UIFont(name: plumberMediumFontStr, size: 30) ?? UIFont.systemFont(ofSize: 30),
                               NSAttributedString.Key.foregroundColor : baseColor] as [NSAttributedString.Key : Any]
        let mutableAttributedString = NSMutableAttributedString()
        let currencyAttributedStr = NSAttributedString(string: currency, attributes: currencyAttribute)
        mutableAttributedString.append(currencyAttributedStr)
        guard localAmounts.count > 0 else{return mutableAttributedString}
        let amountAttributedStr = NSAttributedString(string: localAmounts[0], attributes: normalAttribute)
        mutableAttributedString.append(amountAttributedStr)
        guard localAmounts.count > 1 else{return mutableAttributedString}
        let CombinedStr = ".\(localAmounts[1])"
        let decimalAttributedStr = NSAttributedString(string: CombinedStr, attributes: decimalAttribute)
        mutableAttributedString.append(decimalAttributedStr)
        return  mutableAttributedString
    }
    
    func UpdateAvailabilityStatus(){
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)"]
        
        url_handler.makeCall(GettingAvailablty, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.theme.CheckNullValue(responseObject["status"])
                    let CheckAvailability=self.theme.CheckNullValue(responseObject["availability"])
                    if(status == "1")
                    {
                      if self.theme.getVerifiedStatus() == 1{
                            if CheckAvailability ==  "1"
                            {
                                self.availability.setOn(true, animated: true)
                            }
                            else
                            {
                                self.availability.setOn(false, animated: true)
                            }
                        }else{
                            self.availability.setOn(false, animated: true)
                        self.theme.AlertView(ProductAppName, Message: Language_handler.VJLocalizedString("Acc_Not_Verified", comment: nil), ButtonTitle: kOk)
                        }
                    }
                    else
                    {
                        
                    }
                }
            }
        }
    }
    
    func EnableAvailablity(Status : String){
        showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["tasker":"\(objUserRecs.providerId)","availability" : Status]
        url_handler.makeCall(EnableAvailabilty, param: Param as NSDictionary) {
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
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.theme.CheckNullValue(responseObject["status"])
                    if(status == "1") //Verified
                    {
                        let resDict = responseObject["response"] as! [String:Any]
                        let _ : String = self.theme.CheckNullValue(resDict["tasker_status"])
                        
                            self.theme.saveVerifiedStatus(VerifiedStatus: 1)
                            self.Verified_Lblview_Height.constant = 0
                        
                    }else if (status == "3") || (status == "2"){//Not Verified
                        
                        self.theme.saveVerifiedStatus(VerifiedStatus: 0)
                        self.Verified_Lblview_Height.constant = 30
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
            }
        }
    }
    
    
    func upDateLocation(){
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                                 "latitude":"\(lat)",
                                 "longitude":"\(lon)"]
        // print(Param)
        
        url_handler.makeCall(updateProviderLocation, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status = self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    if(status == "1")
                    {
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
    
    @IBAction func didclicknewLeads(_ sender: Any) {
        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "NewLeadsVCSID") as! NewLeadsViewController
        self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
    }
    
    
    @IBAction func didclickmyJobs(_ sender: Any) {
        let objMyJobsVc = self.storyboard!.instantiateViewController(withIdentifier: "MyJobsVCSID") as! MyJobsViewController
        self.navigationController!.pushViewController(withFade: objMyJobsVc, animated: false)
    }
    
    @IBAction func didclickEarningsBtn(_ sender: Any) {
        let NewEarningsVc = self.storyboard!.instantiateViewController(withIdentifier: "NewEarningsVCID") as! NewEarningsViewController
        NewEarningsVc.isFromHomePage = true
        self.navigationController!.pushViewController(withFade: NewEarningsVc, animated: false)
    }
    
    
    @IBAction func didclickAvailablityStatus(_ sender: UISwitch) {
        
        if sender.isOn {
            available_status = "1"
        } else {
            available_status = "0"
        }
        showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["tasker":"\(objUserRecs.providerId)","availability" :available_status]
        // print(Param)
        
        url_handler.makeCall(EnableAvailabilty, param: Param as NSDictionary) {
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
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.theme.CheckNullValue(responseObject["status"])
                    if(status == "1") //Verified
                    {
                        self.theme.saveVerifiedStatus(VerifiedStatus: 1)
                        let resDict = responseObject["response"] as! [String:Any]
                        let tasker_status : String = self.theme.CheckNullValue(resDict["tasker_status"])
                        
                        if (tasker_status == "1")
                        {
                            self.view.makeToast(message:"Your availability is ON", duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                            
                            self.availability.isOn = true
                            self.theme.saveAvailable_satus("GO OFFLINE")
                        }
                        else
                        {self.availability.isOn = false
                            self.view.makeToast(message:"Your availability is OFF", duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                            self.theme.saveAvailable_satus("GO ONLINE")
                        }
                    }else if (status == "3") || (status == "2"){//Not Verified
                        self.availability.setOn(false, animated: true)
                        self.theme.AlertView(ProductAppName, Message: Language_handler.VJLocalizedString("Acc_Not_Verified", comment: nil), ButtonTitle: kOk)
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
            }
        }
    }
    
    @IBAction func didclickavailability(_ sender: UIButton) {
        
        if  sender.titleLabel?.text == "GO ONLINE"
        {
            available_status = "1"
        }
        else
        {
            available_status = "0"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension HomeViewController
{
    //MARK: - On appear Check expire doc API Function
    func getExpireDocStatus() {
        
        self.theme.showProgress(View: self.view)
        let Param: Dictionary = ["expiry_date":Date().currentTimeMillis()]
        url_handler.makeCall(checkExpireDocumentsId, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            self.theme.DismissProgress()
            if (error != nil) {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
            } else {

                debugPrint("responseObject in get expire \(responseObject) \(error)")
                self.theme.DismissProgress()

            }
        }
        
        /*
        self.theme.showProgress(View: self.view)
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)"]
        url_handler.makeCall(viewProfile, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            self.theme.DismissProgress()
            if (error != nil) {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
            } else {
                if (responseObject != nil && (responseObject?.count)!>0) {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status = self.theme.CheckNullValue(responseObject["status"])
                    let Rasponse = responseObject["response"] as? [String:Any] ?? [:]
                    if (status == "1") || (status == "3") {
                        self.siteUrl = "\(MainUrl)/"
                        print("SiteUrl is \(self.siteUrl)")
                    
                        let DocumentStatus = self.theme.CheckNullValue(Rasponse["document_upload_status"])
                        self.theme.saveDocumentStatus(DocumentStatus)
                        if DocumentStatus == "1"{
                            let documentArray = Rasponse["documents"] as? [Any] ?? []
                            
                            for documentDetails in documentArray {
                                let documents = DocumentsList()
                                let documentDetails = documentDetails as? [String:Any] ?? [:]
                                documents.name = self.theme.CheckNullValue(documentDetails["name"])
                                documents.path = self.theme.CheckNullValue(documentDetails["path"])
                                documents.file_type = self.theme.CheckNullValue(documentDetails["file_type"])
                                if let dicexpiry_date = documentDetails["expiry_date"] as? NSDictionary
                                {
                                    if let date = dicexpiry_date["date"] as? NSNumber
                                    {
                                        if let month = dicexpiry_date["month"] as? NSNumber
                                        {
                                            if let year = dicexpiry_date["year"] as? NSNumber
                                            {
                                                documents.expireyDate = ("\(month)") + "-" + ("\(date)") + "-" + ("\(year)")
                                            }
                                        }
                                    }
                                }
                                
                                self.documentsArray.append(documents)
                            }
                            self.documentsTable.reloadData()
                        }else{
                            self.theme.AlertView(ProductAppName, Message: self.theme.setLang("cant_view_doc"), ButtonTitle: kOk)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.setInitialViewcontroller()
                        }
                    } else {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
                    }
                }
            }
        }
        
        */
    }
}
