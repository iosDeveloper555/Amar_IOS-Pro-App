//
//  ReviewViewController.swift
//  PlumberJJ
//
//  Created by Casperon on 08/02/17.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit


class ReviewViewController: RootBaseViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var reviewsTblView: UITableView!
    var nextPageStr:NSInteger!
    @IBOutlet weak var lblreviews: UILabel!

    var reviewsArray:NSMutableArray = [];
    fileprivate var loading = false {
        didSet {
            
        }
    }
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTblView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewsTblIdentifier")
        reviewsTblView.estimatedRowHeight = 120
        reviewsTblView.rowHeight = UITableView.automaticDimension
        lblreviews.text = theme.setLang("reviews")

        reviewsTblView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        reviewsTblView.isHidden=true
        nextPageStr=1
        
        
        self.reviewsArray.removeAllObjects()
        
        showProgress()
        refreshNewLeads()
        GetReviews()
    }
    
    
    func refreshNewLeads(){
        
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        reviewsTblView.dg_addPullToRefreshWithActionHandler({
            self.nextPageStr=1
            self.GetReviews()
            
            }, loadingView: loadingView)
        reviewsTblView.dg_setPullToRefreshFillColor(PlumberLightGrayColor)
        reviewsTblView.dg_setPullToRefreshBackgroundColor(reviewsTblView.backgroundColor!)
    }
    func refreshNewLeadsandLoad(){
        if (!loading) {
            loading = true
            GetReviews()
        }
    }
    
    func GetReviews(){
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["user_id":"\(objUserRecs.providerId)",
                                 "role":"tasker",
                                 "page":"\(nextPageStr)" as String,
                                 "perPage":kPageCount]
        // print(Param)
        
        url_handler.makeCall(Get_ReviewsURl , param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            
            self.reviewsTblView.isHidden=false
            self.reviewsTblView.dg_stopLoading()
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
                    let Dict:NSDictionary=responseObject.object(forKey: "data") as! NSDictionary
                    let status=self.theme.CheckNullValue(Dict.object(forKey: "status") as? NSString)
                    
                    if(status == "1")
                    {
                        if(((Dict.object(forKey: "response") as AnyObject).object(forKey: "reviews") as AnyObject).count>0){
                            let  listArr:NSArray=(Dict.object(forKey: "response") as AnyObject).object(forKey: "reviews") as! NSArray
                            if(self.nextPageStr==1){
                                self.reviewsArray.removeAllObjects()
                            }
                            for (_, element) in listArr.enumerated() {
                                let rec = ReviewRecords(name: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_name")), time: self.theme.CheckNullValue((element as AnyObject).object(forKey: "date")), desc: self.theme.CheckNullValue((element as AnyObject).object(forKey: "comments")), rate: self.theme.CheckNullValue((element as AnyObject).object(forKey: "rating")), img: self.theme.CheckNullValue((element as AnyObject).object(forKey: "user_image")),ratting:self.theme.CheckNullValue((element as AnyObject).object(forKey: "image")),jobid :self.theme.CheckNullValue((element as AnyObject).object(forKey: "booking_id")))
                                
                                [self.reviewsArray .add(rec)]
                            }
                            self.reviewsTblView.reload()
                            self.nextPageStr=self.nextPageStr+1
                        }
                    }
                    else
                    {
                        let response : String = self.theme.CheckNullValue(Dict.object(forKey: "response"))
//                self.view.makeToast(message:"\(response)", duration: 5, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
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
    
//    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
//    {
//        
//        return 115
//        
//        
//    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if reviewsArray.count == 0 {
            loadNoData()
            return 1
        }
        reviewsTblView.backgroundView = nil
        reviewsTblView.separatorStyle = .singleLine
        return 1
    }
    func loadNoData() {
        let nibView = Bundle.main.loadNibNamed("EmptyDataView", owner: self, options: nil)![0] as! EmptyDataView
        nibView.frame = self.reviewsTblView.bounds;
  nibView.msgLbl.text = self.theme.setLang("no_reviews")
         nibView.msgLbl.font = PlumberLargeFont
        self.reviewsTblView.backgroundView=nibView
        reviewsTblView.backgroundView = nibView
        reviewsTblView.separatorStyle = .none
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviewsArray.count>0
        {
        return reviewsArray.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->     UITableViewCell {
        
        let cell3:UITableViewCell
        
        let cell:ReviewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTblIdentifier") as! ReviewsTableViewCell
        
        if (reviewsArray.count > 0)
        {
            
            cell.loadReviewTableCell((reviewsArray .object(at: indexPath.row) as! ReviewRecords))
            
            
        }
        cell.selectionStyle=UITableViewCell.SelectionStyle.none
        cell3=cell
        
        
        return cell3
    }
    
    @IBAction func menuBtnAct(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }
    
}
