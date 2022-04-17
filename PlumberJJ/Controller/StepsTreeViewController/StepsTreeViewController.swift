//
//  StepsTreeViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/28/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit



class StepsTreeViewController: RootBaseViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var stepScrollView: UIScrollView!
     @IBOutlet weak var stepTableView: UITableView!
    var stepsArr:NSMutableArray=[]
    var JobIdStr:String = ""
  //  var theme:Theme=Theme()
    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
         titleLbl.text="\(appNameShortJJ)"
        stepTableView.register(UINib(nibName: "StepTableViewCell", bundle: nil), forCellReuseIdentifier: "stepTblIdentifier")
        stepTableView.estimatedRowHeight = 55
        stepTableView.rowHeight = UITableView.automaticDimension
        stepTableView.tableFooterView = UIView()
        
        GetStepByStepDetails()
        
       
        // Do any additional setup after loading the view.
    }
   
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewControllerWithFlip(animated: false)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return stepsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->     UITableViewCell {
        
      
            let cell:StepTableViewCell = tableView.dequeueReusableCell(withIdentifier: "stepTblIdentifier") as! StepTableViewCell
            cell.loadStepTableCell(stepsArr.object(at: indexPath.row) as! StepByStepInfoRecord)
        cell.selectionStyle=UITableViewCell.SelectionStyle.none
        if(indexPath.row==0){
          cell.firstLbl.isHidden=true
        }
        if(indexPath.row==stepsArr.count-1){
             cell.lastLbl.isHidden=true
        }
       
        
        return cell
    }
    func GetStepByStepDetails(){
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
            "job_id":"\(JobIdStr)"]
        print(Param)
        self.showProgress()
        url_handler.makeCall(stepByStepInfoUrl  , param: Param as NSDictionary) {
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
                        
                        
                        if(((responseObject.object(forKey: "response") as AnyObject).object(forKey: "timeline") as AnyObject).count>0){
                            
                            
                            let  listArr:NSArray=(responseObject.object(forKey: "response") as AnyObject).object(forKey: "timeline") as! NSArray
                            self.stepsArr.removeAllObjects()
                            for (_, element) in listArr.enumerated() {
                                let result1:StepByStepInfoRecord=StepByStepInfoRecord()
                                if self.theme.CheckNullValue((element as AnyObject).object(forKey: "title")) != ""
                                {
                                    result1.title=self.theme.CheckNullValue((element as AnyObject).object(forKey: "title"))
                                    result1.date=self.theme.CheckNullValue((element as AnyObject).object(forKey: "date"))
                                    result1.Time=self.theme.CheckNullValue((element as AnyObject).object(forKey: "time"))
                                    result1.status=self.theme.CheckNullValue((element as AnyObject).object(forKey: "check"))
                                self.stepsArr .add(result1)
                                }
                            }
                            
                        }else{
                            self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title:appNameJJ)
                        }
                        self.stepTableView.reload()
                        //This code will run in the main thread:
                        
                        var frame: CGRect = self.stepTableView.frame
                        frame.size.height = self.stepTableView.contentSize.height+100;
                        self.stepTableView.frame = frame;
                        self.stepScrollView.contentSize=CGSize(width: self.stepScrollView.frame.size.width, height: self.stepTableView.frame.origin.y+self.stepTableView.frame.size.height)
                        
                        
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
