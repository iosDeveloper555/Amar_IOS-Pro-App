//
//  MyLeadsViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/23/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class MyLeadsViewController: RootBaseViewController,PopupSortingViewControllerDelegate,MyOrderOpenDetailViewControllerDelegate,UIViewControllerTransitioningDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var topView: SetColorView!
    
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }

     override func applicationLanguageChangeNotification(_ notification: Notification) {
        titleHeader.text = Language_handler.VJLocalizedString("new_leads", comment: nil)
        btnFilter.setTitle(Language_handler.VJLocalizedString("filter", comment: nil), for: UIControl.State())
    }

    override func viewWillAppear(_ animated: Bool)
    {
      didselect = ""
        if (self.navigationController!.viewControllers.count != 1) {
            backBtn.isHidden=false;
            barButton.isHidden=true
        }else{
        }
     /*     let swiftPagesView : SwiftPages!
        swiftPagesView = SwiftPages(frame: CGRectMake(0, 0, containerView.frame.width, containerView.frame.height))
        
        //Initiation
        let VCIDs : [String] = ["NewLeadsVCSID"]
        let titles : [String] = [Language_handler.VJLocalizedString("new_leads", comment: nil)]
        
        //Sample customization
        swiftPagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: titles)
        swiftPagesView.setTopBarBackground(PlumberLightGrayColor)
        swiftPagesView.setAnimatedBarColor(PlumberThemeColor)
        containerView.addSubview(swiftPagesView) */

        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(MyLeadsViewController.MoveToDetail(_:)), name: NSNotification.Name(rawValue: kNewLeadsNotif), object: nil)
        barButton.addTarget(self, action: #selector(MyLeadsViewController.openmenu), for: .touchUpInside)

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

 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
