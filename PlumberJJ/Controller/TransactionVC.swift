//
//  TransactionVC.swift
//  Plumbal
//
//  Created by Casperon on 06/02/17.
//  Copyright © 2017 Casperon Tech. All rights reserved.
//

import UIKit

class TransactionVC: RootBaseViewController,UITableViewDataSource,UITableViewDelegate {
    var themes:Theme=Theme()
    let URL_Handler:URLhandler=URLhandler()
    var PageCount:NSInteger=0
    var refreshControl:UIRefreshControl=UIRefreshControl()
    var jobidArray : NSMutableArray = NSMutableArray()
    var categoryArray : NSMutableArray = NSMutableArray()
    var amountArray : NSMutableArray = NSMutableArray()
    var CurrencyCodeArray : NSMutableArray = NSMutableArray()
    @IBOutlet var lbltransaction: UILabel!

    @IBOutlet var transaction_table: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "transacationTableViewCell", bundle:nil)
        self.transaction_table.register(nibName, forCellReuseIdentifier: "transactionCell")
        transaction_table.estimatedRowHeight = 110
        transaction_table.rowHeight = UITableView.automaticDimension
        lbltransaction.text = themes.setLang("transactions")
     self.showProgress()
    self.GetTransaction()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func menubtnAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        // Present the view controller
        //
        self.frostedViewController.presentMenuViewController()
    }
    
    func GetTransaction()  {
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()

        let param=["provider_id":"\(objUserRecs.providerId)"]
        URL_Handler.makeCall(Get_TransactionUrl, param: param as NSDictionary) { (responseObject, error) -> () in
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
                    
                        let Status = self.themes.CheckNullValue( Dict.object(forKey: "status"))
                    
                    if(Status == "1")
                    {
                        let ResponseDic:NSDictionary=Dict.object(forKey: "response") as! NSDictionary
                        let TotalJobsArray : NSArray = ResponseDic.object(forKey: "jobs") as! NSArray
                        
                        for transac in TotalJobsArray
                        {
                            let transacDict = transac as! NSDictionary
                            let jobid=self.themes.CheckNullValue(transacDict.object(forKey: "job_id"))
                            self.jobidArray.add(jobid)
                            let category=self.themes.CheckNullValue(transacDict.object(forKey: "category_name"))
                            self.categoryArray.add(category)
                            let amount=self.themes.CheckNullValue(transacDict.object(forKey: "total_amount"))
                            
                            self.amountArray.add("\(amount)")
                            
                            let currency = self.themes.CheckNullValue(transacDict.object(forKey: "currency_code"))
                            
                            self.CurrencyCodeArray.add(self.theme.getCurrencyCode(currency as String))

                            
                            

                            
                        }
                        
0
                        
                        self.transaction_table.reload()

                    }
                    else
                    {
                        self.transaction_table.isHidden=true
                        
                        let Response = self.theme.CheckNullValue(Dict.object(forKey: "response"))
//                        self.view.makeToast(message:"\(String(describing: Response))", duration: 3, position: HRToastPositionDefault as AnyObject, title: "Oops!!!")
                        
                        
                    }
                    
                }
                else
                {
                        self.view.makeToast(message:"Network Failure", duration: 4, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                }
            }
            
        }
    }
  
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if jobidArray.count == 0 {
            loadNoData()
            return 1
        }
        transaction_table.backgroundView = nil
        
        return 1
    }
    func loadNoData() {
        let nibView = Bundle.main.loadNibNamed("EmptyDataView", owner: self, options: nil)![0] as! EmptyDataView
        nibView.frame = self.transaction_table.bounds;
        nibView.msgLbl.text = self.theme.setLang("no_transactions")
        self.transaction_table.backgroundView=nibView
        transaction_table.backgroundView = nibView
        transaction_table.separatorStyle = .none
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if jobidArray.count > 0{
            return self.jobidArray.count

        }
        else{
            return 0

        }
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as! transacationTableViewCell
        
      Cell.totalview.layer.shadowOffset = CGSize(width: 2, height: 2)
       // Cell.totalview.layer.cornerRadius=14;
        Cell.totalview.layer.shadowOpacity = 0.2
        Cell.totalview.layer.shadowRadius = 2
          if jobidArray.count > 0
          {
      Cell.jobid.text = self.jobidArray.object(at: indexPath.row) as? String
         Cell.category.text = self.categoryArray.object(at: indexPath.row) as? String
         Cell.totalamount.text = "\(self.CurrencyCodeArray.object(at: (indexPath.row)))\(self.amountArray.object(at: indexPath.row))"
            
            
            
            
        }
        
        
        
        return Cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Controller:TransactionDetailsViewController=self.storyboard?.instantiateViewController(withIdentifier: "transDetail") as! TransactionDetailsViewController
        Controller.GetJob_id = self.jobidArray.object(at: indexPath.row) as! String
        self.theme.saveappCurrencycode(self.theme.CheckNullValue(self.CurrencyCodeArray.object(at: indexPath.row)))
        self.navigationController?.pushViewController(withFade: Controller, animated: false)

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
