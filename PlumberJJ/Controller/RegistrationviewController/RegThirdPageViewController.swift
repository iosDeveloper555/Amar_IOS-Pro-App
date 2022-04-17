//
//  RegThirdPageViewController.swift
//  PlumberJJ
//
//  Created by Gurulakshmi's Mac Mini on 26/07/18.
//  Copyright © 2018 Casperon Technologies. All rights reserved.
//

import UIKit

class RegThirdPageViewController: RootBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
    
    @IBOutlet var timingView: TimingView!
    @IBOutlet weak var submit: CustomRoundButton!
    @IBOutlet weak var backgrndImg: UIImageView!
    
    @IBOutlet var OnoffView: AvailableView!
    @IBOutlet weak var titleLbl: CustomLabelHeader!
    
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ques_height: NSLayoutConstraint!
    @IBOutlet weak var avail_height: NSLayoutConstraint!
    @IBOutlet weak var aboutTableView: UITableView!
    @IBOutlet weak var availCollection: UICollectionView!
    @IBOutlet weak var availDayLbl: CustomLabelLightGray!
    @IBOutlet weak var availLbl: CustomLabel!
      @IBOutlet weak var profilelable: CustomLabelLightGray!
    
    var weekFullDay = [String]()
    var timingforDay = [String]()
    var availableDays = [AvailableRec]()
    var QuestionsArray = [QuestionRec]()
    var heightConstraint: NSLayoutConstraint?
    var boolarray = [Bool]()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var saveAvailability : Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.theme.yesTheDeviceisHavingNotch(){
        HeaderViewHeight.constant = 100
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        weekFullDay = [self.theme.setLang("sunday"),
                       self.theme.setLang("monday"),
                       self.theme.setLang("tuesday"),
                       self.theme.setLang("wednesday"),
                       self.theme.setLang("thursday"),
                       self.theme.setLang("friday"),
                       self.theme.setLang("saturday")]
        
        timingforDay =  [
                         "\(self.theme.setLang("morning")) \n (08.00am - 12.00 pm)",
                         "\(self.theme.setLang("afternoon")) \n (12.00pm - 04.00 pm)",
                         "\(self.theme.setLang("evening")) \n (04.00pm - 08.00 pm)"
                        ]
        self.submit.setTitle(theme.setLang("continue"), for: .normal)
        titleLbl.text = theme.setLang("setp2")
        availLbl.text = theme.setLang("applytasker")
        availDayLbl.text = theme.setLang("select_day")
        profilelable.text = theme.setLang("Your Profile Details")
        availCollection.delegate = self
        availCollection.dataSource = self
       
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/4, height: screenWidth/4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        availCollection!.collectionViewLayout = layout
        availCollection.reloadData()
        self.aboutTableView.delegate = self
        self.aboutTableView.dataSource = self
        aboutTableView.estimatedRowHeight = 125
        aboutTableView.rowHeight = UITableView.automaticDimension
        ques_height.constant = 100
        for weekday in weekFullDay
        {
            let dayrec = AvailableRec()
            dayrec.day = weekday
            dayrec.ismorning = false
            dayrec.isaftn = false
            dayrec.isevening = false
            availableDays.append(dayrec)
        }
        avail_height.constant = 187
        availCollection.reloadData()
        avail_height.constant = self.availCollection.collectionViewLayout.collectionViewContentSize.height
        self.availCollection.layoutIfNeeded()
        self.getAboutDetails()
        
        // Do any additional setup after loading the view.
    }
  
    @IBAction func didClickhr(_ sender: Any) {
        var hr = Int(timingView.fromtimeHrlbl.text!)!
        print(String(format: "%02d", hr))

        if (sender as AnyObject).tag == 0 {
            hr = hr  + 1
            if hr == 24
            {
               timingView.fromtimeHrlbl.text = "00"
            }else{
               timingView.fromtimeHrlbl.text = String(format: "%02d", hr)
            }
        }
        else
        {
            if hr == 00
            {
                timingView.fromtimeHrlbl.text = "23"
            }else
            {
                  hr = hr - 1
                timingView.fromtimeHrlbl.text = String(format: "%02d", hr)
            }
        }
    }
    
    @IBAction func didClickmin(_ sender: Any) {
            if (sender as AnyObject).tag == 0 {
        let min = timingView.fromtimeMinlbl.text!
        if min == "00"
        {
            timingView.fromtimeMinlbl.text = "30"
        }
        else
        {
             timingView.fromtimeMinlbl.text = "00"
            self.plusactionwithlable(ishourtime:true)
        }
            }else{
                let min = timingView.fromtimeMinlbl.text!
                if min == "00"
                {
                    timingView.fromtimeMinlbl.text = "30"
                    self.minusactionwithlable(ishourtime: true)
                }
                else
                {
                    timingView.fromtimeMinlbl.text = "00"
                    

                }
        }
    }
    
    @IBAction func didclickTohour(_ sender: Any) {
        var hr = Int(timingView.totimeHrlbl.text!)!
        print(String(format: "%02d", hr))
        
        if (sender as AnyObject).tag == 0 {
            
            hr = hr  + 1
            if hr == 24
            {
                timingView.totimeHrlbl.text = "00"
            }else
            {
                timingView.totimeHrlbl.text = String(format: "%02d", hr)
            }
        }
        else
        {
            if hr == 00
            {
                timingView.totimeHrlbl.text = "23"
            }else
            {
                hr = hr - 1
                timingView.totimeHrlbl.text = String(format: "%02d", hr)
            }
        }
    }
    
    @IBAction func didClickTomins(_ sender: Any) {
        if (sender as AnyObject).tag == 0 {
            let min = timingView.totimeMinlbl.text!
            if min == "00"
            {
                timingView.totimeMinlbl.text = "30"
            }
            else
            {
                timingView.totimeMinlbl.text = "00"
                self.plusactionwithlable(ishourtime:false)
            }
        }else{
            let min = timingView.totimeMinlbl.text!
            if min == "00"
            {
                timingView.totimeMinlbl.text = "30"
                self.minusactionwithlable(ishourtime: false)
            }
            else
            {
                timingView.totimeMinlbl.text = "00"
            }
        }
    }
    
    func plusactionwithlable(ishourtime:Bool)
    {
        if ishourtime
        {
            var hr = Int(timingView.fromtimeHrlbl.text!)!
        
            hr = hr  + 1
            if hr == 24
            {
                timingView.fromtimeHrlbl.text = "00"
            }else
            {
                timingView.fromtimeHrlbl.text = String(format: "%02d", hr)
            }
            
        }else
        {
            var hr = Int(timingView.totimeHrlbl.text!)!
            
            hr = hr  + 1
            if hr == 24
            {
                timingView.totimeHrlbl.text = "00"
            }else
            {
                timingView.totimeHrlbl.text = String(format: "%02d", hr)
            }
        }
        
    }
    
    
    func minusactionwithlable(ishourtime:Bool)
    {
        if ishourtime
        {
            var hr = Int(timingView.fromtimeHrlbl.text!)!
            if hr == 00
            {
                timingView.fromtimeHrlbl.text = "23"
            }else
            {
                  hr = hr - 1
                timingView.fromtimeHrlbl.text = String(format: "%02d", hr)
            }
        }
        else
        {
            var hr = Int(timingView.totimeHrlbl.text!)!
            if hr == 00
            {
                timingView.totimeHrlbl.text = "23"
            }else
            {
                hr = hr - 1
                timingView.totimeHrlbl.text = String(format: "%02d", hr)
            }
        }
    }
    override func viewWillLayoutSubviews() {
        heightConstraint?.constant = OnoffView.dayTbl.contentSize.height + 100
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        availCollection.reloadData()
//    }
    override func viewDidLayoutSubviews() {
        self.submit.applyGradientwithcorner()
        availCollection.reloadData()
    }
    @objc func closeAct(sender:UIButton)
    {
        self.OnoffView.removeFromSuperview()
        self.backgrndImg.isHidden = true
//        self.timingView.removeFromSuperview()
//         self.backgrndImg.isHidden = true
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableDays.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"availablecell", for: indexPath) as! AvailableCell
        
        let avail = availableDays[indexPath.row]
        cell.statusLbl.isHidden = true
        if avail.ismorning == true || avail.isaftn == true || avail.isevening == true
        {
            cell.availabeBtn.setTitleColor(UIColor.green, for: .normal)
            cell.statusLbl.text = theme.setLang("selected")
            cell.statusLbl.textColor = UIColor.green
        }
        else
        {
             cell.availabeBtn.backgroundColor = UIColor.lightGray
//            cell.statusLbl.isHidden = false
//            cell.availabeBtn.titleEdgeInsets = UIEdgeInsetsMake(-21, 0, 0, 0)
            cell.availabeBtn.setTitleColor(UIColor.black, for: .normal)
            cell.statusLbl.text = theme.setLang("not_select")
             cell.statusLbl.textColor = UIColor.red
        }
        
        cell.availabeBtn.setTitle("\(avail.day)", for: .normal)
        cell.availabeBtn.layer.cornerRadius = cell.availabeBtn.frame.size.width/2
        cell.availabeBtn.layer.masksToBounds = true
        cell.availabeBtn.tag = indexPath.row
        cell.availabeBtn.addTarget(self, action: #selector(showAvailableView(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: screenWidth/4, height: screenWidth/4);
    }
    
    @objc func showAvailableView(sender:UIButton)
    {
        self.view.endEditing(true)
        self.backgrndImg.isHidden = false
        let avail = availableDays[sender.tag]

        OnoffView.center = CGPoint(x: self.view.frame.size.width  / 2,
                                           y: self.view.frame.size.height / 2);
        
        boolarray = [avail.ismorning!,avail.isaftn!,avail.isevening!]
/*      OnoffView.dayTitle.text = avail.day
      timingView.daytitleLbl.text = avail.day
        timingView.closeBtn.addTarget(self, action:#selector(closeAct(sender:)) , for:.touchUpInside)
//
        timingView.saveBtn.addTarget(self, action: #selector(SaveAvailabilty(sender:)), for: .touchUpInside)
//
        self.theme.MakeAnimation(view: self.timingView, animation_type: CSAnimationTypePop)
        
        timingView.fromtimeHrlbl.text = "00"
        timingView.fromtimeMinlbl.text = "00"
        timingView.totimeHrlbl.text = "00"
        timingView.totimeHrlbl.text = "00"
        //OnoffView.dayHieght.constant = OnoffView.dayTbl.contentSize.height
      
        self.view.addSubview(timingView)
        timingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: timingView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1/1.15, constant: 0).isActive = true
        NSLayoutConstraint(item: timingView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: timingView!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:timingView , attribute: .height, relatedBy: .equal, toItem: nil, attribute:.height, multiplier: 1, constant: 375).isActive = true
        //heightConstraint =  NSLayoutConstraint(item: timingView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220)
        //heightConstraint?.isActive = true
        timingView.layoutIfNeeded()
        */
        OnoffView.layer.cornerRadius = 6
        OnoffView.layer.masksToBounds = true
        //        OnoffView.center = CGPoint(x: self.view.frame.size.width  / 2,
        //                                   y: self.view.frame.size.height / 2);
        
        boolarray = [avail.ismorning!,avail.isaftn!,avail.isevening!]
        OnoffView.dayTitle.text = avail.day
        OnoffView.saveBtn.tag = sender.tag
        OnoffView.closebtn.addTarget(self, action:#selector(closeAct(sender:)) , for:.touchUpInside)
        OnoffView.dayTbl.delegate = self
        OnoffView.dayTbl.dataSource = self
        OnoffView.saveBtn.addTarget(self, action: #selector(SaveAvailabilty(sender:)), for: .touchUpInside)
        
        self.theme.MakeAnimation(view: self.OnoffView, animation_type: CSAnimationTypePop)
        //OnoffView.dayHieght.constant = OnoffView.dayTbl.contentSize.height
        OnoffView.dayTbl.layoutIfNeeded()
        OnoffView.dayTbl.reloadData()
        self.view.addSubview(OnoffView)
        OnoffView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: OnoffView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1/1.15, constant: 0).isActive = true
        NSLayoutConstraint(item: OnoffView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: OnoffView!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        heightConstraint =  NSLayoutConstraint(item: OnoffView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220)
        heightConstraint?.isActive = true
        OnoffView.layoutIfNeeded()
    }
    
    @objc func SaveAvailabilty(sender:UIButton)
    {
    let availrec = availableDays[sender.tag]
        let replacerec = AvailableRec()
        replacerec.day = availrec.day
        replacerec.ismorning = boolarray[0]
        replacerec.isaftn = boolarray[1]
        replacerec.isevening = boolarray[2]
        availableDays[sender.tag] = replacerec
        availCollection.reloadData()
        OnoffView.removeFromSuperview()
        self.backgrndImg.isHidden = true
        saveAvailability = true
       /* let fromhr = Int(timingView.fromtimeHrlbl.text!)!
        let tohr = Int(timingView.totimeHrlbl.text!)!
        if fromhr > tohr
        {
            self.view.makeToast(message:"Kindly Select the Valid Timings", duration:2.0, position:HRToastPositionDefault as AnyObject)
        }
        else if fromhr == tohr
        {
            if timingView.fromtimeMinlbl.text == timingView.totimeMinlbl.text
            {
                  self.view.makeToast(message:"Kindly Select the Valid Timings", duration:2.0, position:HRToastPositionDefault as AnyObject)
            }
            else
            {
                 print("Timings are correct")
            }
            
        }else
        {
             print("Timings are correct")
        }*/
    }
    
    func getAboutDetails()
    {
        self.showProgress()
        url_handler.makeCall(registration_Qestion, param:["":""]) { (responseObject, error) in
            if error != nil
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                self.DismissProgress()
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let status=self.theme.CheckNullValue(responseObject?.object(forKey: "status") as AnyObject)
                    if(status == "1")
                    {
                        let questions = responseObject?.object(forKey:"response") as! NSArray
                        for ques  in questions
                        {
                            let ques_rec = QuestionRec()
                            ques_rec.quesId = self.theme.CheckNullValue((ques as AnyObject).object(forKey: "_id"))
                            ques_rec.quesTitle = self.theme.CheckNullValue((ques as AnyObject).object(forKey: "question"))
                            ques_rec.question = ""
                            self.QuestionsArray.append(ques_rec)
                        }
                        
                        self.aboutTableView.reloadData()
                        self.ques_height.constant = self.aboutTableView.contentSize.height
                        self.aboutTableView.layoutIfNeeded()
                    }
                    else
                    {
                        let response = self.theme.CheckNullValue(responseObject?.object(forKey:"response"))
                        self.theme.AlertView(appNameJJ, Message: response, ButtonTitle: kOk)
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
        if tableView == aboutTableView
        {
            return QuestionsArray.count
        }
        else
        {
            return timingforDay.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == aboutTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"question", for: indexPath) as! QuestionTableViewCell
            cell.selectionStyle = .none
            let quesrec = QuestionsArray[indexPath.row]
            cell.quesTxt.text = quesrec.quesTitle
            cell.quesTxt.layer.borderWidth = 1.0
            cell.quesTxt.tag = indexPath.row
//            cell.quesTxt.delegate = self
            cell.quesTxt.layer.borderColor = UIColor.gray.cgColor
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier:"timecell", for: indexPath) as! AvailDayTableViewCell
            cell.dayswitch.setOn(boolarray[indexPath.row], animated: true)
            cell.DayLbl.text = timingforDay[indexPath.row]
            cell.dayswitch.addTarget(self, action: #selector(switchact(sender:)), for:.valueChanged)
            return cell
        }
    }
   @objc func switchact(sender:UISwitch)
    {
        let rowPoint = sender.convert(sender.frame.origin, to: OnoffView.dayTbl)
        let indexPath = OnoffView.dayTbl.indexPathForRow(at: rowPoint)
        if sender.isOn == true
        {
            boolarray[(indexPath?.row)!] = true
        }
        else{
        boolarray[(indexPath?.row)!] = false
        }
        print("getboolarray\(boolarray)")
    OnoffView.dayTbl.reloadData()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       print("newtest\(textView.text)")
//        let getQuesrec = QuestionsArray[textView.tag]
//        let replceQuesrec = QuestionRec()
//        replceQuesrec.quesId = getQuesrec.quesId
//        replceQuesrec.quesTitle = getQuesrec.quesTitle
//        replceQuesrec.question = textView.text!
//        QuestionsArray[textView.tag] =  replceQuesrec
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let getQuesrec = QuestionsArray[textView.tag]
        let replceQuesrec = QuestionRec()
        replceQuesrec.quesId = getQuesrec.quesId
        replceQuesrec.quesTitle = getQuesrec.quesTitle
        replceQuesrec.question = textView.text!
        QuestionsArray[textView.tag] =  replceQuesrec
        return true
    }
 
    @IBAction func submitAct(_ sender: Any) {
        
        if !saveAvailability
        {
            self.theme.AlertView(appNameJJ, Message: theme.setLang("workingdays_mand"), ButtonTitle: kOk)
        }else{
        
            let param = NSMutableDictionary()
            var daysArray = [NSDictionary]()
            var QuesArray = [NSDictionary]()
      
        for element in availableDays
        {
           var daysDict  = NSMutableDictionary()
           let TimingDict = NSMutableDictionary()
           let dayrec = element
            
            if dayrec.ismorning ==  true || dayrec.isaftn ==  true || dayrec.isevening == true{
            
            if dayrec.ismorning == true
            {
                TimingDict["morning"] = "1"
            }
            if dayrec.isevening == true{
                TimingDict ["evening"] = "1"
            }
            if dayrec.isaftn == true{
                TimingDict ["afternoon"] = "1"
            }
            daysDict = ["day":dayrec.day,"hour":TimingDict]
            daysArray.append(daysDict)
            }else
            {
                TimingDict["morning"] = "0"
                TimingDict ["evening"] = "0"
                TimingDict ["afternoon"] = "0"
                daysDict = ["day":dayrec.day,"hour":TimingDict]
                daysArray.append(daysDict)
            }
        }
        for element in QuestionsArray
        {
            let quesDict = NSMutableDictionary()
            quesDict["question"] = element.quesId
            quesDict["answer"] = element.question
            QuesArray.append(quesDict)
        }
        param["working_days"] = daysArray
        param["profile_details"] = QuesArray
        
        print("params for 3rd form\(param)")
         self.showProgress()
   
        url_handler.makeCall(reg_form3 , param: param as NSDictionary) {
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
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                    if(status == "1")
                    {
                        Registerrec["working_days"] = daysArray
                        Registerrec["profile_details"] = QuesArray
                        
                        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFourthPageViewController") as?  RegFourthPageViewController{
                            if let navigator = self.navigationController
                            {
                                let backItem = UIBarButtonItem()
                                backItem.title = ""
                                self.navigationItem.backBarButtonItem = backItem
                                navigator.pushViewController(withFade:viewController , animated: false)
                            }
                        }
                    }
                    else
                    {
                        let response = self.theme.CheckNullValue(responseObject.object(forKey:"response"))
                        self.theme.AlertView(appNameJJ, Message: response, ButtonTitle: kOk)
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
 }



