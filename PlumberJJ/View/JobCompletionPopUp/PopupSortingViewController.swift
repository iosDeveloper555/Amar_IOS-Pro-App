//
//  PopupSortingViewController.swift
//  PlumberJJ
//
//  Created by CASPERON on 10/08/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

import UIKit
protocol PopupSortingViewControllerDelegate {
   
    func pressedCancel(_ sender: PopupSortingViewController)
    
  
    
    func  passRequiredParametres(_ fromdate:NSString,todate: NSString,isAscendorDescend: Int,isToday: Int,isSortby: NSString)
    
    
}


class PopupSortingViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet var lblOrderBy: UILabel!
    @IBOutlet var applyview: SetColorView!
    @IBOutlet var datecheckmark: UIImageView!
    @IBOutlet var namecheckmark: UIImageView!
    @IBOutlet var datebtn: UIButton!
    @IBOutlet var Namebtn: UIButton!
    var delegate:PopupSortingViewControllerDelegate?
    var Globalindex:NSString=NSString()
     var dates: NSMutableArray!
    var convertDatesArr : NSMutableArray!
    var statusoforder : Int = 0
    var statusofsorting : NSString = NSString()
    var fromBtnisClicked : Bool!
    var toBtnisClicked :Bool!
    var fromDateval : NSString = NSString()
    var todateval : NSString = NSString()
    var themes:Theme=theme
    var todayInt : Int = 3

    @IBOutlet var checkmark3: UIImageView!
    @IBOutlet var checkmark4: UIImageView!
    @IBOutlet var checkmark5: UIImageView!

    @IBOutlet var checkmark2: UIImageView!
    @IBOutlet var checkmark1: UIImageView!
    @IBOutlet var orderbylabl: UILabel!
    @IBOutlet var ascendingbtn: UIButton!
    @IBOutlet var cancel: UIButton!

    @IBOutlet var applybtn: UIButton!
    @IBOutlet var Desendingbtn: UIButton!
    @IBOutlet var btnTodays: UIButton!
    @IBOutlet var btnRecent: UIButton!
    @IBOutlet var btnUpcoming: UIButton!

    @IBOutlet var todate: UIButton!
    @IBOutlet var fromdate: UIButton!
    
    @IBOutlet weak var lblSorting: UILabel!

    @IBOutlet var datepicker: UIPickerView!
    @IBAction func didclickoption(_ sender: AnyObject) {
        
        if sender.tag == 0
        {
           self.Callcanceldelegate()
        }
     else   if sender.tag == 1
        {
            datepicker.reloadAllComponents()
            fromBtnisClicked = true
            toBtnisClicked = false
            
            datepicker.isHidden = false
            applyview.isHidden = true;

        }
         else    if sender.tag == 10
            {
                statusofsorting = "name"
                namecheckmark.isHidden = false
                datecheckmark.isHidden = true

        }
      else   if   sender.tag == 11
    {
        statusofsorting = "date"
        namecheckmark.isHidden = true
        datecheckmark.isHidden = false


    }
       else     if sender.tag == 2
      {
     datepicker.reloadAllComponents()
        toBtnisClicked = true
        fromBtnisClicked = false
        datepicker.isHidden = false
        applyview.isHidden = true;
        }
        
         else    if sender.tag == 3
         {
            
            statusoforder = 1
            checkmark1.isHidden = false
            checkmark2.isHidden = true
        }
         else   if sender.tag == 4
        {
            
            statusoforder = -1
            checkmark1.isHidden = true
            checkmark2.isHidden = false
        }else if(sender.tag == 5){
            fromdate.isEnabled = false
            todate.isEnabled = false
            fromdate.alpha = 0.5
            todate.alpha = 0.5
            
            checkmark3.isHidden = false
            checkmark4.isHidden = true
            checkmark5.isHidden = true
            todayInt = 0
        }else if(sender.tag == 6){
            fromdate.isEnabled = false
            todate.isEnabled = false
            fromdate.alpha = 0.5
            todate.alpha = 0.5
            
            checkmark3.isHidden = true
            checkmark4.isHidden = false
            checkmark5.isHidden = true
            todayInt = 1
        }else if(sender.tag == 7){
            fromdate.isEnabled = false
            todate.isEnabled = false
            fromdate.alpha = 0.5
            todate.alpha = 0.5
            
            checkmark3.isHidden = true
            checkmark4.isHidden = true
            checkmark5.isHidden = false
            todayInt = 2
        }




    }
    
    @IBAction func didapplybtnclick(_ sender: AnyObject) {
//        
//        if fromDateval == ""
//        {
//            
//          //  self.themes.AlertView("", Message: "Please select  date", ButtonTitle: "Ok")
//          self.view.makeToast(message: "Please select  date", duration: 3, position: HRToastPositionDefault as AnyObject, title: "")
//
//            
//        }
//        else if todateval == ""
//        {
//          self.view.makeToast(message: "Please select  date", duration: 3, position: HRToastPositionDefault as AnyObject, title: "")
//
//        }
       
//        else
//        {
            self.delegate?.passRequiredParametres(fromDateval, todate:todateval, isAscendorDescend: statusoforder,isToday:todayInt,isSortby :"date")
            self.delegate?.pressedCancel(self)
       //}

    }
    
     func applicationLanguageChangeNotification(_ notification: Notification) {
          }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromdate.isEnabled = true
        todate.isEnabled = true
        lblOrderBy.text = themes.setLang("sort_by")
        btnTodays.setTitle(themes.setLang("today_book"), for: UIControl.State())
        btnRecent.setTitle(themes.setLang("recent_Book"), for: UIControl.State())
        btnUpcoming.setTitle(themes.setLang("upcome_book"), for: UIControl.State())
        
        
        if (trackingDetail.selectedPage == 1) || (trackingDetail.selectedPage == 2) {
            
            btnTodays.isEnabled = false
            btnTodays.alpha = 0.5
            btnUpcoming.alpha = 0.5
            btnRecent.alpha = 0.5
            btnUpcoming.isEnabled = false
            btnRecent.isEnabled = false
            
        }else if (trackingDetail.selectedPage == 0){
            btnTodays.alpha = 1
            btnUpcoming.alpha = 1
            btnRecent.alpha = 1
            
            btnTodays.isEnabled = true
            btnUpcoming.isEnabled = true
            btnRecent.isEnabled = true
            
        }

        
        lblSorting.text = Language_handler.VJLocalizedString("sorting", comment: nil)
        todate.setTitle(Language_handler.VJLocalizedString("to_date", comment: nil), for: UIControl.State())
        fromdate.setTitle(Language_handler.VJLocalizedString("from_date", comment: nil), for: UIControl.State())
        orderbylabl.text = Language_handler.VJLocalizedString("order_by", comment: nil)
        ascendingbtn.setTitle(Language_handler.VJLocalizedString("ascending", comment: nil), for: UIControl.State())
        Desendingbtn.setTitle(Language_handler.VJLocalizedString("descending", comment: nil), for: UIControl.State())
        applybtn.setTitle(Language_handler.VJLocalizedString("apply", comment: nil), for: UIControl.State())


        let startDate: Foundation.Date = Foundation.Date(timeIntervalSinceNow: -60 * 60 * 24 * 20)
        let endDate: Foundation.Date = Foundation.Date(timeIntervalSinceNow:60 * 60 * 24 * 19)
       dates = [startDate]
        let gregorianCalendar: Calendar = Calendar(identifier: .gregorian)
        let components: DateComponents = (gregorianCalendar as NSCalendar).components(.day, from: startDate, to: endDate, options:[])
      //  gregorianCalendar.components(NSDayCalendarUnit, fromDate: startDate, toDate: endDate, options: []
        for i in 1..<components.day! {
            var newComponents: DateComponents = DateComponents()
            newComponents.day = i
            let date: Foundation.Date = (gregorianCalendar as NSCalendar).date(byAdding: newComponents, to: startDate, options: [])!
            
            dates.add(date)
        }
        dates.add(endDate)
        convertDatesArr = NSMutableArray()
        
     for i in 0..<dates.count
     {
        convertDatesArr .add(self.stringDatePartOf(dates.object(at: i) as! Foundation.Date))
        
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Callcanceldelegate()
    {
        self.delegate?.pressedCancel(self)
    }

    //    (NSString*) stringDatePartOf:(NSDate*)date
    //    {
    //    NSDateFormatter *formatter = [[NSDateFormatter new];
    //    [formatter setDateFormat:@"yyyy-MM-dd"];
    //
    //    return [formatter stringFromDate:date];
    //    }
    
    func stringDatePartOf (_ date :Foundation.Date) -> NSString {
        let formatter: DateFormatter =
            DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date) as NSString
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return convertDatesArr.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let theView: UIView = UIView()
      
            let tView = UILabel()
        tView .text = convertDatesArr[row] as? String
        tView.font = UIFont(name:"Roboto",size:14 )
        tView.textAlignment = .center
        theView.addSubview(tView)
        return tView
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        datepicker.isHidden = true
        orderbylabl.isHidden = false;
        ascendingbtn.isHidden = false;
        Desendingbtn.isHidden = false;
        applyview.isHidden = false;

        if fromBtnisClicked == true
        {
            fromDateval = (convertDatesArr[row] as? String)! as NSString
        fromdate.setTitle(convertDatesArr[row] as? String, for:UIControl.State())
        }
        if toBtnisClicked == true
        {
            todateval = (convertDatesArr[row] as? String)! as NSString

            todate.setTitle(convertDatesArr[row] as? String, for:UIControl.State())

        }
        
        
    }


}
