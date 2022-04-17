//
//  DailyEarningsViewController.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 8/13/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class DailyEarnings: NSObject {
    var Address = String()
    var Ammount = String()
    var BookingID = String()
    var CatName = String()
    var Date = String()
    var Time = String()
}

class DailyEarningsViewController: UIViewController {

    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var HeaderLbl: UILabel!
    @IBOutlet weak var HeaderEarningsTasksView: UIView!
    @IBOutlet weak var EarningsView: UIView!
    @IBOutlet weak var TasksView: UIView!
    @IBOutlet weak var JobsTableView: UITableView!
    @IBOutlet weak var EarningsIndicatorLbl: UILabel!
    @IBOutlet weak var TotalTasksLbl: UILabel!
    @IBOutlet weak var EarningsDateLbl: UILabel!
    @IBOutlet weak var TasksDateLbl: UILabel!
    @IBOutlet weak var TasksIndicatorLbl: UILabel!
    @IBOutlet weak var GradientView: UIView!
    @IBOutlet weak var TotalEarningsLbl: UILabel!
    
    let Themes = Theme()
    var JobsArray = [String]()
    let url_handler = URLhandler()
    var TaskDate = String()
    var CurrencySymbol = String()
    var TotalEarnings = String()
    var TotalTasks = String()
    var ObjDailyEarnings = [DailyEarnings]()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.Themes.addGradient(self.GradientView, colo1: .white, colo2: PlumberBottomGradient, direction: .ToptoBottom, Frame: CGRect(x: 0, y: 0, width: UIDevice.current.screenWidth, height: UIDevice.current.screenHeight), CornerRadius: false, Radius: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.Themes.yesTheDeviceisHavingNotch(){
            HeaderViewHeight.constant = 100
        }
      self.HeaderEarningsTasksView.isHidden = true
      
      self.RegisterNib()
      self.GetJobDetails()
        // Do any additional setup after loading the view.
    }
    
    func RegisterNib(){
        JobsTableView.register(UINib(nibName:"DailyEarningsTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyEarningsCell")
        JobsTableView.rowHeight = UITableView.automaticDimension
        JobsTableView.estimatedRowHeight = 150
    }
    
    func GetJobDetails(){
        self.Themes.showProgress(View: self.view)
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)","task_date":"\(TaskDate)"]
        url_handler.makeCall(DailyEarningsUrl, param: Param as NSDictionary){
            (responseObject, error) -> () in
            if(error != nil)
            {
                self.Themes.DismissProgress()
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {   self.Themes.DismissProgress()
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let Response = responseObject["response"] as? [String:Any] ?? [:]
                    let status=self.Themes.CheckNullValue(responseObject["status"])
                    if(status == "1")
                    {
                        self.CurrencySymbol = self.Themes.CheckNullValue(Response["currency"])
                        self.CurrencySymbol = self.Themes.getCurrencyCode(self.CurrencySymbol)
                        self.TotalEarningsLbl.attributedText = self.Themes.setfontForPrice(with: self.CurrencySymbol, self.TotalEarnings, using: .black)
                        let EarningArr = Response["earnings"] as? [Any] ?? []
                        for Object in EarningArr{
                            let Object = Object as? [String:Any]
                            let Earnings = DailyEarnings()
                            Earnings.Address = self.Themes.CheckNullValue(Object?["address"])
                            Earnings.Ammount = self.Themes.CheckNullValue(Object?["amount"])
                            Earnings.BookingID = self.Themes.CheckNullValue(Object?["booking_id"])
                            Earnings.CatName = self.Themes.CheckNullValue(Object?["category_name"])
                            Earnings.Date = self.Themes.CheckNullValue(Object?["date"])
                            Earnings.Time = self.Themes.CheckNullValue(Object?["time"])
                            self.ObjDailyEarnings.append(Earnings)
                        }
                        self.JobsTableView.reloadData()
                        self.SetUI()
                        self.HeaderEarningsTasksView.isHidden = false
                    }else{
                        self.Themes.DismissProgress()
                    }
                }
            }
        }
    }
    
    func SetUI(){
        self.HeaderLbl.text = self.Themes.setLang("Daily_report")
        self.EarningsIndicatorLbl.text = self.Themes.setLang("earnings")
        if self.ObjDailyEarnings.count == 1{
            self.TasksIndicatorLbl.text = self.Themes.setLang("task")
        }else{
            self.TasksIndicatorLbl.text = self.Themes.setLang("tasks")
        }
        self.TasksDateLbl.text = TaskDate
        self.TasksDateLbl.textColor = PlumberThemeColor
        self.TasksDateLbl.adjustsFontSizeToFitWidth = true
        self.EarningsDateLbl.text = TaskDate
        self.EarningsDateLbl.textColor = PlumberThemeColor
        self.EarningsDateLbl.adjustsFontSizeToFitWidth = true
        self.EarningsView.dropShadow(shadowOpacity: 0.8, shadowRadius: 10, Color: PlumberBottomGradient)
        self.TasksView.dropShadow(shadowOpacity: 0.8, shadowRadius: 10, Color: PlumberBottomGradient)
        self.EarningsView.layer.cornerRadius = 5
        self.TasksView.layer.cornerRadius = 5
        self.TotalTasksLbl.text = self.TotalTasks
    }
    
    @IBAction func didclickBackBtn(_ sender: Any) {
        self.navigationController?.popViewControllerwithFade(animated: false)
        self.ObjDailyEarnings.removeAll()
    }
}

extension DailyEarningsViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ObjDailyEarnings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier:"DailyEarningsCell", for: indexPath) as! DailyEarningsTableViewCell
        Cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let Array = self.ObjDailyEarnings[indexPath.row]
        Cell.TasksEarningsIndicatoLbl.text = self.Themes.setLang("task_earnings")
        Cell.TasksEarningsIndicatoLbl.adjustsFontSizeToFitWidth = true
        Cell.TasksEarningsIndicatoLbl.textColor = PlumberThemeColor
        Cell.DateAndTimeLbl.textColor = PlumberThemeColor
        Cell.BookingIdLbl.text = "\(self.Themes.setLang("booking_id")): \(Array.BookingID)"
        Cell.CategoryTypeLbl.text = Array.CatName
        Cell.DateAndTimeLbl.text = "\(Array.Time)"
        Cell.AddressLbl.text = Array.Address
        Cell.AddressLbl.adjustsFontSizeToFitWidth = true
        Cell.AmmountLbl.attributedText = self.Themes.setfontForPrice(with: self.CurrencySymbol, Array.Ammount, using: .black, currencyColor: PlumberThemeColor)
        return Cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Array = self.ObjDailyEarnings[indexPath.row]
        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
        objMyOrderVc.jobID = Array.BookingID
        self.navigationController?.pushViewController(withFade: objMyOrderVc, animated: false)
    }
    
}
