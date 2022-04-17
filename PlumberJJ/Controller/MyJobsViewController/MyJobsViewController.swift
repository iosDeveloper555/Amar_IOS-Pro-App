//
//  MyJobsViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/20/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class MyJobsViewController: RootBaseViewController,PopupSortingViewControllerDelegate,MyOrderOpenDetailViewControllerDelegate,UIViewControllerTransitioningDelegate {
     @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var swiftPagesView: SwiftPages!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var topView: SetColorView!
    @IBOutlet weak var titleHeader: UILabel!
    
    @IBOutlet weak var HeaderViewheight: NSLayoutConstraint!
    @IBOutlet weak var lblFilter: UIButton!
    let Themes = Theme()
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewControllerwithFade(animated: false)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        if self.Themes.yesTheDeviceisHavingNotch(){
            HeaderViewheight.constant = 100
        }
        self.backBtn.tintColor = PlumberThemeColor
        titleHeader.text = Language_handler.VJLocalizedString("my_jobs", comment: nil)
        lblFilter.setTitle(Language_handler.VJLocalizedString("filter", comment: nil), for: UIControl.State())
        
        if (self.navigationController!.viewControllers.count != 1) {
            backBtn.isHidden=false;
            menuButton.isHidden=true
        }else{
        }
        
        
        //Initiation
        let VCIDs : [String] = ["JobsClosedVCSID","MyOrdersVCSID","JobsCancelledVCSID"]
        let titles : [String] = [Language_handler.VJLocalizedString("completed", comment: nil),Language_handler.VJLocalizedString("open", comment: nil),  Language_handler.VJLocalizedString("cancelled", comment: nil)]
        
        //Sample customization
        swiftPagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: titles)
        swiftPagesView.setTopBarBackground(.white)
        self.Themes.addGradient(self.swiftPagesView, colo1: .white, colo2: PlumberBottomGradient, direction: .ToptoBottom, Frame: CGRect(x: 0, y: 0, width: UIDevice.current.screenWidth, height: UIDevice.current.screenHeight), CornerRadius: false, Radius: 0)
        swiftPagesView.setAnimatedBarColor(PlumberThemeColor)
          menuButton.addTarget(self, action: #selector(MyJobsViewController.openmenu), for: .touchUpInside)
                }
    
    override func viewWillAppear(_ animated: Bool) {
      
      didselect = ""
      
       
         NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(MyJobsViewController.MoveToDetail(_:)), name: NSNotification.Name(rawValue: kMyLeadsNotif), object: nil)
       
        
        // Do any additional setup after loading the view.
      
    }

    @objc func openmenu(){
//        self.view.endEditing(true)
//        self.frostedViewController.view.endEditing(true)
//        // Present the view controller
//        //
//        self.frostedViewController.presentMenuViewController()
        self.findHamburguerViewController()?.showMenuViewController()
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
      
        
      

    }
    func passRequiredParametres(_ fromdate: NSString, todate: NSString, isAscendorDescend: Int,isToday: Int,isSortby:NSString) {
        
        if fromdate == "" && todate == "" && isToday == 0
        {
            
        }
        else
        {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SortingJobNotification"), object:nil,userInfo: ["Fromdate":"\(fromdate)","Todate":"\(todate)","asDes":"\(isAscendorDescend)","isToday":"\(isToday)","StatusforSort":"\(isSortby)"] )
        }
        
        
        
    }
    

    func passRequiredParametres(_ fromdate: NSString, todate: NSString, isAscendorDescend: Int, isSortby: NSString) {
          swiftPagesView.loadVisiblePages()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @objc  func MoveToDetail(_ notification:Notification){
        let rec:MyOrderOpenRecord = notification.object as! MyOrderOpenRecord
        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
        objMyOrderVc.delegate = self
        objMyOrderVc.jobID=rec.orderId
        objMyOrderVc.Getorderstatus = ""
        self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
    }
    deinit
    {
        NotificationCenter.default.removeObserver(self)
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
