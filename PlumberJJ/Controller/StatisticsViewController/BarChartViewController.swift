//
//  BarChartViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/26/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class BarChartViewController: RootBaseViewController {
var barController:StackedBarsExample=StackedBarsExample()
   // var theme:Theme=Theme()
    var barArr:NSMutableArray=[]
    var barTitleArr:NSMutableArray=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showProgress()
        getDataForBarChart()
        
        // Do any additional setup after loading the view.
    }
    func getDataForBarChart(){
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)"]
         print(Param)
        print(EarningStatsUrl)
        url_handler.makeCall(EarningStatsUrl, param: Param as NSDictionary) {
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
                        if(((responseObject.object(forKey: "response") as AnyObject).object(forKey: "earnings")! as AnyObject).count>=6){
                            let  listArr:NSArray=(responseObject.object(forKey: "response") as AnyObject).object(forKey: "earnings") as! NSArray
                            let _:NSString=(responseObject.object(forKey: "response") as AnyObject).object(forKey: "unit") as! NSString
                            for element in listArr {
                                let str:NSString = (element as AnyObject).object(forKey: "month")as! NSString
                                let str1 = (element as AnyObject).object(forKey: "amount")
                                
                                self.barArr.add(str1!)
                                self.barTitleArr.add(str)
                            }
                            
                            let str4=(responseObject.object(forKey: "response") as AnyObject).object(forKey: "max_earnings")
                           
                            
                            var max=Int("\(str4!)")
                           

                            var inter = Int("\( str4!)")!
                            if(inter==0)
                            {
                                inter=1
                                max=10
                            }
                            else if (inter>100000)
                            {
                                inter=100000
                                max=10000000
                            }
                                
                            else if (inter>10000)
                            {
                                inter=10000
                                max=100000
                            }else if (inter>1000)
                            {
                                inter=1000
                                max=10000
                            }
                            else if (inter>100)
                            {
                                inter=100
                                max=1000
                                
                            }
                            else if (inter>=10)
                            {
                                inter=10
                                max=100
                            }
                            else if (inter<10 && inter>=1)
                            {
                                inter=1
                                max=10
                            }
                            
                            let cCode1:NSString=(responseObject.object(forKey: "response") as AnyObject).object(forKey: "currency_code") as! NSString

                            let cCode=self.theme.getCurrencyCode(cCode1 as String)
                            self.addChild(self.barController)
                            self.barController.interval=inter
                            self.barController.maxEarnings=max
                            let stet:NSString = self.theme.CheckNullValue(self.theme.getappCurrencycode()) as NSString
                            self.barController.currencyCode=stet
                            self.barController.barArrSet=self.barArr
                            self.barController.barTitleArrset=self.barTitleArr
                            self.barController.showChart(horizontal: false)
                            self.view.addSubview(self.barController.view)
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
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
