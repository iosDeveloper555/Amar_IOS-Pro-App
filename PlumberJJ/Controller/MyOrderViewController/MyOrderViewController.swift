//
//  MyOrderViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 10/27/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class MyOrderViewController: RootBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableViewFooter: MyFooter!
    @IBOutlet weak var OnGoingLeadsTbl: UITableView!
    
    @IBOutlet var loading_lbl: UILabel!
    var OnGoingArr:NSMutableArray=NSMutableArray()
     var Param: NSDictionary = NSDictionary()
    //  var theme:Theme=Theme()
    var nextPageStr:NSInteger = 0
    var noDataView:NoDataView!
    fileprivate var loading = false {
        didSet {
            tableViewFooter.isHidden = !loading
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loading_lbl.text=theme.setLang("loading")
        OnGoingLeadsTbl.register(UINib(nibName: "newleadsxibTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        OnGoingLeadsTbl.estimatedRowHeight = 200
        OnGoingLeadsTbl.rowHeight = UITableView.automaticDimension
        OnGoingLeadsTbl.backgroundColor = .clear
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "SortingJobNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyOrderViewController.methodOfReceivedSortingNotificationNetworkDetail(_:)), name:NSNotification.Name(rawValue: "SortingJobNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyOrderViewController.methodOfReceivedReloadNotification(_:)), name:NSNotification.Name(rawValue: "reloadCurrentJob"), object: nil)
        OnGoingLeadsTbl.isHidden=true
        
        nextPageStr=1
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        Param = ["provider_id":"\(objUserRecs.providerId)",
            "type":"2",
            "page":"\(nextPageStr)" as String,
            "perPage":kPageCount]
        
        refreshNewLeads()
        showProgress()
        GetNewLeads()
    }
    
    override func  viewWillAppear(_ animated: Bool) {
      

    }
    
    override func  viewDidAppear(_ animated: Bool) {
    }
    
    @objc func methodOfReceivedReloadNotification(_ notification: Notification){
        OnGoingLeadsTbl.isHidden=true
        OnGoingArr=NSMutableArray()
        nextPageStr=1

        showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        Param = ["provider_id":"\(objUserRecs.providerId)",
                 "type":"2",
                 "page":"\(nextPageStr)" as String,
                 "perPage":kPageCount]
        GetNewLeads()
    }
    
    
    
    @objc func methodOfReceivedSortingNotificationNetworkDetail(_ notification: Notification){
        // loadNewFeed()
        
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        
        if(userInfo["isToday"]! == "3"){
        showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        Param  = ["provider_id":"\(objUserRecs.providerId)",
                  "page":"\(nextPageStr)",
                  "type":"2","perPage":kPageCount,"from":userInfo["Fromdate"]!,"to":userInfo["Todate"]!,"orderby":userInfo["asDes"]!,"sortby":userInfo["StatusforSort"]!]
        
        GetNewLeads()
        }else{
            nextPageStr = 1;

         filterOrder("\(userInfo["isToday"]!)", isAsc: "\(userInfo["asDes"]!)")
        }
        
        
    }
    func GetNewLeads(){


               // print(Param)
        
        url_handler.makeCall(myJobsUrl , param: Param as NSDictionary) {
            (responseObject, error) -> () in
            self.OnGoingLeadsTbl.isHidden=false
            self.DismissProgress()
            self.OnGoingLeadsTbl.dg_stopLoading()
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
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                    if(status == "1")
                    {
                        if(self.nextPageStr==1){
                            self.OnGoingArr.removeAllObjects()
                        }
                        if(((responseObject.object(forKey: "response") as AnyObject).object(forKey: "jobs")! as AnyObject).count>0){
                            let  listArr:NSArray=(responseObject.object(forKey: "response") as AnyObject).object(forKey: "jobs") as! NSArray
                            
                            for (_, element) in listArr.enumerated() {
                                
                                let provider_lat = self.theme.CheckNullValue((element as AnyObject).object(forKey: "location_lat") as AnyObject)
                                let provider_lng = self.theme.CheckNullValue((element as AnyObject).object(forKey: "location_lng") as AnyObject)
                                var userlocation = String()
                                let exactaddress = self.theme.CheckNullValue((element as AnyObject).object(forKey: "service_address") as AnyObject)
                                if exactaddress != ""
                                {
                                    userlocation = exactaddress
                                    
                                }
                                else
                                {
                                    userlocation = self.theme.getAddressForLatLng(provider_lat, longitude: provider_lng, status: "short")
                                    
                                }


                                let rec = MyOrderOpenRecord(order_id: self.theme.CheckNullValue((element as AnyObject).object(forKey: "job_id") as AnyObject), post_on: self.theme.CheckNullValue((element as AnyObject).object(forKey: "booking_time") as AnyObject), user_Img: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_image") as AnyObject), user_name: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_name") as AnyObject), user_catg: self.theme.CheckNullValue((element as AnyObject).object(forKey: "category_name") as AnyObject), user_Loc: userlocation,order_sta: self.theme.CheckNullValue((element as AnyObject).object(forKey: "job_status") as AnyObject))
                                self.OnGoingArr.add(rec)
                            }
                            
                            self.nextPageStr=self.nextPageStr+1
                        }else{
                            if(self.nextPageStr>1){
                                self.view.makeToast(message:self.theme.setLang("no_leads"), duration: 3, position: HRToastPositionDefault as AnyObject, title:appNameJJ)
                            }
                        }
                        self.OnGoingLeadsTbl.reloadData()
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
    
    func filterOrder(_ type:String,isAsc:String){
        
        
        var types = String()
        
        if(type == "0"){
            types = "today"
        }else if(type == "1"){
            types = "recent"
        }else if(type == "2"){
            types = "upcoming"
        }
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()

        
        Param  = ["provider_id":"\(objUserRecs.providerId)",
                  "page":"\(nextPageStr)" as String,
                  "type":"\(types)","perPage":kPageCount,"orderby":"\(isAsc)","sortby":""]

        url_handler.makeCall(sortesList , param: Param as NSDictionary) {
            (responseObject, error) -> () in
            self.OnGoingLeadsTbl.isHidden=false
            self.DismissProgress()
            self.OnGoingLeadsTbl.dg_stopLoading()
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
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                    if(status == "1")
                    {
                        if(self.nextPageStr==1){
                            self.OnGoingArr.removeAllObjects()
                        }
                        if(((responseObject.object(forKey: "response") as AnyObject).object(forKey: "jobs")! as AnyObject).count>0){
                            let  listArr:NSArray=(responseObject.object(forKey: "response") as AnyObject).object(forKey: "jobs") as! NSArray
                            
                            for (_, element) in listArr.enumerated() {
                                let provider_lat = self.theme.CheckNullValue((element as AnyObject).object(forKey: "location_lat") as AnyObject as AnyObject)
                                let provider_lng = self.theme.CheckNullValue((element as AnyObject).object(forKey: "location_lng") as AnyObject)
                                let rec = MyOrderOpenRecord(order_id: self.theme.CheckNullValue((element as AnyObject).object(forKey: "job_id") as AnyObject), post_on: self.theme.CheckNullValue((element as AnyObject).object(forKey: "booking_time") as AnyObject), user_Img: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_image") as AnyObject), user_name: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_name") as AnyObject), user_catg: self.theme.CheckNullValue((element as AnyObject).object(forKey: "category_name") as AnyObject), user_Loc: self.theme.CheckNullValue(self.theme.getAddressForLatLng(provider_lat, longitude: provider_lng, status: "short") as AnyObject),order_sta: self.theme.CheckNullValue((element as AnyObject).object(forKey: "job_status") as AnyObject))
                                self.OnGoingArr.add(rec)
                            }
                            
                            self.nextPageStr=self.nextPageStr+1
                        }else{
                            if(self.nextPageStr>1){
                                self.view.makeToast(message:self.theme.setLang("no_leads"), duration: 3, position: HRToastPositionDefault as AnyObject, title:appNameJJ)
                            }
                        }
                        self.OnGoingLeadsTbl.reloadData()
                    }
                    else
                    {
                        let status1=self.theme.CheckNullValue(responseObject.object(forKey: "response") as AnyObject) as NSString

                        self.view.makeToast(message:appNameJJ, duration: 5, position: HRToastPositionDefault as AnyObject, title: "\(status1)")
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
        
        if(OnGoingArr.count>0){
            noDataView.isHidden=true
            return 1
        }else{
            
            if(noDataView==nil){
                let subviewArray = Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)
                noDataView = subviewArray?[0] as! NoDataView
                noDataView.msgLbl.text = "You do not have any open leads"
                
                
            
                
                noDataView.frame=self.view.frame
                
            }
            
            noDataView.isHidden=false
            tableView.backgroundView = noDataView
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnGoingArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! newleadsxibTableViewCell
        let objRec:MyOrderOpenRecord=self.OnGoingArr.object(at: indexPath.row) as! MyOrderOpenRecord
        cell.loadMyOrderNewLeadTableCell(objRec)
        cell.selectionStyle=UITableViewCell.SelectionStyle.none
        cell.contentView.layoutIfNeeded();
        cell.layoutIfNeeded()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MyOrderDetailOpenVCSID
        if(!loading){
            if(indexPath.row < OnGoingArr.count){
                if didselect == ""
                {
                let objRec=OnGoingArr.object(at: indexPath.row)
                NotificationCenter.default.post(name: Notification.Name(rawValue: kMyLeadsNotif), object: objRec)
                      didselect = "1"
                }
                
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
        OnGoingLeadsTbl.dg_addPullToRefreshWithActionHandler({
            self.nextPageStr=1
            let objUserRecs:UserInfoRecord = self.theme.GetUserDetails()
            self.Param = ["provider_id":"\(objUserRecs.providerId)",
                "type":"2",
                "page":"\(self.nextPageStr)" as String,
                "perPage":kPageCount]
            

            self.GetNewLeads()
            
            }, loadingView: loadingView)
        OnGoingLeadsTbl.dg_setPullToRefreshFillColor(PlumberLightGrayColor)
        OnGoingLeadsTbl.dg_setPullToRefreshBackgroundColor(OnGoingLeadsTbl.backgroundColor!)
    }
    func refreshNewLeadsandLoad(){
        if (!loading) {
            loading = true
            
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            Param = ["provider_id":"\(objUserRecs.providerId)",
                     "type":"2",
                     "page":"\(nextPageStr)" as String,
                     "perPage":kPageCount]
            

            GetNewLeads()
        }
    }
    deinit {
        OnGoingLeadsTbl.dg_removePullToRefresh()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
