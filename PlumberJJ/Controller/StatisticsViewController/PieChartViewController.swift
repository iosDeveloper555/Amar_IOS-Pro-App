//
//  PieChartViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/26/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit



class PieChartViewController: RootBaseViewController, MDRotatingPieChartDelegate, MDRotatingPieChartDataSource {
   
    var slicesData:Array<Data> = Array<Data>()
    var properties = Properties()

    @IBOutlet weak var lblClosedJob: UILabel!
    @IBOutlet weak var lblOnGoing: UILabel!
    @IBOutlet weak var lblUserCanceled: UILabel!
    @IBOutlet weak var lblTotlalJob: UILabel!
    
    @IBOutlet weak var lblCancelledByMe: UILabel!
    var lable:UILabel = UILabel()

    @IBOutlet weak var hintView: UIView!
    var pieChart:MDRotatingPieChart!

  //  var theme:Theme=Theme()
     var pieArr:NSMutableArray=[]
    var pieTitleArr:NSMutableArray=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        
 

        loadPieChart()
        getDataForPieChart()
        // Do any additional setup after loading the view.
    }
    
  
   
    
    func loadPieChart(){
       
        

    }
    
     override func applicationLanguageChangeNotification(_ notification: Notification) {
        
      
        
    }

    func didOpenSliceAtIndex(_ index: Int) {
        lable.isHidden = true
        print("Open slice at \(index)")
    }
    
    func didCloseSliceAtIndex(_ index: Int) {
        print("Close slice at \(index)")
    }
    
    func willOpenSliceAtIndex(_ index: Int) {
        print("Will open slice at \(index)")
    }
    
    func willCloseSliceAtIndex(_ index: Int) {
        print("Will close slice at \(index)")
    }
    
    //Datasource
    func colorForSliceAtIndex(_ index:Int) -> UIColor {
        return slicesData[index].color
    }
    
    func valueForSliceAtIndex(_ index:Int) -> CGFloat {
        return slicesData[index].value
    }
    
    func labelForSliceAtIndex(_ index:Int) -> String {
        return slicesData[index].label
    }
    
    func numberOfSlices() -> Int {
        return slicesData.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
       // refresh()
    }
    
    func refresh()  {
        pieChart.build()
    }
   
    func getDataForPieChart(){
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)"]
         print(Param)
        print(JobsStatsUrl)
        
        url_handler.makeCall(JobsStatsUrl, param: Param as NSDictionary) {
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
                        var Titlearray = [String]()
                        var percentarray = [String]()
                        let  listArr:NSArray=(responseObject.object(forKey: "response") as AnyObject).object(forKey: "jobs") as! NSArray
                        var total = Double()
                            for (indx,element)  in listArr.enumerated(){
                                let str:NSString = (element as AnyObject).object(forKey: "title")as! NSString
                                let str1:NSString = (element as AnyObject).object(forKey: "jobs_count")as! NSString
                                if indx == 0
                                {
                                   
                                    total = str1.doubleValue
                                    
                                }else{
                                
                                let doubleval = str1.doubleValue/total * 100
                                    self.pieArr.add(String(format:"%f", doubleval))
                                    self.pieTitleArr.add(str)
                                }
                                Titlearray.append(str as String)
                                percentarray.append(str1 as String)
                                
                            }

                          self.loaddataInPie(self.pieArr, pieTitleArray:  self.pieTitleArr)
                        print("get datas \(ratingRec.PercentageArray)")
                        
                        self.lblTotlalJob.text = "\(Language_handler.VJLocalizedString("total_jobs", comment: nil))\("[\(percentarray[0])]")"
                        self.lblClosedJob.text =  "\(Language_handler.VJLocalizedString("closed_jobs", comment: nil)) \("[\(percentarray[1])]")"
                        self.lblOnGoing.text =  "\(Language_handler.VJLocalizedString("ongoing_jobs", comment: nil))\("[\(percentarray[2])]")"
                        self.lblUserCanceled.text = "\(Language_handler.VJLocalizedString("user_cancelled_job", comment: nil)) \("[\(percentarray[3])]")"
                        self.lblCancelledByMe.text = "\(Language_handler.VJLocalizedString("job_cancelled_me", comment: nil))\("[\(percentarray[4])]")"
                    }
                    else
                    {
                        
                        let errormsg : String = self.theme.CheckNullValue(responseObject.object(forKey: "response"))
                        self.view.makeToast(message:errormsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
            
        }
    }
    
    func loaddataInPie(_ pieArray:NSMutableArray ,pieTitleArray:NSMutableArray){
        pieChart = MDRotatingPieChart(frame: CGRect(x: 0,y: 10 , width: view.frame.width, height: view.frame.width))

            self.slicesData = [
                Data(myValue: CGFloat((pieArr.object(at: 0) as! NSString).floatValue), myColor: UIColor(red: (77/255), green: (206/255), blue: (255/255), alpha: 1), myLabel:pieTitleArr.object(at: 0) as! String),
                Data(myValue: CGFloat((pieArr.object(at: 1) as! NSString).floatValue), myColor: UIColor(red: (132/255), green: (194/255), blue:(37/255), alpha: 1), myLabel:pieTitleArr.object(at: 1) as! String),
                Data(myValue: CGFloat((pieArr.object(at: 2) as! NSString).floatValue), myColor:UIColor(red: (255/255), green: (81/255), blue:(243/255), alpha: 1), myLabel:pieTitleArr.object(at: 2) as! String),
                Data(myValue: CGFloat((pieArr.object(at: 3) as! NSString).floatValue), myColor: UIColor(red: (255/255), green:(197/255), blue:(148/255), alpha: 1), myLabel:pieTitleArr.object(at: 3) as! String)
               ]
        
       
        
        pieChart.delegate = self
        pieChart.datasource = self

        view.addSubview(pieChart)
        
          refresh()
//        lable = UILabel(frame: CGRectMake(0, 0, view.frame.width, 45))
//        lable.textAlignment = NSTextAlignment.Center
//        lable.numberOfLines = 2
//        lable.textColor = UIColor.blueColor()
//        lable.text = "Click On the Pie-Chart to View the Percentage"
//        lable.font = UIFont(name: "Helvetica Neue - Bold", size: 17)
//        
//         view.addSubview(lable)
       /* var properties = Properties()
        
        properties.smallRadius = 50
        properties.bigRadius = 120
        properties.expand = 25
        
        
        properties.displayValueTypeInSlices = .Percent
        properties.displayValueTypeCenter = .Label
        
        properties.fontTextInSlices = UIFont(name: "Arial", size: 12)!
        properties.fontTextCenter = UIFont(name: "Arial", size: 10)!
        
        properties.enableAnimation = true
        properties.animationDuration = 0.5
        
        
        let nf = NSNumberFormatter()
        nf.groupingSize = 3
        nf.maximumSignificantDigits = 2
        nf.minimumSignificantDigits = 2
        
        properties.nf = nf
        
        pieChart.properties = properties
        pieChart.build()
        hintView.hidden=false
        self.view.bringSubviewToFront(hintView)*/
        
    }
    class Data {
        var value:CGFloat
        var color:UIColor = UIColor.gray
        var label:String = ""
        
        init(myValue:CGFloat, myColor:UIColor, myLabel:String) {
            value = myValue
            color = myColor
            label = myLabel
        }
    }
}
