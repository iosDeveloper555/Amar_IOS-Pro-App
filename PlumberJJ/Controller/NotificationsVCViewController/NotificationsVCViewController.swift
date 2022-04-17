//
//  NotificationsVCViewController.swift
//  PlumberJJ
//
//  Created by Casperon on 08/02/17.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit



class NotificationsVCViewController: RootBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var notification_table: STCollapseTableView!
    var ResponseDict : NSMutableArray = NSMutableArray()
    var  CategoryArray : NSMutableArray = NSMutableArray()
    var bookingidArray : NSMutableArray = NSMutableArray()
    @IBOutlet var titleLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        notification_table.register(UINib(nibName: "notificationVCTableViewCell", bundle: nil), forCellReuseIdentifier: "notification")
        notification_table.estimatedRowHeight = 90
        notification_table.rowHeight = UITableView.automaticDimension
        titleLabel.text = theme.setLang("notifications")

        
        notification_table.tableFooterView = UIView()
       // [self.tableView setExclusiveSections:!self.tableView.exclusiveSections];
        self.notification_table.exclusiveSections = self.notification_table.exclusiveSections

       self.notification_table.openSection(0, animated: false)

        showProgress()
        self.GetNotifications()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func GetNotifications(){
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["user_id":"\(objUserRecs.providerId)",
                                 "role":"tasker"
        ]
        // print(Param)
        
        url_handler.makeCall(Get_NotificationsUrl, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            
            self.notification_table.isHidden=false
//            self.notification_table.dg_stopLoading()
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let Dict:NSDictionary=responseObject
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                    
                    if(status == "1")
                    {
                        
                        self.ResponseDict = (Dict.value(forKey: "response")! as? NSMutableArray)!
                        
                        
                        for  Dict in self.ResponseDict
                        {
                            
                            let category : String = self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "booking_id") as AnyObject)
                            let jobid: String = self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "category") as AnyObject as AnyObject)
                            self.CategoryArray.add(category)
                            self.bookingidArray.add(jobid)
                            
                        }
                                self.notification_table.reloadTable()
                        
                    }
                    
                    else
                    {
                        let response : String = self.theme.CheckNullValue(Dict.object(forKey: "response") as AnyObject)
//                        self.view.makeToast(message:"\(response)", duration: 5, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                    }

                    
                    
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
        }
    }
    
    
    @IBAction func menubtnAct(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        // Present the view controller
        //
        self.frostedViewController.presentMenuViewController()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.CategoryArray.count
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.CategoryArray.count > 0){
            notification_table.backgroundView = nil
            
        }else{
            loadNoData()
        }
        return self.CategoryArray.count
    }
    func loadNoData() {
        let nibView = Bundle.main.loadNibNamed("EmptyDataView", owner: self, options: nil)![0] as! EmptyDataView
        nibView.frame = self.notification_table.bounds;
        nibView.msgLbl.text = self.theme.setLang("not_yet_notifi")
         nibView.msgLbl.font = PlumberLargeFont
        self.notification_table.backgroundView=nibView
        notification_table.backgroundView = nibView
        notification_table.separatorStyle = .none
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->     UITableViewCell {
        
        let cell3:UITableViewCell
        
        let cell:notificationVCTableViewCell = tableView.dequeueReusableCell(withIdentifier: "notification") as! notificationVCTableViewCell
        cell.message.text = self.theme.CheckNullValue((((ResponseDict.object(at: indexPath.section) as AnyObject).object(forKey: "messages") as AnyObject).object(at: indexPath.row) as AnyObject).object(forKey: "message") as AnyObject)
        
        cell.timelable.text = self.theme.CheckNullValue((((ResponseDict.object(at: indexPath.section) as AnyObject).object(forKey: "messages") as AnyObject).object(at: indexPath.row) as AnyObject).object(forKey: "createdAt") as AnyObject)

        cell.selectionStyle = .none
        cell3=cell
        
        
        return cell3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let MessagesArray : NSArray = (ResponseDict.object(at: section) as AnyObject).object(forKey: "messages")  as! NSArray
        return MessagesArray.count;
    }
    
    
    func tableView( _ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let mainview = UIView.init(frame: CGRect(x: self.notification_table.frame.origin.x,y: 0,width: self.notification_table.frame.size.width, height: 70))
        mainview.backgroundColor = UIColor.white
        let header = UIView(frame: CGRect(x: 20, y: 10, width: self.notification_table.frame.size.width-40, height: 40))
        header.backgroundColor = UIColor.white
        header.layer.borderColor = UIColor.gray.cgColor
        header.layer.borderWidth = 1.0;
        header.layer.cornerRadius = 10
//        let btnimg :UIImageView = UIImageView(frame:CGRectMake(self.notification_table.frame.size.width-80,10,20,20))
        
        let lable : UILabel = UILabel(frame: CGRect(x: 0, y: 5, width: header.frame.size.width, height: 30))
        //btnimg.image = UIImage(named:"black_back")
        lable.text  = "\(String(describing: theme.CheckNullValue(self.CategoryArray[section] as AnyObject))) - \(theme.CheckNullValue(self.bookingidArray[section] as AnyObject))"
       
        lable.font = UIFont(name: "Helvetica Neue", size:14)
        
        lable.textAlignment = .center
        header.addSubview(lable)
        //header.addSubview(btnimg)
        mainview.addSubview(header)
        return mainview
        
    }
    
    deinit {
        self.notification_table.delegate = nil
    }

    
    
    //     func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        return self.headers[section]
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
