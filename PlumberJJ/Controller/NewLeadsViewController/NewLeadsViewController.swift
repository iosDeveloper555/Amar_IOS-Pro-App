//
//  NewLeadsViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/19/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class NewLeadsViewController: RootBaseViewController,UITableViewDataSource,UITableViewDelegate,MyOrderOpenDetailViewControllerDelegate,PopupSortingViewControllerDelegate,UIViewControllerTransitioningDelegate {
    @IBOutlet var tableViewFooter: MyFooter!
    @IBOutlet weak var newLeadsTblView: UITableView!
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var barButton: UIButton!
   
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    
    var NewLeadsArr:NSMutableArray=NSMutableArray()
    var Param: NSDictionary = NSDictionary()
   // var theme:Theme=Theme()
     var nextPageStr:NSInteger!
    var noDataView:UIView!
    fileprivate var loading = false {
        didSet {
            tableViewFooter.isHidden = !loading
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if self.theme.yesTheDeviceisHavingNotch(){
            HeaderViewHeight.constant = 100
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewLeadsViewController.methodOfReceivedSortingNotificationNetworkDetail(_:)), name:NSNotification.Name(rawValue: "SortingNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewLeadsViewController.methodOfReceivedNotificationNetworkDetail(_:)), name:NSNotification.Name(rawValue: kNewLeadsOpenNotifNotif), object: nil)
        // Do any additional setup after loading the view.
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
        
        
        let Param  = ["provider_id":"\(objUserRecs.providerId)",
                  "page":"\(nextPageStr)" as String,
                  "type":"\(types)","perPage":kPageCount,"orderby":"\(isAsc)","sortby":""]
        
        url_handler.makeCall(sortesList, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            self.newLeadsTblView.isHidden=false
            self.DismissProgress()
            self.newLeadsTblView.dg_stopLoading()
            self.loading = false
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)! > 0)
                {
                    let responseObject = responseObject!
                    
                    let status = self.theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject)
                    
                    if(status == "1")
                    {
                        if(self.nextPageStr==1){
                            self.NewLeadsArr.removeAllObjects()
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

                                let rec = MyOrderOpenRecord(order_id: self.theme.CheckNullValue((element as AnyObject).object(forKey: "job_id") as AnyObject), post_on: self.theme.CheckNullValue((element as AnyObject).object(forKey: "booking_time") as AnyObject), user_Img: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_image") as AnyObject), user_name: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_name") as AnyObject), user_catg: self.theme.CheckNullValue((element as AnyObject).object(forKey: "category_name") as AnyObject as AnyObject), user_Loc:  userlocation,order_sta: self.theme.CheckNullValue((element as AnyObject).object(forKey: "job_status") as AnyObject))
                                self.NewLeadsArr.add(rec)
                            }
                            
                            self.nextPageStr=self.nextPageStr+1
                        }else{
                            if(self.nextPageStr>1){
                                self.view.makeToast(message:self.theme.setLang("no_leads"), duration: 3, position: HRToastPositionDefault as AnyObject, title:appNameJJ)
                            }
                        }
                        self.newLeadsTblView.reloadData()
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

    override func viewWillAppear(_ animated: Bool) {
        if (self.navigationController!.viewControllers.count != 1) {
            backBtn.isHidden=false;
            barButton.isHidden=true
        }else{
        }
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(MyLeadsViewController.MoveToDetail(_:)), name: NSNotification.Name(rawValue: kNewLeadsNotif), object: nil)
        barButton.addTarget(self, action: #selector(MyLeadsViewController.openmenu), for: .touchUpInside)

        newLeadsTblView.register(UINib(nibName: "newleadsxibTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        newLeadsTblView.estimatedRowHeight = 229
        newLeadsTblView.rowHeight = UITableView.automaticDimension
        
        titleHeader.text = Language_handler.VJLocalizedString("new_leads", comment: nil)
        btnFilter.setTitle(Language_handler.VJLocalizedString("filter", comment: nil), for: UIControl.State())
        
        newLeadsTblView.isHidden=true
        
        
        nextPageStr=1
        refreshNewLeads()
        showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        
        Param  = ["provider_id":"\(objUserRecs.providerId)",
            "page":"\(nextPageStr)" as String,
            "perPage":kPageCount]
        
        
        GetNewLeads()
        //loadNewFeed()
    }
    
   @objc func openmenu(){
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        // Present the view controller
        //
        self.frostedViewController.presentMenuViewController()
    }
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    @objc func MoveToDetail(_ notification:Notification){
        let rec:MyOrderOpenRecord = notification.object as! MyOrderOpenRecord
        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
        objMyOrderVc.delegate = self
        objMyOrderVc.jobID=rec.orderId
        objMyOrderVc.Getorderstatus = rec.orderstatus
        self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
    }
    deinit {
        newLeadsTblView.dg_removePullToRefresh()
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func didclickFilterOption(_ sender: AnyObject) {
        self.displayViewController(.bottomBottom)
        
    }
    func displayViewController(_ animationType: SLpopupViewAnimationType) {
        
        let Popupsortcontroller : PopupSortingViewController = PopupSortingViewController(nibName:"PopupSortingViewController",bundle: nil)
        
        Popupsortcontroller.delegate = self;
        
        Popupsortcontroller.transitioningDelegate = self
        
        Popupsortcontroller.modalPresentationStyle = .custom
        self.navigationController?.present(Popupsortcontroller, animated: true, completion: nil)

//        self.presentpopupViewController(Popupsortcontroller, animationType: animationType, completion: { () -> Void in
//
//        })
    }
    
    //    #pragma mark - UIViewControllerTransitionDelegate -
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return PresentingAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return DismissingAnimationController()
    }
    func  pressedCancel(_ sender: PopupSortingViewController) {
        
        self.dismiss(animated: true, completion: nil)

        
      //  self.dismissPopupViewController(.bottomBottom)
        
    }
    
    func passRequiredParametres(_ fromdate: NSString, todate: NSString, isAscendorDescend: Int,isToday:Int,isSortby:NSString) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SortingNotification"), object:nil,userInfo: ["Fromdate":"\(fromdate)","Todate":"\(todate)","asDes":"\(isAscendorDescend)","isToday":"\(isToday)","StatusforSort":"\(isSortby)"] )
        
        
        
    }
    
    func passRequiredParametres(_ fromdate: NSString, todate: NSString, isAscendorDescend: Int, isSortby: NSString) {
        
    }
    

    @objc func methodOfReceivedNotificationNetworkDetail(_ notification: Notification){
       loadNewFeed()
    }
    @objc func methodOfReceivedSortingNotificationNetworkDetail(_ notification: Notification){
       // loadNewFeed()
        let userInfo:Dictionary<String,String?> = notification.userInfo as! Dictionary<String,String?>

        if(userInfo["isToday"]! == "4"){

        showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
           nextPageStr = 1;     
        Param  = ["provider_id":"\(objUserRecs.providerId)",
                  "page":"\(nextPageStr)" as String,
                  "perPage":kPageCount,"from":userInfo["Fromdate"]!,"to":userInfo["Todate"]!,"orderby":userInfo["asDes"]!,"sortby":userInfo["StatusforSort"]!]
        
        GetNewLeads()
        }
            else{
            nextPageStr = 1;

            self.filterOrder("\(String(describing: userInfo["isToday"]!))", isAsc: "\(String(describing: userInfo["asDes"]!))")
            }

        
    }
    func loadNewFeed(){
        nextPageStr=1
        showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        
              Param  = ["provider_id":"\(objUserRecs.providerId)",
                  "page":"\(nextPageStr)" as String,
                  "perPage":kPageCount]

        GetNewLeads()
    }
    
    
    
   
    func GetNewLeads(){
        
             // print(Param)
       
        url_handler.makeCall(getNewLeads, param: Param as NSDictionary) {
            (responseObject, error) -> () in
             self.newLeadsTblView.isHidden=false
            self.DismissProgress()
            self.newLeadsTblView.dg_stopLoading()
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
                            self.NewLeadsArr.removeAllObjects()
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
                                let rec = MyOrderOpenRecord(order_id: self.theme.CheckNullValue((element as AnyObject).object(forKey: "job_id") as AnyObject), post_on: self.theme.CheckNullValue((element as AnyObject).object(forKey: "booking_time") as AnyObject), user_Img: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_image") as AnyObject), user_name: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_name") as AnyObject as AnyObject), user_catg: self.theme.CheckNullValue((element as AnyObject).object(forKey: "category_name") as AnyObject), user_Loc: userlocation,order_sta: self.theme.CheckNullValue((element as AnyObject).object(forKey: "job_status") as AnyObject))
                                self.NewLeadsArr.add(rec)
                            }
                            
                            self.nextPageStr=self.nextPageStr+1
                        }else{
                            if(self.nextPageStr>1){
                                self.view.makeToast(message:self.theme.setLang("no_leads"), duration: 3, position: HRToastPositionDefault as AnyObject, title:appNameJJ)
                            }
                        }
                        self.newLeadsTblView.reloadData()
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
        
        if(NewLeadsArr.count>0){
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
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewLeadsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! newleadsxibTableViewCell
        let objRec:MyOrderOpenRecord=self.NewLeadsArr.object(at: indexPath.row) as! MyOrderOpenRecord
        //cell.orderIdLbl.text = theme.setLang("order_id")
        
        cell.loadMyOrderNewLeadTableCell(objRec)
        cell.selectionStyle=UITableViewCell.SelectionStyle.none
        cell.contentView.layoutIfNeeded();
        cell.layoutIfNeeded()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MyOrderDetailOpenVCSID
        if(!loading){
            if(indexPath.row < NewLeadsArr.count){
                //openDetailNavSID
                let objRec=NewLeadsArr.object(at: indexPath.row)
                NotificationCenter.default.post(name: Notification.Name(rawValue: kNewLeadsNotif), object: objRec)
               
            }
        }
    }
    ///////////////////// Infinite Scroll
//     func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//        if (Int(scrollView.contentOffset.y + scrollView.frame.size.height) == Int(scrollView.contentSize.height + scrollView.contentInset.bottom)) {
//            if (maximumOffset - currentOffset) <= 52 {
//                refreshNewLeadsandLoad()
//            }
//        }
//
//    }
     let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    func refreshNewLeads(){
       
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        newLeadsTblView.dg_addPullToRefreshWithActionHandler({
            self.nextPageStr=1
            let objUserRecs:UserInfoRecord = self.theme.GetUserDetails()
            
            self.Param  = ["provider_id":"\(objUserRecs.providerId)",
                "page":"\(self.nextPageStr)" as String,
                "perPage":kPageCount]

            self.GetNewLeads()
            
            }, loadingView: loadingView)
        newLeadsTblView.dg_setPullToRefreshFillColor(PlumberLightGrayColor)
        newLeadsTblView.dg_setPullToRefreshBackgroundColor(newLeadsTblView.backgroundColor!)
    }
    func refreshNewLeadsandLoad(){
        if (!loading) {
            loading = true
            let objUserRecs:UserInfoRecord = self.theme.GetUserDetails()
            
            self.Param  = ["provider_id":"\(objUserRecs.providerId)",
                           "page":"\(self.nextPageStr)" as String,
                           "perPage":kPageCount]
            GetNewLeads()
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
