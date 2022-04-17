//
//  FareSummaryViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/30/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit



class FareSummaryViewController: RootBaseViewController,UITableViewDataSource,UITableViewDelegate {
    var jobIDStr:String = ""
    var cashoption:String = "0"
    //    var needPaymentStr:NSString!
    var review:String = ""
    // var theme:Theme=Theme()
    var fareSummaryArr:NSMutableArray = [];
    var needPaymentStr:String="0"
    
    @IBOutlet var receive_paymentbtn: ButtonColorView!
    @IBOutlet var receivebtn: ButtonColorView!
    @IBOutlet var receivecash_btn: ButtonColorView!
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var fareTblView: UITableView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var jobIdLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fareScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func setData(){
        titleHeader.text = Language_handler.VJLocalizedString("fare_summary", comment: nil)
        receive_paymentbtn.setTitle(Language_handler.VJLocalizedString("request_payment", comment: nil), for: UIControl.State())
        receivebtn.setTitle(Language_handler.VJLocalizedString("receive_cash", comment: nil), for: UIControl.State())
        
        //        receivecash_btn.setTitle(Language_handler.VJLocalizedString("request_payment", comment: nil), forState: UIControlState.Normal)
        
        fareTblView.register(UINib(nibName: "FareDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "fareDetailCellIdentifier")
        fareTblView.estimatedRowHeight = 56
        fareTblView.rowHeight = UITableView.automaticDimension
        fareTblView.tableFooterView = UIView()
        
        jobIdLbl.text="\(Language_handler.VJLocalizedString("job_id", comment: nil)) : \(jobIDStr)"
        
        
        if cashoption == "0"
        {
            
            receive_paymentbtn.isHidden = true
            receivebtn.isHidden = true
            receivecash_btn.isHidden = false
            
            
        }
        else{
            
            receive_paymentbtn.isHidden = false
            receivebtn.isHidden = false
            receivecash_btn.isHidden = true
            
        }
        
        
        GetFareDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    func GetFareDetails(){
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                                 "job_id":"\(jobIDStr)"]
        print(Param)
        self.showProgress()
        url_handler.makeCall(PaymentCumMoreInfoUrl, param: Param as NSDictionary) {
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
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    
                    if(status == "1")
                    {
                        
                        
                        if(((responseObject.object(forKey: "response") as AnyObject).object(forKey: "job")! as AnyObject).count>0){
                            
                            let job = (responseObject.object(forKey: "response") as AnyObject).object(forKey: "job") as! NSDictionary
                            self.descLbl.text=self.theme.CheckNullValue(job.object(forKey: "job_summary"))
                            
                            
                            let currencyStr=self.theme.getCurrencyCode(job.object(forKey: "currency") as! String)
                            NSLog("get currency=%@",currencyStr )
                            self.descLbl.sizeToFit()
                            self.needPaymentStr=self.theme.CheckNullValue(job.object(forKey: "need_payment"))
                            self.cashoption = self.theme.CheckNullValue(job.object(forKey: "cash_option"))
                            self.review = self.theme.CheckNullValue(job.object(forKey: "review"))
                            
                            if(self.needPaymentStr=="1"){
                                self.bottomView.isHidden=false
                            }else{
                                
                                self.bottomView.isHidden=true
                            }
                            
                            
                            
                            
                            
                            let  listArr:NSArray=((responseObject.object(forKey: "response") as AnyObject).object(forKey: "job") as AnyObject).object(forKey: "billing") as! NSArray
                            self.fareSummaryArr.removeAllObjects()
                            for (_, element) in listArr.enumerated() {
                                let result1:JobDetailRecord=JobDetailRecord()
                                let tit = self.theme.CheckNullValue((element as AnyObject).object(forKey: "title"))
                                result1.jobTitle="\(tit)"
                                result1.jobStatus=self.theme.CheckNullValue((element as AnyObject).object(forKey: "dt"))
                                if result1.jobStatus == "0"
                                {
                                    
                                    result1.jobDesc=self.theme.CheckNullValue((element as AnyObject).object(forKey: "amount"))
                                }
                                    
                                else
                                {
                                    result1.jobDesc="\(currencyStr)\(self.theme.CheckNullValue((element as AnyObject).object(forKey: "amount")))"
                                    
                                }
                                self.fareSummaryArr .add(result1)
                            }
                            
                        }else{
                            self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                        }
                        self.fareTblView.reload()
                        //This code will run in the main thread:
                        
                        var frame: CGRect = self.fareTblView.frame
                        frame.origin.y=self.jobIdLbl.frame.origin.y+self.jobIdLbl.frame.size.height+20
                        frame.size.height = self.fareTblView.contentSize.height+20;
                        self.fareTblView.frame = frame;
                        
                        
                        if(self.needPaymentStr=="1"){
                            self.fareScrollView.contentSize=CGSize(width: self.fareScrollView.frame.size.width, height: self.fareScrollView.frame.origin.y+self.fareTblView.frame.size.height+70)
                            
                        }else{
                            
                            self.fareScrollView.contentSize=CGSize(width: self.fareScrollView.frame.size.width, height: self.fareScrollView.frame.origin.y+self.fareTblView.frame.size.height)
                            
                        }
                        
                        
                    }
                        
                        
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
                        
                    }
                    
                    
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
                }
            }
            
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fareSummaryArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->     UITableViewCell {
        
        
        let cell:FareDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "fareDetailCellIdentifier") as! FareDetailTableViewCell
        cell.loadFareTableCell(fareSummaryArr.object(at: indexPath.row) as! JobDetailRecord)
        cell.selectionStyle=UITableViewCell.SelectionStyle.none
        
        
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
    @IBAction func didClickReceiveCashBtn(_ sender: AnyObject) {
        
        
        let objFarevc = self.storyboard!.instantiateViewController(withIdentifier: "OTPVCSID") as! PlumberOTPViewController
        objFarevc.jobIDStr=jobIDStr
        self.navigationController?.pushViewController(objFarevc, animated: true)
        
        
    }
    @IBAction func didClickReceivePaymentBtn(_ sender: AnyObject) {
        if self.needPaymentStr == "1"{
            RequestPayment()
        }
        else{
            let objFarevc = self.storyboard!.instantiateViewController(withIdentifier: "RatingsVCSID") as! RatingsViewController
            objFarevc.jobIDStr = jobIDStr
            self.navigationController!.pushViewController(withFade: objFarevc, animated: false)
        }
    }
    func RequestPayment(){
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                                 "job_id":"\(jobIDStr)"]
        print(Param)
        self.showProgress()
        url_handler.makeCall(RequestPaymentUrl, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            self.DismissProgress()
            
            // self.DismissProgress()
            if(error != nil)
            {
                self.DismissProgress()
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    //responseObject?.objectForKey("status") as! NSString
                    if(status == "1")
                    {
                        let resp:NSString=responseObject.object(forKey: "response") as! NSString
                        self.view.makeToast(message:resp as String, duration: 20, position: HRToastPositionDefault as AnyObject, title:appNameJJ)

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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        self.view.hideToastActivity()
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
