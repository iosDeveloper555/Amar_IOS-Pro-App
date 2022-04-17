//
//  WeeklyEarningsViewController.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 8/12/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class WeeklyEarningsViewController: UIViewController {

    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var HeaderLbl: UILabel!
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var WeeklyEarningsTableView: UITableView!
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var GradientView: UIView!
    
    let Themes = Theme()
    var WeeklyReportArray = [Any]()
    var DateArray = [Any]()
    var ObjEarningsDetail = [DailyEarningsObject]()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.Themes.addGradient(self.GradientView, colo1: .white, colo2: PlumberBottomGradient, direction: .ToptoBottom, Frame: CGRect(x: 0, y: 0, width: self.GradientView.frame.width, height: self.GradientView.frame.height), CornerRadius: true, Radius: 6)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       WeeklyReportArray = ["","","","","","",""]
        if self.Themes.yesTheDeviceisHavingNotch(){
            HeaderViewHeight.constant = 100
        }
        self.SetUI()

    }

    func SetUI(){
        self.HeaderLbl.text = self.Themes.setLang("weekly_report")
    }
    
    @IBAction func didclickBackBtn(_ sender: Any) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
}

extension WeeklyEarningsViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ObjEarningsDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyReportCell", for: indexPath) as! WeeklyReportTableViewCell
        Cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let EarningsArr = ObjEarningsDetail[indexPath.row]
        let Date = "\(EarningsArr.chart_Month) \(EarningsArr.chart_Date),\(EarningsArr.chart_Year)"
        Cell.DateLbl.text = self.Themes.ConvertDate(Date: Date, FromDateStr: "MMM d, yyyy", ToDateStr: "dd/MM/yyyy")
        Cell.AmmountLbl.attributedText = self.Themes.setfontForPrice(with: self.Themes.getappCurrencycode(), EarningsArr.earnings, using: .black, currencyColor: PlumberThemeColor)
        Cell.NoOfTasksLbl.text = EarningsArr.task_count
        Cell.DateLbl.adjustsFontSizeToFitWidth = true
        Cell.DateLbl.textColor = PlumberThemeColor
        Cell.TasksLbl.textColor = PlumberThemeColor
        Cell.NetfareLbl.textColor = PlumberThemeColor
        if Int(EarningsArr.task_count)! == 0 || Int(EarningsArr.task_count)! == 1{
            Cell.TasksLbl.text = self.Themes.setLang("task")
        }else{
            Cell.TasksLbl.text = self.Themes.setLang("tasks")
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DailyEarningsVC = self.storyboard!.instantiateViewController(withIdentifier: "DailyEarningsVCID") as! DailyEarningsViewController
        let EarningsArr = ObjEarningsDetail[indexPath.row]
        if EarningsArr.task_count != "0"{
            let Date = "\(EarningsArr.chart_Month) \(EarningsArr.chart_Date),\(EarningsArr.chart_Year)"
            DailyEarningsVC.TaskDate = self.Themes.ConvertDate(Date: Date, FromDateStr: "MMM d, yyyy", ToDateStr: "yyyy-MM-dd")
            DailyEarningsVC.TotalEarnings = EarningsArr.earnings
            DailyEarningsVC.TotalTasks = EarningsArr.task_count
            self.navigationController!.pushViewController(withFade: DailyEarningsVC, animated: false)
        }
    }
}

