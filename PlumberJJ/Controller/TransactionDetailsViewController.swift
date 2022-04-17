//
//  TransactionDetailsViewController.swift
//  Plumbal
//
//  Created by Casperon on 07/02/17.
//  Copyright © 2017 Casperon Tech. All rights reserved.
//

import UIKit

class TransactionDetailsViewController: RootBaseViewController,UITableViewDelegate,UITableViewDataSource {
    var themes:Theme=Theme()
    let URL_Handler:URLhandler=URLhandler()
    var GetJob_id : String = ""
    var titleArray = NSArray()
    var descArray = NSArray()
    @IBOutlet var backbtn: UIButton!
    @IBOutlet var transacTableView: UITableView!

    @IBOutlet var lblViewTransac: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        lblViewTransac.text = theme.setLang("view_task_detail")
        transacTableView.estimatedRowHeight = 80
        let Nb=UINib(nibName: "TransactionDetailTableViewCell", bundle: nil)
        self.transacTableView.register(Nb, forCellReuseIdentifier: "TransactionDetailTableViewCell")
        
        self.showProgress()
        self.GetTransaction()
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func backAct(_ sender: AnyObject) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func GetTransaction()  {
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        
        
        let param=["provider_id":"\(objUserRecs.providerId)","booking_id":"\(GetJob_id)"]
        URL_Handler.makeCall(View_Transaction_Detail, param: param as NSDictionary) { (responseObject, error) -> () in
            self.DismissProgress()
            if(error != nil)
            {
                self.view.makeToast(message:self.theme.setLang("Network Failure"), duration: 4, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                
                //self.themes.AlertView("Network Failure", Message: "Please try again", ButtonTitle: "Ok")
            }
            else
            {
                 if(responseObject != nil)
                    {
                        let responseObject = responseObject!
                    let Dict:NSDictionary=responseObject
                    
                        let Status:NSString = self.themes.CheckNullValue( Dict.object(forKey: "status") as AnyObject) as NSString
                    
                    if(Status == "1")
                    {
                        let ResponseDic:NSDictionary=Dict.object(forKey: "response") as! NSDictionary
                        let TotalJobsArray : NSArray = ResponseDic.object(forKey: "jobs") as! NSArray
                        let categoryName = self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "category_name") as AnyObject)
                        let taskerName = self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "user_name") as AnyObject)
                        
                        let provider_lat = self.theme.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "lat_provider") as AnyObject)
                        let provider_lng = self.theme.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "lng_provider") as AnyObject)
                        
                        let exactaddress = self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "service_address") as AnyObject)
                        var taskAddress : String = String()
                        if exactaddress != ""
                        {
                            taskAddress = exactaddress
                        }
                        else
                        {
                            taskAddress  =  self.theme.CheckNullValue(self.theme.getAddressForLatLng(provider_lat, longitude: provider_lng, status: "short") as AnyObject)
                        }
                        //                        self.taskaddress.text = self.themes.CheckNullValue(TotalJobsArray.objectAtIndex(0).objectForKey("location"))!
                        let totalHour = self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "total_hrs") as AnyObject)
                        let perHour = "\(self.themes.getappCurrencycode())\(self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "per_hour") as AnyObject))"
                        let basePrice = "\(self.themes.getappCurrencycode())\(self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "min_hrly_rate") as AnyObject))"
                        let taskTime = self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "booking_time") as AnyObject)
                        
                        let bookingId = "\(self.GetJob_id as String)"
                        let serviceAMt = "\(self.themes.getappCurrencycode())\(self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "task_amount") as AnyObject))"
                        let commision = "\(self.themes.getappCurrencycode())\(self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "admin_commission") as AnyObject))"
                        
                        let total = "\(self.themes.getappCurrencycode())\(self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "total_amount") as AnyObject))"
                        
                        
                        var get_mis_amount = "\(self.themes.getappCurrencycode())\(self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "meterial_fee") as AnyObject))"
                        let mode = self.themes.CheckNullValue(self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "payment_mode") as AnyObject) as AnyObject)
                        
                        let ratetype = self.themes.CheckNullValue(self.themes.CheckNullValue((TotalJobsArray.object(at: 0) as AnyObject).object(forKey: "ratetype") as AnyObject) as AnyObject)
                        if get_mis_amount == self.themes.getappCurrencycode(){
                            get_mis_amount = "---"
                        }
                        
                        var cattype = String()
                     if ratetype == "Flat"
                     {
                        
                         cattype = "fixed_rate"
                        }
                     else{
                        cattype = "Price_per_Hour"
                        }
                       
                        self.titleArray = [ "Booking_Id",
                                            "Task_Category",
                                            "User_Name",
                                            "Task_Address",
                                            "Total_Hours",
                                           cattype,
                                          
                                            "Task_Time",
                                            "Task_Amount",
                                            "Material_Fees",
                                            "Payment_Mode",
                                            "Admin_Commission",
                                            "Total_Amount"]
                            
                            self.descArray = [bookingId,
                                              categoryName,
                                              
                                              taskerName,
                                              taskAddress,
                                              totalHour,
                                              perHour,
                                            
                                              taskTime,
                                              serviceAMt,
                                              get_mis_amount,
                                              mode,
                                              commision,
                                              total
                            ]
                            
                        
                        
                        
                        self.transacTableView.delegate = self
                        self.transacTableView.dataSource = self
                        self.transacTableView.reloadTable()
                        
                    }
                    else
                    {
                    }
                    
               
                    
                    
                }
                else
                {
                    self.view.makeToast(message:"Network Failure", duration: 4, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailTableViewCell") as! TransactionDetailTableViewCell
        Cell.lblTitle.text = theme.setLang((titleArray.object(at: indexPath.row) as? String)!)
        Cell.lblDescL.text = descArray.object(at: indexPath.row) as? String
        if indexPath.row == 0 || indexPath.row == titleArray.count-1{
            
            
            Cell.lblTitle.textColor = UIColor.init(red: 32/250, green: 109/250, blue: 22/250, alpha: 1)
            Cell.lblDescL.textColor = UIColor.init(red: 32/250, green: 109/250, blue: 22/250, alpha: 1)
        }else{
            Cell.lblTitle.textColor = UIColor.darkGray
            Cell.lblDescL.textColor = UIColor.gray
            
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
