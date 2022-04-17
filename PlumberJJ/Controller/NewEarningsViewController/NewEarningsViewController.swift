//
//  NewEarningsViewController.swift
//  DriverReadyToEat
//
//  Created by Casperon iOS on 13/08/19.
//  Copyright © 2019 CasperonTechnologies. All rights reserved.
//

import UIKit

class NewEarningsViewController: RootViewController {

    //    MARK: - OUTLETS -
    
    @IBOutlet weak var MainHeader_Lbl: CustomLabelHeader!
    @IBOutlet weak var gradianView: UIView!
    @IBOutlet weak var earning_BgView: UIView!
    @IBOutlet weak var previousEarning_Btn: UIButton!
    @IBOutlet weak var nextEarning_Btn: UIButton!
    @IBOutlet weak var dateOfEarning_View: UIView!
    @IBOutlet weak var earningDate_Lbl: UILabel!
    @IBOutlet weak var weaklyEarnings: UILabel!
    @IBOutlet weak var barChart_BgView: UIView!
    @IBOutlet weak var barChart_CollectionView: UICollectionView!
    @IBOutlet weak var totalTask_BgView: UIView!
    @IBOutlet weak var totalTaskCount_Lbl: UILabel!
    @IBOutlet weak var totalworkhrs_BgView: UIView!
    @IBOutlet weak var totalworkhrs_Lbl: UILabel!
    @IBOutlet weak var totaltaskIndicator_lbl: UILabel!
    @IBOutlet weak var totalworkhrsIndicator_lbl: UILabel!
    @IBOutlet weak var NetfareIndicator_Lbl: UILabel!
    @IBOutlet weak var TapHere_Lbl: UILabel!
    @IBOutlet weak var BarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var outsidecellHorizontalView: UIView!
    @IBOutlet weak var OutsideCellViewHeight: NSLayoutConstraint!
    @IBOutlet weak var OutsideCellView: UIView!
    @IBOutlet weak var OutsideAmmountLbl: UILabel!
    @IBOutlet weak var OutsideCellBtn: UIButton!
    @IBOutlet weak var innerScrollView: UIView!
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var menu_Btn: UIButton!
    
    //    MARK: - Variables -
    
    var dailyEarningsArr = [DailyEarningsObject]()
    var BillingObjectsArray = [BillingCycleDict]()
    let Gradient = UIColor.init(red: 213/255.0, green: 238/255.0, blue: 252/255.0, alpha: 1)
    let Themes = Theme()
    let url_handler = URLhandler()
    var FirstDate = String()
    var LastDate = String()
    var CurrencySymb = String()
    var StartDatetoEndDate = String()
    var NetEarnings = String()
    var TotalTasks = String()
    var TotalWorkHours = String()
    var EarnAmount = String()
    var currentCalenderIndex = 0
    var didselectdate = String()
    var didselectEarnings = String()
    var barviewFrame: CGRect?
    var barviewcenter: CGPoint?
    var TaskerveryfirstjobDate = String()
    var DateStrArray = [String]()
    var BillingIndex = 0
    
    var isFromHomePage = Bool()

    //    MARK: - VC Functions -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.innerScrollView.isHidden = true
        self.registerNIB()
        self.setView()
        self.setDate()
//        self.GetDateArray()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
//        self.setView_AfterSubViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setView_AfterSubViews()
    }
    
    func setView() {
        if self.isFromHomePage == true{
            self.menu_Btn.isHidden = true
            self.BackBtn.isHidden = false
        }else{
            self.menu_Btn.isHidden = false
            self.BackBtn.isHidden = true
        }
        self.totalTask_BgView.layer.cornerRadius = 7
        self.barChart_BgView.layer.cornerRadius = 7
        self.totalworkhrs_BgView.layer.cornerRadius = 7
        self.NetfareIndicator_Lbl.text = self.Themes.setLang("Net_fare")
        self.TapHere_Lbl.text = self.Themes.setLang("tap_Here")
        self.totaltaskIndicator_lbl.text = self.Themes.setLang("total_tasks")
        self.totalworkhrsIndicator_lbl.text = self.Themes.setLang("total_work_hrs")
        self.earning_BgView.layer.cornerRadius = 7
        self.gradianView.backgroundColor = UIColor.white
        self.previousEarning_Btn.imageView?.contentMode = .scaleAspectFit
        self.previousEarning_Btn.tintColor = UIColor.lightGray.withAlphaComponent(0.6)
        self.nextEarning_Btn.imageView?.contentMode = .scaleAspectFit
        self.nextEarning_Btn.tintColor = UIColor.lightGray.withAlphaComponent(0.6)
    }

    func setView_AfterSubViews() {
        
        self.Themes.addGradient(self.gradianView, colo1: .white, colo2: PlumberBottomGradient, direction: .ToptoBottom, Frame: CGRect(x: 0, y: 0, width: UIDevice.current.screenWidth, height: UIDevice.current.screenHeight), CornerRadius: false, Radius: 0)

        self.OutsideCellView.layer.cornerRadius = self.OutsideCellView.frame.height / 2
        self.Themes.addGradient(self.OutsideCellView, colo1: lightorangecolor, colo2: .orange, direction: .LefttoRightDiagonal, Frame: CGRect(x: 0, y: 0, width: self.OutsideCellView.frame.width, height: self.OutsideCellView.frame.height), CornerRadius: true, Radius: self.OutsideCellView.frame.height / 2)
    }
    
    func registerNIB() {
        
        let BarChartCollectionViewCell = UINib.init(nibName: "BarChartCollectionViewCell", bundle:nil )
        self.barChart_CollectionView.register(BarChartCollectionViewCell, forCellWithReuseIdentifier: "BarChartCollectionViewCell")
    }
    
    func setDate(){
        let currentWeekdays = Date().getWeek(of: currentCalenderIndex)
        FirstDate = self.Themes.ConvertDate(Date: self.Themes.CheckNullValue(currentWeekdays.first!), FromDateStr:"yyyy-MM-dd HH:mm:ss Z" , ToDateStr: "yyyy-MM-dd")
        LastDate = self.Themes.ConvertDate(Date: self.Themes.CheckNullValue(currentWeekdays.last!), FromDateStr:"yyyy-MM-dd HH:mm:ss Z" , ToDateStr: "yyyy-MM-dd")
        StartDatetoEndDate = "\(self.Themes.ConvertDate(Date: self.Themes.CheckNullValue(currentWeekdays.first!), FromDateStr:"yyyy-MM-dd HH:mm:ss Z" , ToDateStr: "MMM d")) - \(self.Themes.ConvertDate(Date: self.Themes.CheckNullValue(currentWeekdays.last!), FromDateStr:"yyyy-MM-dd HH:mm:ss Z" , ToDateStr: "MMM d"))"
        if currentCalenderIndex == 0{
            self.nextEarning_Btn.isHidden = true
        }else{
            self.nextEarning_Btn.isHidden = false
        }
        self.DateStrArray = currentWeekdays.map{(self.Themes.ConvertDate(Date: self.Themes.CheckNullValue($0), FromDateStr: "yyyy-MM-dd HH:mm:ss Z", ToDateStr: "yyyy-MM-dd"))}
        self.GetEarnings()
    }
    
    func GetDateforParam(atIndex : Int){
        let BillDetails = self.BillingObjectsArray[atIndex]
        self.FirstDate = BillDetails.start_date
        self.LastDate = BillDetails.end_date
        self.GetEarnings()
    }
    
    func GetEarnings(){
        self.outsidecellHorizontalView.isHidden = true
        self.OutsideCellView.isHidden = true
        self.Themes.showProgress(View: self.view)
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)","start_week":"\(FirstDate)","end_week":"\(LastDate)"]
        url_handler.makeCall(MainEarningsUrl, param: Param as NSDictionary){
            
            (responseObject, error) -> () in
            if(error != nil)
            {
                self.Themes.DismissProgress()
//                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                self.Themes.DismissProgress()
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    self.Themes.DismissProgress()
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let Response = responseObject["response"] as? [String:Any] ?? [:]
                    let status=self.Themes.CheckNullValue(responseObject["status"])
                    if(status == "1") || (status == "2")
                    {
                        self.TaskerveryfirstjobDate = self.Themes.CheckNullValue(Response["first_job_date"])
                        if self.DateStrArray.contains(self.TaskerveryfirstjobDate) || (self.TaskerveryfirstjobDate == ""){
                            self.previousEarning_Btn.isHidden = true
                        }else{
                            self.previousEarning_Btn.isHidden = false
                        }
                        
                        let Billing = Response["billing"] as? [Any] ?? []
//                        self.BillingObjectsArray.append(BillingCycleDict.init(Week_id: "" , Start_date: self.FirstDate, End_date: self.LastDate))
                        for Item in Billing{
                            let Item = Item as? [String:Any] ?? [:]
                            let _id = self.Themes.CheckNullValue(Item["_id"])
                            let _end_date = self.Themes.ConvertDate(Date: self.Themes.CheckNullValue(Item["end_date"]), FromDateStr: "yyyy-MM-dd'T'HH:mm:ss.sssZ", ToDateStr: "yyyy-MM-dd")
                            let _start_date = self.Themes.ConvertDate(Date: self.Themes.CheckNullValue(Item["start_date"]), FromDateStr: "yyyy-MM-dd'T'HH:mm:ss.sssZ", ToDateStr: "yyyy-MM-dd")
                            
                            self.BillingObjectsArray.append(BillingCycleDict.init(Week_id: _id, Start_date: _start_date, End_date: _end_date))
                        }
                        
                        dump(self.BillingObjectsArray)
                        
                        let WeeklyEarningsArray = Response["weekly_earnings"] as? [Any] ?? []
                        self.dailyEarningsArr.removeAll()
                        for Datas in WeeklyEarningsArray{
                            let Datas = Datas as? [String:Any]
                            self.CurrencySymb = self.Themes.getCurrencyCode(self.Themes.CheckNullValue(Datas?["currency"]))
                            self.NetEarnings = self.Themes.CheckNullValue(Datas?["total_earnings"])
                            self.TotalTasks = self.Themes.CheckNullValue(Datas?["total_task"])
                            self.TotalWorkHours = self.Themes.CheckNullValue(Datas?["total_worked_hours"])
                            let SplitWorkHrs = self.TotalWorkHours.components(separatedBy: ".")
                            let HrsVal = "\(SplitWorkHrs[0])h"
                            let MinsVal = "\(SplitWorkHrs[1])m"
                            self.totalworkhrs_Lbl.text = "\(HrsVal):\(MinsVal)"
                            self.earningDate_Lbl.text = self.StartDatetoEndDate
                            
                            DispatchQueue.main.async {
//                                self.Themes.addGradient(self.dateOfEarning_View, colo1: lightorangecolor, colo2: .orange, direction: .LefttoRight, Frame: CGRect(x: 0, y: 0, width: self.dateOfEarning_View.frame.width, height: self.dateOfEarning_View.frame.height), CornerRadius: true, Radius: self.dateOfEarning_View.frame.height / 2)
                                self.dateOfEarning_View.backgroundColor = lightorangecolor.withAlphaComponent(0.25)
                                self.dateOfEarning_View.layer.cornerRadius = self.dateOfEarning_View.frame.height/2
                            }
                            
                            self.weaklyEarnings.attributedText = self.Themes.setfontForPrice(with: self.CurrencySymb, self.NetEarnings, using: .black)
                            self.totalTaskCount_Lbl.text = self.TotalTasks
                            let EarningsArr = Datas?["earnings"] as? [Any]  ?? []
                            if EarningsArr.count != 0 {
                                for EarningsDict in EarningsArr {
                                    let EarningsDict = EarningsDict as? [String:Any]
                                    self.EarnAmount = self.Themes.CheckNullValue(EarningsDict?["earnings"])
                                    
                                    let JobDate = self.Themes.ConvertDate(Date: self.Themes.CheckNullValue(EarningsDict?["job_date"]), FromDateStr: "yyyy-MM-dd", ToDateStr: "d MMM").components(separatedBy: " ")
                                    
                                    let JobYear = self.Themes.ConvertDate(Date: self.Themes.CheckNullValue(EarningsDict?["job_date"]), FromDateStr: "yyyy-MM-dd", ToDateStr: "MMM d, yyyy").components(separatedBy: ",")
                                    
                                    let taskCount = self.Themes.CheckNullValue(EarningsDict?["task_count"])
                                    
                                    self.dailyEarningsArr.append(DailyEarningsObject.init(earnings: self.EarnAmount, chart_Date: JobDate[0], chart_Month: JobDate[1], isSelected: false, task_count: taskCount, chart_Year: JobYear[1]))
                                }
                                self.TapHere_Lbl.isHidden = false
                                self.barChart_BgView.isHidden = false
                                self.BarViewHeight.constant = 220
                            }else{
                                self.TapHere_Lbl.isHidden = true
                                self.barChart_BgView.isHidden = true
                                self.BarViewHeight.constant = 0
                            }
                        }
                        self.innerScrollView.isHidden = false
                    }/*else if(status == "2"){
                        self.Themes.DismissProgress()
                        self.barChart_BgView.isHidden = true
                        self.BarViewHeight.constant = 0
                        self.TaskerveryfirstjobDate = self.Themes.CheckNullValue(Response["first_job_date"])
                        if self.DateStrArray.contains(self.TaskerveryfirstjobDate) || (self.TaskerveryfirstjobDate == ""){
                            self.previousEarning_Btn.isHidden = true
                        }else{
                            self.previousEarning_Btn.isHidden = false
                        }
                        let WeeklyEarningsArray = Response["weekly_earnings"] as? [Any] ?? []
                        self.dailyEarningsArr.removeAll()
                        for Datas in WeeklyEarningsArray{
                            let Datas = Datas as? [String:Any]
                            self.CurrencySymb = self.Themes.getCurrencyCode(self.Themes.CheckNullValue(Datas?["currency"]))
                            self.NetEarnings = self.Themes.CheckNullValue(Datas?["total_earnings"])
                            self.TotalTasks = self.Themes.CheckNullValue(Datas?["total_task"])
                            self.TotalWorkHours = self.Themes.CheckNullValue(Datas?["total_worked_hours"])
                            let SplitWorkHrs = self.TotalWorkHours.components(separatedBy: ".")
                            let HrsVal = "\(SplitWorkHrs[0])h"
                            let MinsVal = "\(SplitWorkHrs[1])m"
                            self.totalworkhrs_Lbl.text = "\(HrsVal):\(MinsVal)"
                            self.earningDate_Lbl.text = self.StartDatetoEndDate
                            
                            DispatchQueue.main.async {
                                self.Themes.addGradient(self.dateOfEarning_View, colo1: lightorangecolor, colo2: .orange, direction: .LefttoRight, Frame: CGRect(x: 0, y: 0, width: self.dateOfEarning_View.frame.width, height: self.dateOfEarning_View.frame.height), CornerRadius: true, Radius: self.dateOfEarning_View.frame.height / 2)
                            }
                            
                            self.weaklyEarnings.attributedText = self.Themes.setfontForPrice(with: self.CurrencySymb, self.NetEarnings, using: .black)
                            self.totalTaskCount_Lbl.text = self.TotalTasks
                        }
                        self.innerScrollView.isHidden = false
                    }*/
                    self.barChart_CollectionView.reloadData()
                }
            }
        }
    }
   
//    func GetDateArray(){
//        var DateArray = [Any]()
//        var FinalDateArray = [Any]()
//        let calendar = NSCalendar.current
//        let Start = "2019-08-24"
//        let End = "2019-08-31"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//        var dateOne = dateFormatter.date(from:Start)!
//        let dateTwo = dateFormatter.date(from:End)!
//
//        while dateOne <= dateTwo {
//            print(dateOne)
//            DateArray.append(dateOne)
//            dateOne = calendar.date(byAdding: .day, value: 1, to: dateOne)!
//        }
//
//        dump(DateArray)
//        for SingleDate in DateArray{
//            let SingleDate = SingleDate as? Date
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let myDate = dateFormatter.string(from: SingleDate!)
//            FinalDateArray.append(myDate)
//        }
//        dump(FinalDateArray)
//    }
    
    
    @IBAction func didclickBackBtn(_ sender: Any) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
    @IBAction func didclickmenuBtn(_ sender: Any) {
//        self.view.endEditing(true)
//        self.frostedViewController.view.endEditing(true)
//        // Present the view controller
//        self.frostedViewController.presentMenuViewController()
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    @IBAction func didclickPreviousWeek(_ sender: Any) {
        currentCalenderIndex -= 1
        self.BillingIndex += 1
//        self.GetDateforParam(atIndex: self.BillingIndex)
        self.setDate()
    }
    @IBAction func didclickNxtWeek(_ sender: Any) {
        currentCalenderIndex += 1
        self.BillingIndex -= 1
//        self.GetDateforParam(atIndex: self.BillingIndex)
        self.setDate()
    }
    
    @IBAction func didclickOutsideCellBtn(_ sender: UIButton) {
        let index = sender.tag
        let DailyEarningsVC = self.storyboard!.instantiateViewController(withIdentifier: "DailyEarningsVCID") as! DailyEarningsViewController
        let EarningsArr = dailyEarningsArr[index]
        if EarningsArr.task_count != "0"{
            let Date = "\(EarningsArr.chart_Month) \(EarningsArr.chart_Date),\(EarningsArr.chart_Year)"
            DailyEarningsVC.TaskDate = self.Themes.ConvertDate(Date: Date, FromDateStr: "MMM d, yyyy", ToDateStr: "yyyy-MM-dd")
            DailyEarningsVC.TotalEarnings = EarningsArr.earnings
            DailyEarningsVC.TotalTasks = EarningsArr.task_count
            self.navigationController!.pushViewController(withFade: DailyEarningsVC, animated: false)
        }
    }
    
    @IBAction func didclickTotalWeekBtn(_ sender: Any) {
        if self.TotalTasks != "0"{
            let WeeklyEarnings = self.storyboard!.instantiateViewController(withIdentifier: "WeeklyEarningsVCID") as! WeeklyEarningsViewController
            WeeklyEarnings.ObjEarningsDetail = self.dailyEarningsArr.filter{($0.task_count != "0")}
            self.navigationController!.pushViewController(withFade: WeeklyEarnings, animated: false)
        }
    }
    
}

extension NewEarningsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dailyEarningsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarChartCollectionViewCell", for: indexPath) as! BarChartCollectionViewCell
        let dailyValue = self.dailyEarningsArr[indexPath.row]
        cell.dateLbl.text = dailyValue.chart_Date
        cell.monthLbl.text = dailyValue.chart_Month.capitalizingFirstLetter()
        DispatchQueue.main.async {
            cell.barView.layer.sublayers?.removeAll()
            let barTotalHeight = cell.baseView.frame.height - cell.dateView.frame.height - 5
            let maxEarning = CGFloat((self.dailyEarningsArr.map{(Double($0.earnings) ?? 0.00)}.sorted{($0 > $1)}.first) ?? 0.00)
            let barHeight = (barTotalHeight / maxEarning) * CGFloat(Double(dailyValue.earnings) ?? 0.00)
            print("The barHeight is ===>\(barHeight)")
            if barHeight > 0{
                cell.isUserInteractionEnabled = true
            }else{
                cell.isUserInteractionEnabled = false
            }
            let width = (self.barChart_CollectionView.frame.width / 7) - 5
            if dailyValue.isSelected {
                cell.barViewBottom.constant = 0
                cell.barViewLeading.constant = 0
                cell.barViewHeight.constant = barHeight + 5
                cell.barView.isHidden = false
                self.outsidecellHorizontalView.isHidden = false
                self.OutsideCellView.isHidden = false
                self.Themes.addGradient(cell.barView, colo1: lightorangecolor, colo2: darkorangecolor, direction: .RighttoLeftDiagonal, Frame: CGRect(x: 0, y: 0, width: Int(width+5), height: Int(cell.barViewHeight.constant+5)), CornerRadius: true, Radius: 3)
            }else{
                cell.barViewBottom.constant = 5
                cell.barViewLeading.constant = 5
                cell.barViewHeight.constant = barHeight
                self.Themes.addGradient(cell.barView, colo1: .lightGray, colo2: .white, direction: .RighttoLeftDiagonal, Frame: CGRect(x: 0, y: 0, width: Int(width), height: Int(cell.barViewHeight.constant)), CornerRadius: true, Radius: 3)
            }
           
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        _ = self.dailyEarningsArr.enumerated().map({(index,value) in
                value.isSelected = index == indexPath.row
        })
        self.OutsideCellBtn.tag = indexPath.row
        let Data = dailyEarningsArr[indexPath.row]
        self.didselectdate = self.Themes.ConvertDate(Date: "\(Data.chart_Date) \(Data.chart_Month), \(Data.chart_Year)", FromDateStr: "d MMM, yyyy", ToDateStr: "MM/dd/yyyy")
        self.barviewFrame = barChart_CollectionView.layoutAttributesForItem(at: indexPath)?.frame
        self.didselectEarnings = "\(self.CurrencySymb)\(Data.earnings)"
        self.OutsideAmmountLbl.text = self.didselectEarnings
        self.OutsideAmmountLbl.adjustsFontSizeToFitWidth = true
        self.barviewcenter = barChart_CollectionView.layoutAttributesForItem(at: indexPath)?.center
        self.OutsideCellViewHeight.constant = CGFloat(self.barviewcenter?.x ?? 0.0)
        self.barChart_CollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let height = self.barChart_CollectionView.frame.height
            print("height",self.barChart_CollectionView.frame.width)
            let width = (self.barChart_CollectionView.frame.width / 7) - 5
            return CGSize(width: width, height: height)
    }

}

class DailyEarningsObject : NSObject{
    
    var earnings = String()
    var chart_Date = String()
    var chart_Month = String()
    var chart_Year = String()
    var task_count = String()
    var isSelected = Bool()
    
    init(earnings:String, chart_Date:String,chart_Month:String, isSelected:Bool,task_count:String,chart_Year:String) {
        
        self.earnings = earnings
        self.chart_Date = chart_Date
        self.chart_Month = chart_Month
        self.task_count = task_count
        self.chart_Year = chart_Year
        self.isSelected = isSelected
    }
  }

class BillingCycleDict: NSObject {
    var id = String()
    var start_date = String()
    var end_date = String()

    init(Week_id : String, Start_date : String, End_date : String) {
        self.id = Week_id
        self.start_date = Start_date
        self.end_date = End_date
    }
}

extension Date {
    var firstDateOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var lastDateOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let saturday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: saturday)
    }
    
    var cureentWeekMonday: Date {
        return Calendar.iso8601.date(from: Calendar.iso8601.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    
    func getWeek(of index:Int) -> [Date]{
        return (-1+(7 * index)...5+(7 * index)).compactMap{Calendar.iso8601.date(byAdding: DateComponents(day: $0), to: cureentWeekMonday)}
        // 0 -> Sunday 1 -> Monday 2 -> Tuesday 3 -> Sunday 4 -> Wednesday 5 -> Thursday 6 -> Saturday
    }
}

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
}
