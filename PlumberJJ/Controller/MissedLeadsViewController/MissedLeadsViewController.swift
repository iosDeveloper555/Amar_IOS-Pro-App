//
//  MissedLeadsViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/23/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit


class MissedLeadsViewController: RootBaseViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var tableViewFooter: MyFooter!
    @IBOutlet weak var MissedLeadsTblView: UITableView!
    var MissedLeadsArr:NSMutableArray=NSMutableArray()
  //  var theme:Theme=Theme()
    var    Param: NSDictionary = NSDictionary ()
    var nextPageStr:NSInteger!
    var noDataView:UIView!
    fileprivate var loading = false {
        didSet {
            tableViewFooter.isHidden = !loading
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
        nextPageStr=1
        refreshNewLeads()
        showProgress()
           let objUserRecs:UserInfoRecord=theme.GetUserDetails()
     Param = ["provider_id":"\(objUserRecs.providerId)",
                                 "page":"\(nextPageStr)" as String,
                                 "perPage":kPageCount]
       // GetNewLeads()
          NotificationCenter.default.addObserver(self, selector: #selector(MissedLeadsViewController.methodOfReceivedSortingNotificationNetworkDetail(_:)), name:NSNotification.Name(rawValue: "SortingNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(MissedLeadsViewController.methodOfReceivedNotificationNetworkDetail(_:)), name:NSNotification.Name(rawValue: kNewLeadsOpenNotifNotif), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        MissedLeadsTblView.delegate = self;
        MissedLeadsTblView.dataSource = self;
        
     //   GetNewLeads()
    }
    
    @objc func methodOfReceivedSortingNotificationNetworkDetail(_ notification: Notification){
        // loadNewFeed()
        
        let userInfo:Dictionary<String,String?> = notification.userInfo as! Dictionary<String,String?>
        showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        
        
        nextPageStr = 1;

        Param  = ["provider_id":"\(objUserRecs.providerId)",
                  "page":"\(nextPageStr)" as String,
                  "perPage":kPageCount,"from":userInfo["Fromdate"]!,"to":userInfo["Todate"]!,"orderby":userInfo["asDes"]!,"sortby":userInfo["StatusforSort"]!]
     
        
       // GetNewLeads()
        
        
        
    }

    @objc func methodOfReceivedNotificationNetworkDetail(_ notification: Notification){
        loadNewFeed()
    }
    func loadNewFeed(){
        nextPageStr=1
        showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        Param = ["provider_id":"\(objUserRecs.providerId)",
                 "page":"\(nextPageStr)" as String,
                 "perPage":kPageCount]

       // GetNewLeads()
    }

    func GetNewLeads(){
        
     
      
        // print(Param)
        
        url_handler.makeCall(getMissLeads, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            self.DismissProgress()
            self.MissedLeadsTblView.dg_stopLoading()
            self.loading = false
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status = self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject)
                    
                    if(status == "1")
                    {
                        if(self.nextPageStr==1){
                            self.MissedLeadsArr.removeAllObjects()
                        }
                        if(((responseObject.object(forKey: "response") as AnyObject).object(forKey: "jobs")! as AnyObject).count>0){
                            let  listArr:NSArray=(responseObject.object(forKey: "response") as AnyObject).object(forKey: "jobs") as! NSArray
                            
                            for (_, element) in listArr.enumerated() {
                                let rec = MyOrderOpenRecord(order_id: self.theme.CheckNullValue((element as AnyObject).object(forKey: "job_id") as AnyObject), post_on: self.theme.CheckNullValue((element as AnyObject).object(forKey: "booking_time") as AnyObject), user_Img: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_image") as AnyObject), user_name: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_name") as AnyObject), user_catg: self.theme.CheckNullValue((element as AnyObject).object(forKey: "category_name") as AnyObject), user_Loc: self.theme.CheckNullValue((element as AnyObject).object(forKey: "location") as AnyObject),order_sta: self.theme.CheckNullValue((element as AnyObject).object(forKey: "job_status") as AnyObject))
                                self.MissedLeadsArr.add(rec)
                            }
                            
                            self.nextPageStr=self.nextPageStr+1
                        }
                        
                        
                            if(self.nextPageStr>1){
                                
                                self.view.makeToast(message:self.theme.setLang("no_leads"), duration: 3, position: HRToastPositionDefault as AnyObject, title:appNameJJ)
                            }
                        
                        self.MissedLeadsTblView.reloadData()
                    }
                    else
                    {
                        
                        
//                        self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if(MissedLeadsArr.count>0){
            noDataView.isHidden=true
            return 1
        }else{
            
            if(noDataView==nil){
                let subviewArray = Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)
                noDataView = subviewArray?[0] as! NoDataView
                
                noDataView.frame=self.view.frame
            }
            
            noDataView.isHidden=false
            tableView.backgroundView = noDataView
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MissedLeadsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewLeadsIdentifier", for: indexPath) as! NewLeadsTableViewCell
        let objRec:MyOrderOpenRecord=self.MissedLeadsArr.object(at: indexPath.row) as! MyOrderOpenRecord
        cell.loadMyOrderNewLeadTableCell(objRec)
        cell.selectionStyle=UITableViewCell.SelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MyOrderDetailOpenVCSID
        if(!loading){
            if(indexPath.row < MissedLeadsArr.count){
            
                let objRec=MissedLeadsArr.object(at: indexPath.row)
                NotificationCenter.default.post(name: Notification.Name(rawValue: kNewLeadsNotif), object: objRec)
            }
        }
    }
    
    
    
    
    ///////////////////// Infinite Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (Int(scrollView.contentOffset.y + scrollView.frame.size.height) == Int(scrollView.contentSize.height + scrollView.contentInset.bottom)) {
            if (maximumOffset - currentOffset) <= 52 {
                refreshNewLeadsandLoad()
            }
        }
        
    }
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    func refreshNewLeads(){
        
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        MissedLeadsTblView.dg_addPullToRefreshWithActionHandler({
            self.nextPageStr=1
            let objUserRecs:UserInfoRecord=self.theme.GetUserDetails()
            self.Param = ["provider_id":"\(objUserRecs.providerId)",
                "page":"\(self.nextPageStr)" as String,
                "perPage":kPageCount]

            //self.GetNewLeads()
            
            }, loadingView: loadingView)
        MissedLeadsTblView.dg_setPullToRefreshFillColor(PlumberLightGrayColor)
        MissedLeadsTblView.dg_setPullToRefreshBackgroundColor(MissedLeadsTblView.backgroundColor!)
    }
    func refreshNewLeadsandLoad(){
        if (!loading) {
            loading = true
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            Param = ["provider_id":"\(objUserRecs.providerId)",
                     "page":"\(nextPageStr)" as String,
                     "perPage":kPageCount]

          //  GetNewLeads()
        }
    }
    deinit {
        MissedLeadsTblView.dg_removePullToRefresh()
        NotificationCenter.default.removeObserver(self)

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
