//
//  MyOrderOpenDetailViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 10/29/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit
import MessageUI

class timelineRec: NSObject {
    var date:String = ""
    var time:String = ""
    var title:String = ""
    var check:String = ""
}

class invoiceRec : NSObject
{
    var amount : String = ""
    var dt :String = ""
    var title : String = ""
    
}

protocol MyOrderOpenDetailViewControllerDelegate {
    func  passRequiredParametres(_ fromdate:NSString,todate: NSString,isAscendorDescend: Int,isSortby: NSString)
}

class MyOrderOpenDetailViewController: RootBaseViewController,GMSMapViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,MiscellaneousVCDelegate,UIViewControllerTransitioningDelegate,RefreshViewcontrollerDelegate{
    
    
    var delegate:MyOrderOpenDetailViewControllerDelegate?
    var LocationTimer:Timer=Timer()
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var workFlowBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var jobCancelLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var date_time_HeaderLbl: UILabel!
    @IBOutlet weak var date_timeLbl: UILabel!
    @IBOutlet weak var location_headerLbl: UILabel!
    @IBOutlet weak var jobStatus_VIew: UIView!
    @IBOutlet weak var JobStatus_Img: UIImageView!
    @IBOutlet weak var JobStatus_Lbl: UILabel!
    @IBOutlet weak var TimeLineMainView: UIView!
    @IBOutlet weak var TimeLineTableView: UITableView!
    @IBOutlet weak var TasksHeader_Lbl: UILabel!
    @IBOutlet weak var PaymentView: UIView!
    @IBOutlet weak var paymentHeader_Lbl: UILabel!
    @IBOutlet weak var PaymentTableView: UITableView!
    @IBOutlet weak var PaymentSeperatorView: UIView!
    @IBOutlet weak var JobCancelView: UIView!
    @IBOutlet weak var SingleButtonView: UIView!
    @IBOutlet weak var RejectView: UIView!
    @IBOutlet weak var AcceptView: UIView!
    @IBOutlet weak var BottomStackView: UIStackView!
    
    @IBOutlet weak var CallView: UIView!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var MessageView: UIView!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var MailView: UIView!
    @IBOutlet weak var mailBtn: UIButton!
    @IBOutlet weak var ChatView: UIView!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var NavigateVew: UIView!
    @IBOutlet weak var navigateBtn: UIButton!
    @IBOutlet weak var OptionsView: UIView!
    @IBOutlet weak var Call_Img: UIImageView!
    @IBOutlet weak var Call_Lbl: UILabel!
    @IBOutlet weak var Chat_Img: UIImageView!
    @IBOutlet weak var Chat_Lbl: UILabel!
    @IBOutlet weak var Mail_Img: UIImageView!
    @IBOutlet weak var Mail_Lbl: UILabel!
    @IBOutlet weak var Sms_Img: UIImageView!
    @IBOutlet weak var Sms_Lbl: UILabel!
    @IBOutlet weak var InstructionHeaderLbl: UILabel!
    @IBOutlet weak var InstructionLbl: UILabel!
    @IBOutlet weak var Navigate_Img: UIImageView!
    @IBOutlet weak var Navigate_Lbl: UILabel!
    @IBOutlet weak var loading_view: UIView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var InstructionView: UIView!
    
    @IBOutlet weak var InstructionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var optionsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var PaymentViewHeight: NSLayoutConstraint!
    
    var fullAddress : String = String()
    var CancelReasonArr:NSMutableArray=[]
    var CancelTitleArr:NSMutableArray=[]
    var objDetailRec:JobDetailRecord=JobDetailRecord()
    var tField: UITextField!
    var myMaterialView:MiscellaneousVC=MiscellaneousVC()
    var TimelineArr = [timelineRec]()
    var faresummaryArr = [invoiceRec]()
    var isFromPushNotification : Bool = false
    
    // var theme:Theme=Theme()
    var jobID:String = ""
    var Getorderstatus : String = ""
    var reasonIdStr:String = ""
    var isJobCompleted = Bool()
    
    @IBOutlet weak var singleBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var jobIdLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.theme.yesTheDeviceisHavingNotch(){
            HeaderViewHeight.constant = 100
            optionsViewHeight.constant = optionsViewHeight.constant + 20
        }
        self.HeaderView.dropShadow(shadowRadius: 10)
        self.loading_view.isHidden = false
         self.loadDetail()
        self.setOptionsView()
        bottomView.isHidden=true
        detailScrollView.isHidden=true
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyOrderOpenDetailViewController.methodOfReceivedNotificationNetworkDetail(_:)), name:NSNotification.Name(rawValue: kJobCancelNotif), object: nil)
        
        TimeLineTableView.register(UINib(nibName:"timelinetreeTableViewCell", bundle: nil), forCellReuseIdentifier: "timeline")
        TimeLineTableView.rowHeight = UITableView.automaticDimension
        TimeLineTableView.estimatedRowHeight = 120
        
        PaymentTableView.register(UINib(nibName:"invoicelistTableViewCell", bundle: nil), forCellReuseIdentifier: "invoice")
        PaymentTableView.rowHeight = UITableView.automaticDimension
        PaymentTableView.estimatedRowHeight = 90
        
        self.SetBottomBtns()
        
        if isFromPushNotification == true{
            let objFarevc = self.storyboard!.instantiateViewController(withIdentifier: "RatingsVCSID") as! RatingsViewController
            objFarevc.jobIDStr = jobID
            //            self.navigationController!.pushViewController(withFade: objFarevc, animated: false)
            add(objFarevc)
        }
        // Do any additional setup after loading the view.
    }
    
    func setOptionsView(){
        self.Call_Img.image = UIImage(named: "call_Img")
        self.Call_Img.tintColor = UIColor(red: 256/255.0, green: 206/255.0, blue: 74/255.0, alpha: 1)
        self.Call_Lbl.text = self.theme.setLang("call")
        self.Chat_Img.image = UIImage(named: "ChatImg")
        self.Chat_Img.tintColor = .green
        self.Chat_Lbl.text = self.theme.setLang("chat")
        self.Mail_Img.image = UIImage(named: "Mail_Img")
        self.Mail_Img.tintColor = .red
        self.Mail_Lbl.text = self.theme.setLang("mail")
        self.Sms_Img.image = UIImage(named: "Sms_Img")
        self.Sms_Img.tintColor = .blue
        self.Sms_Lbl.text = self.theme.setLang("sms")
        self.Navigate_Img.image = UIImage(named: "Navigate_Img")
        self.Navigate_Img.tintColor = .red
        self.Navigate_Lbl.text = self.theme.setLang("navigate")
    }
 
    func SetBottomBtns(){
        self.RejectView.layer.borderWidth = 1.0
        self.RejectView.layer.borderColor = UIColor.black.cgColor
        self.rejectBtn.setTitleColor(.black, for: .normal)
        self.RejectView.layer.cornerRadius = self.RejectView.frame.height/2
        
        self.acceptBtn.setTitleColor(.white, for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        removeSublayer(self.AcceptView , layerName: "Gradient")
        self.theme.addGradient(self.AcceptView, colo1: lightorangecolor, colo2: darkorangecolor, direction: .LefttoRight, Frame: CGRect(x: 0, y: 0, width: self.AcceptView.frame.width, height: self.AcceptView.frame.height), CornerRadius: true, Radius: self.AcceptView.frame.height/2)
    }
    
    func showSendMailErrorAlert() {
        self.view.makeToast(message:Language_handler.VJLocalizedString("not_send_email", comment: nil), duration: 3, position: HRToastPositionDefault as AnyObject, title: Language_handler.VJLocalizedString("not_send_email_title", comment: nil))
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["\(self.objDetailRec.jobEmail)"])
        mailComposerVC.setSubject("\(self.objDetailRec.jobTitle)")
        return mailComposerVC
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    func configuredMessageComposeViewController(_ message:String,number:String) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        
        //  Make sure to set this property to self, so that the controller can be dismissed!
        //        messageComposeVC.recipients = textMessageRecipients
        messageComposeVC.body = "\(message)"
        messageComposeVC.recipients = [number]
        
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    @objc func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @objc func methodOfReceivedNotificationNetworkDetail(_ notification: Notification){
        loadDetail()
    }
    
    func RefreshPage() {
        loadDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    func loadDetail(){
        self.loading_view.isHidden = false
        self.showProgress()
        GetJobDetails()
    }
    
    func setDatasForDescription(){
        
        date_time_HeaderLbl.numberOfLines=0
        date_time_HeaderLbl.sizeToFit()
        location_headerLbl.numberOfLines=0
        location_headerLbl.sizeToFit()
        addressLbl.numberOfLines=0
        addressLbl.sizeToFit()
        
        if objDetailRec.Cancelreason == ""
        {
            
        }
        else{
            
        }
    }
    func GetJobDetails(){
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
            "job_id":"\(jobID)"]
        print(jobID)
        url_handler.makeCall(JobDetailUrl, param: Param as NSDictionary) {
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
                    if(status == "1")
                    {
                        self.detailScrollView.isHidden=false
                        self.bottomView.isHidden=false
                        let Response = responseObject["response"] as? [String:Any] ?? [:]
                        let JobDict = Response["job"] as? [String:Any] ?? [:]
                        if(JobDict.count>0){
                            self.objDetailRec.jobIdentity=self.theme.CheckNullValue(JobDict["task_id"])
                            
                            self.objDetailRec.Currency=self.theme.CheckNullValue(JobDict["currency"])
                            self.objDetailRec.JobID=self.theme.CheckNullValue(JobDict["job_id"])
                            self.objDetailRec.Submit_rating = self.theme.CheckNullValue(JobDict["submit_ratings"])
                            self.objDetailRec.jobDate=self.theme.CheckNullValue(JobDict["job_date"])
                            self.objDetailRec.jobTime=self.theme.CheckNullValue(JobDict["job_time"])
                            self.objDetailRec.jobTitle=self.theme.CheckNullValue(JobDict["job_type"])
                            self.objDetailRec.jobStatusStr=self.theme.CheckNullValue(JobDict["status"])
                            self.objDetailRec.jobDesc=self.theme.CheckNullValue(JobDict["instruction"])
                            self.objDetailRec.jobStatus=self.theme.CheckNullValue(JobDict["btn_group"])
                            self.objDetailRec.Cancelreason = self.theme.CheckNullValue(JobDict["cancelreason"])
                            self.objDetailRec.Userid = self.theme.CheckNullValue(JobDict["user_id"])
                            self.objDetailRec.RequireJobId = self.theme.CheckNullValue(self.jobID as AnyObject)
                            self.objDetailRec.jobUserName=self.theme.CheckNullValue(JobDict["user_name"])
                            self.objDetailRec.currency_symbol = self.theme.getCurrencyCode(JobDict["currency_code"] as! String)
                            self.objDetailRec.jobEmail=self.theme.CheckNullValue(JobDict["user_email"])
                            self.objDetailRec.jobPhone=self.theme.CheckNullValue(JobDict["user_mobile"])
                            self.objDetailRec.jobLat=self.theme.CheckNullValue(JobDict["location_lat"])
                            self.objDetailRec.userimage = self.theme.CheckNullValue(JobDict["user_image"])
                            //CurLaat = self.objDetailRec.job
                            self.objDetailRec.jobLong=self.theme.CheckNullValue(JobDict["location_lon"])
                            let exactaddress = self.theme.CheckNullValue(JobDict["service_address"])
                            var location : String = String()
                            if exactaddress != ""
                            {
                                location = exactaddress
                            }
                            else
                            {
                                location = self.theme.CheckNullValue(self.theme.getAddressForLatLng(self.objDetailRec.jobLat, longitude: self.objDetailRec.jobLong, status: "short") as AnyObject)
                            }
                            self.objDetailRec.jobLocation=location
                            self.objDetailRec.jobBtnStatus = self.theme.CheckNullValue(JobDict["btn_group"])
                            
                            self.objDetailRec.job_Status=self.theme.CheckNullValue(JobDict["job_status"])
                            self.objDetailRec.cashoption = self.theme.CheckNullValue(JobDict["cash_option"])
                            
                            self.TimelineArr.removeAll()
                            
                            let timeline = Response["timeline"] as! [[String : Any]]
                            for element in timeline
                            {
                                let timeRec = timelineRec()
                                timeRec.date =  self.theme.CheckNullValue(element["date"])
                                timeRec.time =  self.theme.CheckNullValue(element["time"])
                                timeRec.title =  self.theme.CheckNullValue(element["title"])
                                timeRec.check = self.theme.CheckNullValue(element["check"])
                                if timeRec.check == "1"{
                                    self.TimelineArr.append(timeRec)
                                }
                            }
                            self.TimeLineTableView.reloadData()
                            
                            let billingarr = JobDict["billing"] as? [[String :Any]]
                            self.faresummaryArr.removeAll()
                            for element in billingarr!
                            {
                                let rec = invoiceRec()
                                rec.amount = self.theme.CheckNullValue(element["amount"])
                                rec.dt =  self.theme.CheckNullValue(element["dt"])
                                rec.title =  self.theme.CheckNullValue(element["title"])
                                self.faresummaryArr.append(rec)
                            }
                            
                            self.SetDatasToDetail()
                            
                        }else{
                            self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
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
    func SetDatasToDetail(){
        
        let attrString = NSMutableAttributedString(string: "\(self.objDetailRec.jobTitle) - ",
                                                   attributes: [ NSAttributedString.Key.font: UIFont.init(name: plumberBoldFontStr, size: 17) as Any ])
        
        attrString.append(NSMutableAttributedString(string: self.objDetailRec.JobID,
                                                    attributes: [NSAttributedString.Key.font: UIFont(name: plumberMediumFontStr, size: 12) as Any ]))
        
        self.jobIdLbl.attributedText = attrString
         if self.objDetailRec.jobDesc != "" {
            self.InstructionHeaderLbl.text = self.theme.setLang("order_desc")
            self.InstructionLbl.text = self.objDetailRec.jobDesc
            self.InstructionViewHeight.constant = self.InstructionLbl.intrinsicContentSize.height + 52
            self.InstructionView.isHidden = false
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }else{
            self.InstructionViewHeight.constant = 0
            self.InstructionView.isHidden = true
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        
        self.date_time_HeaderLbl.text = Language_handler.VJLocalizedString("date_time", comment: nil)
        self.date_timeLbl.text = "\(self.objDetailRec.jobDate), \(self.objDetailRec.jobTime)"
        self.location_headerLbl.text = Language_handler.VJLocalizedString("location", comment: nil)
        self.addressLbl.text="\(self.objDetailRec.jobLocation)"
        self.backButton.tintColor = PlumberThemeColor
        self.TasksHeader_Lbl.text = Language_handler.VJLocalizedString("Work_prog", comment: nil)
        setDatasForDescription()
        
        if self.faresummaryArr.count > 0
        {
            self.paymentHeader_Lbl.isHidden = false
            self.PaymentTableView.isHidden = false
            self.PaymentView.isHidden = false
            self.PaymentViewHeight.constant = 1
            self.PaymentTableView.reloadData()
            self.PaymentSeperatorView.isHidden = false
            self.paymentHeader_Lbl.text = self.theme.setLang("Payment")
            self.PaymentViewHeight.constant = self.PaymentTableView.contentSize.height
            self.PaymentTableView.layoutIfNeeded()
            self.PaymentTableView.updateConstraints()
        }
        else
        {
            self.paymentHeader_Lbl.text = ""
            self.paymentHeader_Lbl.isHidden = true
            self.PaymentTableView.isHidden = true
            self.PaymentSeperatorView.isHidden = false
            self.PaymentViewHeight.constant = 0
            
        }
        self.view.updateConstraints()
        self.view.layoutIfNeeded()
        
        setBottomViewWithButton(objDetailRec.jobBtnStatus)
        self.loading_view.isHidden = true
    }
    
    @IBAction func didClickOptions(_ sender: UIButton){
        let ButtonTag = sender.tag
        if ButtonTag == 0 {//call
             if self.isJobCompleted == false{
            self.callNumber(self.objDetailRec.jobPhone as String)
            }
        }else if ButtonTag == 1{//chat
                let objChatVc = self.storyboard!.instantiateViewController(withIdentifier: "ChatVCSID") as! MessageViewController
                objChatVc.jobId=self.objDetailRec.jobIdentity
                objChatVc.Userid = self.objDetailRec.Userid
                objChatVc.username = self.objDetailRec.jobUserName
                objChatVc.Userimg = self.objDetailRec.userimage
                objChatVc.RequiredJobid = self.objDetailRec.jobIdentity
                objChatVc.isJobCompleted = self.isJobCompleted
                self.navigationController!.pushViewController(withFade: objChatVc, animated: false)
            }
        else if ButtonTag == 2 {//mail
            if self.isJobCompleted == false{
                let mailComposeViewController = self.configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            }
        }else if ButtonTag == 3 {//message
            if self.isJobCompleted == false{
                let messageComposeVC = self.configuredMessageComposeViewController("",number:"\(self.objDetailRec.jobPhone)")
                if MFMessageComposeViewController.canSendText() {
                    self.present(messageComposeVC, animated: true, completion: nil)
                }
            }
        }else if ButtonTag == 4 {//navigate
            moveToLocVc(false)
        }
    }
    
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
        self.delegate?.passRequiredParametres("", todate: "", isAscendorDescend: 0, isSortby: "")
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
    func moveToLocVc(_ isShowArriveBtn:Bool){//LocationVCSID
        let ObjLocVc=self.storyboard!.instantiateViewController(withIdentifier: "LocationVCSID")as! LocationViewController
        ObjLocVc.isShowArriveBtn=isShowArriveBtn
        ObjLocVc.jobStatus = self.objDetailRec.jobBtnStatus
        ObjLocVc.mapLaat=Double(objDetailRec.jobLat)!
        ObjLocVc.mapLong=Double(objDetailRec.jobLong)!
        trackingDetail.userLat = Double(objDetailRec.jobLat)!
        trackingDetail.userLong = Double(objDetailRec.jobLong)!
        
        ObjLocVc.addressStr=addressLbl.text!
        ObjLocVc.phoneStr=objDetailRec.jobPhone
        ObjLocVc.getUsername = objDetailRec.jobUserName
        ObjLocVc.jobId=self.objDetailRec.jobIdentity
        ObjLocVc.userId = self.objDetailRec.Userid
        self.navigationController?.pushViewController(withFade: ObjLocVc, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeSublayer(_ view: UIView, layerName name: String) {
        guard let sublayers = view.layer.sublayers else {
            print("The view does not have any sublayers.")
            return
        }
        let layercount = sublayers.count
        for index in 0..<layercount-1 {
            let layer = view.layer.sublayers![index]
            if layer.name == name {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func setBottomViewWithButton(_ statStr:String){
        if(statStr=="3"){
            backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler:
                {
                    UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
            })
            LocationTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(MyOrderOpenDetailViewController.ReconnectMethod), userInfo: nil, repeats: true)
        }else{
            LocationTimer.invalidate()
            LocationTimer.fire()
        }
        
        if((statStr as NSString).length>0){
            bottomView.isHidden=false
            if(statStr=="1"){
                if  self.objDetailRec.job_Status == "0"{
                    JobStatus_Img.image = UIImage(named: "Job_Cancel")
                    JobStatus_Lbl.text = Language_handler.VJLocalizedString("expired_job", comment: nil)
//                    self.BottomStackView.isHidden = true
//                    RejectView.isHidden=true
//                    AcceptView.isHidden=true
//                    SingleButtonView.isHidden=false
                    self.bottomViewHeight.constant = 0
                    self.bottomView.isHidden = true
                    self.NavigateVew.isHidden = true
                    singleBtn.setTitle(Language_handler.VJLocalizedString("expired_job", comment: nil), for: UIControl.State())
                }
                else if (Getorderstatus == "Missed Job")
                {
                    JobStatus_Img.image = UIImage(named: "Job_Cancel")
                    JobStatus_Lbl.text = Language_handler.VJLocalizedString("miss_job", comment: nil)
//                    self.BottomStackView.isHidden = true
//                    RejectView.isHidden=true
//                    AcceptView.isHidden=true
//                    SingleButtonView.isHidden=false
                    self.bottomViewHeight.constant = 0
                    self.bottomView.isHidden = true
                    self.NavigateVew.isHidden = true
                    singleBtn.setTitle(Language_handler.VJLocalizedString("miss_job", comment: nil), for: UIControl.State())
                }
                else
                {
                    JobStatus_Img.image = UIImage(named: "New_Leads")
                    JobStatus_Lbl.text = self.objDetailRec.jobStatusStr
//                    self.BottomStackView.isHidden = false
//                    RejectView.isHidden=false
//                    AcceptView.isHidden=false
//                    SingleButtonView.isHidden=true
                    self.bottomViewHeight.constant = 60
                    self.bottomView.isHidden = false
                    self.NavigateVew.isHidden = false
                    self.MessageView.isHidden = true
                    self.isJobCompleted = false
                    acceptBtn.setTitle(Language_handler.VJLocalizedString("accept", comment: nil), for: UIControl.State())
                    rejectBtn.setTitle(Language_handler.VJLocalizedString("reject", comment: nil), for: UIControl.State())
                }
            }
            else if(statStr=="2"){
                JobStatus_Img.image = UIImage(named: "Job_Accept_StartOff_Arrived")
                JobStatus_Lbl.text = self.objDetailRec.jobStatusStr
//                RejectView.isHidden=false
//                AcceptView.isHidden=false
//                SingleButtonView.isHidden=true
                self.bottomViewHeight.constant = 60
                self.bottomView.isHidden = false
                self.NavigateVew.isHidden = false
                self.MessageView.isHidden = false
                self.isJobCompleted = false
                rejectBtn.setTitle(Language_handler.VJLocalizedString("cancel", comment: nil), for: UIControl.State())
                acceptBtn.setTitle(Language_handler.VJLocalizedString("start_off", comment: nil), for: UIControl.State())
            }
            else if(statStr=="3"){
                JobStatus_Img.image = UIImage(named: "Job_Accept_StartOff_Arrived")
                JobStatus_Lbl.text = self.objDetailRec.jobStatusStr
//                RejectView.isHidden=false
//                AcceptView.isHidden=false
//                SingleButtonView.isHidden=true
                self.bottomViewHeight.constant = 60
                self.bottomView.isHidden = false
                self.NavigateVew.isHidden = false
                self.MessageView.isHidden = false
                self.isJobCompleted = false
                rejectBtn.setTitle(Language_handler.VJLocalizedString("cancel", comment: nil), for: UIControl.State())
                acceptBtn.setTitle(Language_handler.VJLocalizedString("arrived", comment: nil), for: UIControl.State())
            }
            else if(statStr=="4"){
                JobStatus_Img.image = UIImage(named: "Job_Accept_StartOff_Arrived")
                JobStatus_Lbl.text = self.objDetailRec.jobStatusStr
//                RejectView.isHidden=false
//                AcceptView.isHidden=false
//                SingleButtonView.isHidden=true
                self.bottomViewHeight.constant = 60
                self.bottomView.isHidden = false
                self.NavigateVew.isHidden = true
                self.MessageView.isHidden = false
                self.isJobCompleted = false
                rejectBtn.setTitle(Language_handler.VJLocalizedString("cancel", comment: nil), for: UIControl.State())
                acceptBtn.setTitle(Language_handler.VJLocalizedString("start_job", comment: nil), for: UIControl.State())
            }
            else if(statStr=="5"){
                self.theme.addGradient(self.SingleButtonView, colo1: lightorangecolor, colo2: darkorangecolor, direction: .LefttoRight, Frame: CGRect(x: 0, y: 0, width: self.SingleButtonView.frame.width, height: self.SingleButtonView.frame.height), CornerRadius: true, Radius: self.SingleButtonView.frame.height/2)
                self.SingleButtonView.layoutIfNeeded()
                self.SingleButtonView.setNeedsLayout()
                JobStatus_Img.image = UIImage(named: "Job_Completed")
                JobStatus_Lbl.text = self.objDetailRec.jobStatusStr
                self.BottomStackView.isHidden = true
                RejectView.isHidden=true
                AcceptView.isHidden=true
                SingleButtonView.isHidden=false
                self.bottomViewHeight.constant = 60
                self.bottomView.isHidden = false
                singleBtn.isUserInteractionEnabled = true
                self.NavigateVew.isHidden = true
                self.MessageView.isHidden = false
                self.isJobCompleted = false
                singleBtn.setTitle(Language_handler.VJLocalizedString("complete_job", comment: nil), for: UIControl.State())
            }
            else if(statStr=="6"){ // request payment
                JobStatus_Img.image = UIImage(named: "Job_Completed")
                JobStatus_Lbl.text = self.objDetailRec.jobStatusStr
                self.BottomStackView.isHidden = true
//                RejectView.isHidden=true
//                acceptBtn.isHidden=true
//                singleBtn.isHidden=false
//                singleBtn.isUserInteractionEnabled = false
                self.bottomViewHeight.constant = 0
                self.bottomView.isHidden = true
                self.NavigateVew.isHidden = true
                self.MessageView.isHidden = false
                self.isJobCompleted = false
                singleBtn.setTitle(Language_handler.VJLocalizedString("completed", comment: nil), for: UIControl.State())
            }
            else if(statStr=="7"){
                if self.objDetailRec.Submit_rating == "Yes"
                {
                    removeSublayer(self.AcceptView , layerName: "Gradient")
                    self.theme.addGradient(self.SingleButtonView, colo1: provideRatingGradienrtleft, colo2: provideRatingGradienrtright, direction:.LefttoRight, Frame: CGRect(x: 0, y: 0, width: self.SingleButtonView.frame.width, height: self.SingleButtonView.frame.height), CornerRadius: true, Radius: self.SingleButtonView.frame.height/2)
                    self.BottomStackView.isHidden = true
                    RejectView.isHidden=true
                    AcceptView.isHidden=true
                    SingleButtonView.isHidden = false
//                    self.optionsViewHeight.constant = 0
//                    self.OptionsView.isHidden = true
                    if SessionManager.sharedinstance.isReviewSkipped == true{
                        self.bottomViewHeight.constant = 0
                        self.bottomView.isHidden = true
                    }else{
                        self.bottomViewHeight.constant = 60
                        self.bottomView.isHidden = false
                    }
                    self.NavigateVew.isHidden = true
                    self.isJobCompleted = true
                    singleBtn.setTitle(Language_handler.VJLocalizedString("Rating", comment: nil), for: UIControl.State())
                }
                else{
                JobStatus_Img.image = UIImage(named: "Job_Payment_Completed")
                JobStatus_Lbl.text = self.objDetailRec.jobStatusStr
                self.BottomStackView.isHidden = true
//                RejectView.isHidden=true
//                AcceptView.isHidden=true
//                SingleButtonView.isHidden=false
//                singleBtn.isUserInteractionEnabled = false
//                    self.optionsViewHeight.constant = 0
//                    self.OptionsView.isHidden = true
                    self.bottomViewHeight.constant = 0
                    self.bottomView.isHidden = true
                    self.NavigateVew.isHidden = true
                    self.isJobCompleted = true
                    singleBtn.setTitle(Language_handler.VJLocalizedString("completed", comment: nil), for: UIControl.State())
            }
            }
            else if(statStr=="8"){
                JobStatus_Img.image = UIImage(named: "Job_Cancel")
                JobStatus_Lbl.text = self.objDetailRec.jobStatusStr
                self.theme.addGradient(self.JobCancelView, colo1: cancelGradientleft, colo2: cancelGradientright, direction: .LefttoRight, Frame: CGRect(x: 0, y: 0, width: JobCancelView.frame.width, height: JobCancelView.frame.height), CornerRadius: false, Radius: 0)
//                JobCancelView.isHidden=false
//                self.BottomStackView.isHidden = true
//                RejectView.isHidden=true
//                AcceptView.isHidden=true
//                SingleButtonView.isHidden=true
                self.optionsViewHeight.constant = 0
                self.OptionsView.isHidden = true
                self.bottomViewHeight.constant = 0
                self.bottomView.isHidden = true
                self.NavigateVew.isHidden = true
                jobCancelLbl.text=Language_handler.VJLocalizedString("job_cancelled", comment: nil)
            }
            else {
                if self.objDetailRec.Submit_rating == "Yes"
                {
                    self.theme.addGradient(self.SingleButtonView, colo1: provideRatingGradienrtleft, colo2: provideRatingGradienrtright, direction:.LefttoRight, Frame: CGRect(x: 0, y: 0, width: /*self.SingleButtonView.frame.origin.x + */self.SingleButtonView.frame.width, height: self.SingleButtonView.frame.height), CornerRadius: true, Radius: self.SingleButtonView.frame.height/2)
                    RejectView.isHidden=true
                    AcceptView.isHidden=false
                    SingleButtonView.isHidden=true
                    self.isJobCompleted = true
                    if SessionManager.sharedinstance.isReviewSkipped == true{
                        self.bottomViewHeight.constant = 0
                        self.bottomView.isHidden = true
                    }else{
                        self.bottomViewHeight.constant = 60
                        self.bottomView.isHidden = false
                    }
                    self.NavigateVew.isHidden = true
                    rejectBtn.setTitle(Language_handler.VJLocalizedString("more_info", comment: nil), for: UIControl.State())
                    acceptBtn.setTitle(Language_handler.VJLocalizedString("Rating", comment: nil), for: UIControl.State())
                }
                else{
                    removeSublayer(self.SingleButtonView , layerName: "Gradient")
                    
                    self.BottomStackView.isHidden = true
//                    RejectView.isHidden=true
//                    AcceptView.isHidden=true
//                    SingleButtonView.isHidden=false
//                    singleBtn.isUserInteractionEnabled = false
                    self.bottomViewHeight.constant = 0
                    self.bottomView.isHidden = true
                    self.NavigateVew.isHidden = true
                    self.isJobCompleted = true
                    singleBtn.setTitle(Language_handler.VJLocalizedString("completed", comment: nil), for: UIControl.State())
                }
            }
        }else{
            bottomView.isHidden=true
        }
        
    }
    @objc func ReconnectMethod()
    {
        let objUserRecs:UserInfoRecord=theme.GetUserDetails(); SocketIOManager.sharedInstance.emitTracking(self.objDetailRec.Userid as String, tasker: objUserRecs.providerId as String , task: jobID as String, lat:"\(Currentlat)" , long: "\(Currentlng)", bearing: "\(Bearing)",lastdrive: "\(lastDriving)")
        
    }
    
    @IBAction func didClickSingleBtn(_ sender: UIButton) {
        if(sender.titleLabel?.text==Language_handler.VJLocalizedString("complete_job", comment: nil)){
            // self.displayViewController(.BottomTop)
            self.sendJobDetails()
        }else if (sender.titleLabel?.text == Language_handler.VJLocalizedString("Rating", comment: nil))
        {
            let objFarevc = self.storyboard!.instantiateViewController(withIdentifier: "RatingsVCSID") as! RatingsViewController
            objFarevc.jobIDStr = jobID
//          self.navigationController!.pushViewController(withFade: objFarevc, animated: false)
            add(objFarevc)
        }
    }
    
    @IBAction func didClickRejectBtn(_ sender: UIButton) {
        if(sender.titleLabel?.text==Language_handler.VJLocalizedString("reject", comment: nil)){
            getCancelReasonForJob()
        }else if (sender.titleLabel?.text==Language_handler.VJLocalizedString("cancel", comment: nil)){
            getCancelReasonForJob()
        }
        //        else if (sender.titleLabel?.text==Language_handler.VJLocalizedString("more_info", comment: nil))
        //        {
        //            moveToPaymentOrMoreInfoVC()
        //
        //        }
    }
    @IBAction func didClickAcceptBtn(_ sender: UIButton) {
        if(sender.titleLabel?.text==Language_handler.VJLocalizedString("accept", comment: nil)){
            jobUpdateStatus(AcceptRideUrl as NSString)
        }
        else if (sender.titleLabel?.text==Language_handler.VJLocalizedString("start_off", comment: nil)){
            jobUpdateStatus(StartDestinationUrl as NSString)
            
        }else if (sender.titleLabel?.text==Language_handler.VJLocalizedString("arrived", comment: nil)){
            jobUpdateStatus(ArrivedDestinationUrl as NSString)
        }
        else if (sender.titleLabel?.text==Language_handler.VJLocalizedString("start_job", comment: nil)){
            jobUpdateStatus(JobStartUrl as NSString)
        }
        
    }
    @IBAction func didClickWorkFlowBtn(_ sender: UIButton) {//
        
        let ObjStepsVc=self.storyboard!.instantiateViewController(withIdentifier: "StepsTreeVCSID")as! StepsTreeViewController
        ObjStepsVc.JobIdStr=jobID
        self.navigationController?.pushViewController(withFade: ObjStepsVc, animated: false)
    }
    
    func jobUpdateStatus(_ statusType:NSString){
        if Double(Currentlat) != nil{
            self.showProgress()
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                "job_id":"\(jobID)",
                "provider_lat":"\(Currentlat)",
                "provider_lon":"\(Currentlng)"]
            if statusType as String == StartDestinationUrl{
                trackingDetail.partnerLat = Double(Currentlat)!
                trackingDetail.partnerLong = Double(Currentlng)!
            }
            acceptBtn.isUserInteractionEnabled=false
            rejectBtn.isUserInteractionEnabled=false
            url_handler.makeCall(statusType as String, param: Param as NSDictionary) {
                (responseObject, error) -> () in
                self.DismissProgress()
                self.acceptBtn.isUserInteractionEnabled=true
                self.rejectBtn.isUserInteractionEnabled=true
                if(error != nil)
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
                else
                {
                    if(responseObject != nil && (responseObject?.count)!>0)
                    {
                        let responseObject = responseObject!
                        let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                        
                        if(status == "1")
                        {
                            self.detailScrollView.isHidden=false
                            self.bottomView.isHidden=false
                            
                            let dict:NSDictionary=(responseObject.object(forKey: "response"))! as! NSDictionary
                            self.objDetailRec.jobBtnStatus=self.theme.CheckNullValue(dict.object(forKey: "btn_group") as AnyObject)
                            
                            
                            NSLog("Get btnGroup Response=%@", self.objDetailRec.jobBtnStatus)
//                            self.view.makeToast(message:self.theme.CheckNullValue(dict.object(forKey: "message") as AnyObject), duration: 2, position: HRToastPositionDefault as AnyObject, title: Language_handler.VJLocalizedString("success", comment: nil))
                            let messagestr : String = self.theme.CheckNullValue(dict.object(forKey: "message") as AnyObject)
                            self.setBottomViewWithButton(self.objDetailRec.jobBtnStatus)
                            //                            if (messagestr == "Job Rejected Successfully")
                            //                            {
                            self.GetJobDetails()
                            //                            }
                        }
                        else
                        {//alertImg
                            _ = UIImage(named: "alertImg")
                            
                            self.theme.AlertView("\(appNameJJ)", Message: self.theme.CheckNullValue(responseObject.object(forKey: "response") as AnyObject), ButtonTitle: kOk)
                        }
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
            }
        }
    }
    
    
    func jobUpdateCancelStatus(_ statusType:NSString){
        
        self.showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
            "job_id":"\(jobID)",
            "reason":"\(reasonIdStr)"]
        // print(Param)
        
        url_handler.makeCall(statusType as String, param: Param as NSDictionary) {
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
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                    if(status == "1")
                    {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadCurrentJob"), object: nil)
                        self.detailScrollView.isHidden=false
                        self.bottomView.isHidden=false
                        let dict:NSDictionary=(responseObject.object(forKey: "response"))! as! NSDictionary
                        self.objDetailRec.jobBtnStatus=self.theme.CheckNullValue(dict.object(forKey: "btn_group") as AnyObject)
                        self.setBottomViewWithButton(self.objDetailRec.jobBtnStatus)
                        self.GetJobDetails()
                        self.theme.AlertView( Language_handler.VJLocalizedString("success", comment: nil), Message: self.theme.CheckNullValue(dict.object(forKey: "message")), ButtonTitle: kOk)
                    }
                    else
                    {//alertImg
                        
                        self.theme.AlertView("\(appNameJJ)", Message: self.theme.CheckNullValue(responseObject.object(forKey: "response")), ButtonTitle: kOk)
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
        }
    }
    
    
    func getCancelReasonForJob(){
        self.showProgress()
        acceptBtn.isUserInteractionEnabled=false
        rejectBtn.isUserInteractionEnabled=false
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)"]
        // print(Param)
        
        url_handler.makeCall(CancelReasonUrl, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            self.DismissProgress()
            self.acceptBtn.isUserInteractionEnabled=true
            self.rejectBtn.isUserInteractionEnabled=true
            
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                    if(status == "1")
                    {
                        self.detailScrollView.isHidden=false
                        self.bottomView.isHidden=false
                        if((((responseObject.object(forKey: "response") as AnyObject).object(forKey: "reason")! as AnyObject).count)!>0){
                            let  listArr:NSArray=(responseObject.object(forKey: "response") as AnyObject).object(forKey: "reason") as! NSArray
                            if(self.CancelReasonArr.count>0){
                                self.CancelReasonArr.removeAllObjects()
                                self.CancelTitleArr.removeAllObjects()
                            }
                            for (_, element) in listArr.enumerated() {
                                let objRec:CancelReasonRecord=CancelReasonRecord()
                                objRec.reasonId=self.theme.CheckNullValue((element as AnyObject).object(forKey: "id") as AnyObject)
                                objRec.reason=self.theme.CheckNullValue((element as AnyObject).object(forKey: "reason") as AnyObject)
                                self.CancelReasonArr.add(objRec)
                                self.CancelTitleArr.add(objRec.reason)
                            }
                            let objRec:CancelReasonRecord=CancelReasonRecord()
                            objRec.reasonId="1"
                            objRec.reason=Language_handler.VJLocalizedString("other", comment: nil)
                            self.CancelReasonArr.add(objRec)
                            self.CancelTitleArr.add(objRec.reason)
                            
                            if(self.CancelTitleArr.count==0){
                                self.theme.AlertView(Language_handler.VJLocalizedString("sorry", comment: nil), Message:Language_handler.VJLocalizedString("no_reason", comment: nil), ButtonTitle: kOk)
                            }else{
                                let actionSheet = UIActionSheet(title:Language_handler.VJLocalizedString("select_reason", comment: nil), delegate: self, cancelButtonTitle:Language_handler.VJLocalizedString("dont_cancel", comment: nil) , destructiveButtonTitle: nil)
                                for str in self.CancelTitleArr{
                                    actionSheet.addButton(withTitle: str as? String)
                                }
                                actionSheet.show(in: self.view)
                            }
                            
                            
                        }else{
                            self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                        }
                        
                    }
                    else
                    {//alertImg
                        
                        let messagestr :String = self.theme.CheckNullValue(responseObject.object(forKey: "response") as AnyObject)
                        self.theme.AlertView("\(appNameJJ)", Message: messagestr, ButtonTitle: kOk)
                        
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
            
        }
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        if(buttonIndex>0){
            if actionSheet.buttonTitle(at: buttonIndex)! == Language_handler.VJLocalizedString("other", comment: nil)
            {
                let alert = UIAlertController(title: Language_handler.VJLocalizedString("reason", comment: nil), message: "", preferredStyle: .alert)
                
                alert.addTextField(configurationHandler: configurationTextField)
                alert.addAction(UIAlertAction(title: Language_handler.VJLocalizedString("cancel", comment: nil), style: .cancel, handler:handleCancel))
                alert.addAction(UIAlertAction(title:Language_handler.VJLocalizedString("done", comment: nil) , style: .default, handler:{ (UIAlertAction) in
                    
                    
                    self.reasonIdStr=self.tField.text!
                    self.jobUpdateCancelStatus(CancelJobUrl as NSString)
                    
                }))
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
            }
            else
            {
                let objReason:CancelReasonRecord=CancelReasonArr.object(at: buttonIndex-1) as! CancelReasonRecord
                reasonIdStr=objReason.reason
                let createReasonAlert: UIAlertView = UIAlertView()
                
                createReasonAlert.delegate = self
                
                createReasonAlert.title = appNameJJ
                createReasonAlert.message = Language_handler.VJLocalizedString("cancel_confirmation", comment: nil)
                createReasonAlert.addButton(withTitle: Language_handler.VJLocalizedString("no", comment: nil))
                createReasonAlert.addButton(withTitle: Language_handler.VJLocalizedString("yes", comment: nil))
                
                createReasonAlert.show()
            }
        }
    }
    
    func configurationTextField(_ textField: UITextField!)
    {
        
        textField.placeholder = Language_handler.VJLocalizedString("reason_placeholder", comment: nil)
        
        tField = textField
    }
    
    func handleCancel(_ alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
    
    func alertView(_ View: UIAlertView, clickedButtonAt buttonIndex: Int){
        
        switch buttonIndex{
            
        case 1:
            jobUpdateCancelStatus(CancelJobUrl as NSString)
            break;
            
        default:
            
            break;
            //Some code here..
            
        }
    }
    
    func sendJobDetails(){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMaterialsVCID") as? AddMaterialsViewController{
            if let navigator = self.navigationController
            {
                viewController.jobIDStr=jobID
                viewController.currency=self.objDetailRec.currency_symbol
                viewController.Delegate=self
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
//        self.displayViewController1(.bottomBottom)
    }
    
    
    func dismissPopupViewController1(_ animationType: SLpopupViewAnimationType) {
        let sourceView:UIView = self.getTopView()
        let popupView:UIView = sourceView.viewWithTag(kpopupViewTag)!
        let overlayView:UIView = sourceView.viewWithTag(kOverlayViewTag)!
        switch animationType {
        case .bottomTop, .bottomBottom, .topTop, .topBottom, .leftLeft, .leftRight, .rightLeft, .rightRight:
            self.slideViewOut(popupView, sourceView: sourceView, overlayView: overlayView, animationType: animationType)
        default:
            fadeViewOut(popupView, sourceView: sourceView, overlayView: overlayView)
        }
    }
    
    func displayViewController1(_ animationType: SLpopupViewAnimationType) {
        myMaterialView = MiscellaneousVC(nibName:"MaterialDesignView", bundle: nil)
        myMaterialView.delegate = self
        myMaterialView.jobIDStr=jobID
        myMaterialView.currency=self.objDetailRec.currency_symbol
        
        myMaterialView.transitioningDelegate = self
        
        myMaterialView.modalPresentationStyle = .custom
        self.navigationController?.present(myMaterialView, animated: true, completion: nil)
        //self.navigationController!.pushViewController(withFade: objFarevc, animated: false)
        //        self.presentpopupViewController(myMaterialView, animationType: animationType, completion: { () -> Void in
        //
        //        })
    }
    
    func pressedCancelMaterial(_ sender: MiscellaneousVC) {
        self.dismiss(animated: true, completion: nil)
        loadDetail()
    }
    
    //    #pragma mark - UIViewControllerTransitionDelegate -
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return PresentingAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return DismissingAnimationController()
    }
    
    @IBAction func didClickPhoneBtn(_ sender: AnyObject) {
        
        //        callNumber(objDetailRec.jobPhone as String)
    }
    fileprivate func callNumber(_ phoneNumber:String) {
        
        print("\(phoneNumber) get mnuber")
        
        //        let Number:String="\(phoneNumber)"
        //        let trimmedString = Number.stringByReplacingOccurrencesOfString("+ ", withString: "")
        
        if let phoneCallURL:URL = URL(string:"tel://"+"\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MyOrderOpenDetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == TimeLineTableView
        {
            return TimelineArr.count
        }
        else{
            return faresummaryArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == TimeLineTableView
        {
            let Cell = tableView.dequeueReusableCell(withIdentifier:"timeline", for: indexPath) as! timelinetreeTableViewCell
            Cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let timeRec = TimelineArr[indexPath.row]
            if indexPath.row == 0
            {
                if self.objDetailRec.jobStatusStr == "New Lead"{
                    Cell.topView.isHidden = true
                    Cell.bottomView.isHidden = true
                }else{
                    Cell.topView.isHidden = true
                    Cell.bottomView.isHidden = false
                }
            }
            else if indexPath.row == TimelineArr.count-1
            {
                Cell.topView.isHidden = false
                Cell.bottomView.isHidden = true
            }
            else
            {
                Cell.topView.isHidden = false
                Cell.bottomView.isHidden = false
            }
            
            Cell.dateLbl.text = timeRec.date
            Cell.time_lbl.text = timeRec.time
            Cell.statusLbl.text = timeRec.title
            return Cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"invoice", for: indexPath) as! invoicelistTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let rec = faresummaryArr[indexPath.row]
            cell.statuslbl.text = rec.title
            
            if rec.dt == "1"
            {
                let attrString = NSMutableAttributedString(string: self.objDetailRec.currency_symbol,
                                                           attributes: [ NSAttributedString.Key.foregroundColor: PlumberThemeColor as Any ])
                
                attrString.append(NSMutableAttributedString(string: rec.amount,
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black as Any ]))
                
                cell.amountlbl.attributedText = attrString
            }
            else{
                cell.amountlbl.text =  rec.amount
                cell.amountlbl.text?.capitalizeFirstLetter()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            self.TableViewHeight.constant = self.TimeLineTableView.contentSize.height + self.TasksHeader_Lbl.frame.height
            self.TimeLineTableView.layoutIfNeeded()
            self.TimeLineTableView.updateConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) , execute: {
            self.PaymentViewHeight.constant = self.PaymentTableView.contentSize.height + self.paymentHeader_Lbl.frame.height
            self.PaymentTableView.layoutIfNeeded()
            self.PaymentTableView.updateConstraints()
        })
    }
}
