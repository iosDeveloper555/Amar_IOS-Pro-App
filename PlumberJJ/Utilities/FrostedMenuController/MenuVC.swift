//
//  MenuVC.swift
//  PlumberJJ
//
//  Created by Mac1 on 01/09/21.
//  Copyright © 2021 Casperon Technologies. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import DropDown
import MessageUI

class MenuVC: RootBaseViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var animation_top_view: CSAnimationView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var btn_Signup: UIButton!
    var segues = [String]()
    var Icons = [String]()
   
    var URL_handler:URLhandler=URLhandler()
    var themes:Theme=Theme()
    var Citylistarray:NSMutableArray=NSMutableArray()
    var Cityidarray:NSMutableArray=NSMutableArray()
    let activityTypes: [NVActivityIndicatorType] = [
        .ballPulse]
   
    var trimmed_Location:String=String()
    let dropDownStart = DropDown()
    
    @IBOutlet var Email_But: UIButton!
    @IBOutlet var User_Name: UIButton!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var UserImage: UIImageView!
    @IBOutlet var signImage: UIImageView!
    @IBOutlet weak var BackButtonView: UIView!
    @IBOutlet weak var LogoutView: UIView!
    @IBOutlet weak var AccountLbl: UILabel!
    @IBOutlet weak var EditProfileLbl: UILabel!
    @IBOutlet weak var TopSeperatorview: UIView!
    @IBOutlet weak var VersionView: UIView!
    @IBOutlet weak var VersionLbl: UILabel!
    @IBOutlet weak var BOttomSeperatorview: UIView!
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var LogoutLbl: UILabel!
    @IBOutlet weak var LogoutImg: UIImageView!
    
    @IBOutlet weak var TableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TopViewHeight: NSLayoutConstraint!
    @IBOutlet weak var AnimationViewTop: NSLayoutConstraint!
 
    var arrayLanguage = ["English","Arabic","Hebrew"]
    //MARK: - Override Function
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "logout"), object: nil)
//        let nibName = UINib(nibName: "SlideCustomTableViewCell", bundle:nil)
//        self.tableView.register(nibName, forCellReuseIdentifier: "SlideCustomTableViewCell")
        tableView.register(UINib(nibName: "SlideCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "SlideCustomTableViewCell")
        let nibName1 = UINib(nibName: "LocationTableViewCell", bundle:nil)
        self.tableView.register(nibName1, forCellReuseIdentifier: "Cell")
//        NotificationCenter.default.addObserver(self, selector: #selector(MenuVC.LogoutMethod), name:NSNotification.Name(rawValue: "logout"), object: nil)
//        Appdel.getAppinformation()
        dropDownStart.dataSource = arrayLanguage
        self.view.backgroundColor =  .white
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if isLanguageManagement == 0{
            segues = [themes.setLang("home"),
                      themes.setLang("my_jobs"),
                      themes.setLang("my_earnings"),/*
                 themes.setLang("transactions_caps")/ //remove
                 themes.setLang("notifications_caps"),//remove
                 themes.setLang("reviews_caps"),*///remove
                      themes.setLang("report_issues"),
                themes.setLang("banking_details"),
                 
                themes.setLang("about"),/*
                 themes.setLang("chat_space"),*/
                
                themes.setLang("Language"),
//                      themes.setLang("Face Recognition"),
                themes.setLang("logout"),
                
                /*,
                
                 themes.setLang("logout")*/
            ]
          
            Icons = ["MenuHome","MenuOrders","menu_earnings","Report_Home","MenuBanking","About",/*"chaticon",*/"menu_language","logout-30"] /*,"Transaction","notification","review","Talk","Warning Shield"*/
        }else{
            segues = [themes.setLang("home"),
                      themes.setLang("my_jobs"),
                      themes.setLang("my_earnings"),/*
                 themes.setLang("transactions_caps")/ //remove
                 themes.setLang("notifications_caps"),//remove
                 themes.setLang("reviews_caps"),*///remove
                themes.setLang("my_docs_menu"),
                      themes.setLang("report_issues"),
                themes.setLang("banking_details"),/*
                 themes.setLang("chat_space"),*/
               
                themes.setLang("about"),
                themes.setLang("Language"),
//                      themes.setLang("Face Recognition"),
                themes.setLang("logout"),
                   
                /*themes.setLang("logout")*/
            ]

            Icons = ["MenuHome","MenuOrders","menu_earnings","Menu_Documents","Report_Home","MenuBanking"/*"chaticon",*/,"About-30","menu_language","logout"] /*,"Transaction","notification","review","Talk","Warning Shield"*/
        }
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension

        tableView.separatorColor=UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        Setdata()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.themes.MakeAnimation(view: self.animation_top_view, animation_type: CSAnimationTypePop)
//            self.animation_top_view.type = CSAnimationTypePop
//            self.animation_top_view.duration = 0.5
//            self.animation_top_view.delay = 0
//            self.animation_top_view.startCanvasAnimation()
        })
        animateTable()
    }
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        for i in cells {
            let cell: SlideCustomTableViewCell = i as! SlideCustomTableViewCell
            cell.animation_view.transform = CGAffineTransform(translationX: -self.view.frame.size.width, y: 0)
        }
        var index = 0
        for a in cells {
            let cell: SlideCustomTableViewCell = a as! SlideCustomTableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                cell.animation_view.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: -  Function
    
    func Setdata() {
        
        //Divya
//        Menu_dataMenu.Choose_Location=themes.getLocationname()
//        if theme.getEmailID() == ""{
//            btn_Signup.isHidden = false
//            btnSignIn.isHidden = false
//            signImage.isHidden = false
//            UserImage.isHidden = true
//            btn_Signup.setTitle(themes.setLang("register_caps"), for: UIControl.State())
//            btnSignIn.setTitle(themes.setLang("login"), for: UIControl.State())
//            btnSignIn.layer.cornerRadius = 5
//            btn_Signup.layer.cornerRadius = 5
//        } else{
            
            btn_Signup.isHidden = true
            btnSignIn.isHidden = true
            signImage.isHidden = true
            UserImage.isHidden = false
            tableView.isUserInteractionEnabled = true
            Email_But.setTitle("(\(themes.getCountryCode()))\(theme.getMobileNum())", for: UIControl.State())
            Email_But.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            UserImage.layer.cornerRadius=UserImage.frame.size.width/2
            UserImage.clipsToBounds=true
            
//        }
        
        if theme.getMobileNum() ==  ""{
            Email_But.setTitle("", for: UIControl.State())
        }
        
        self.VersionLbl.text = "\(self.themes.setLang("Version"))\(self.themes.version())"
        self.TopSeperatorview.backgroundColor = PlumberThemeColor
        self.BOttomSeperatorview.backgroundColor = PlumberThemeColor
        self.UserImage.layer.borderWidth = 1.5
        self.UserImage.layer.borderColor = PlumberThemeColor.cgColor
//        self.LogoutImg.image = LogoutImg.changeImageColor(color: PlumberThemeColor)
//        self.LogoutLbl.text = self.themes.setLang("logout")
//        self.LogoutLbl.textColor = PlumberThemeColor
//        self.AccountLbl.textColor = PlumberThemeColor
        print("the user name is\(themes.getUserName())")
//        User_Name.setTitle("\(self.themes.getfirstName())\(" ")\(self.themes.getlastName())", for: .normal)
        User_Name.setTitle(themes.getUserName(), for: .normal)
        User_Name.setTitleColor(.darkGray, for: .normal)
        User_Name.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
//        self.BackBtn.tintColor = PlumberThemeColor
//        trimmed_Location=Menu_dataMenu.Choose_Location.trimmingCharacters(in: CharacterSet.whitespaces)
        if theme.getuserDP().isEmpty{
            self.UserImage.image = UIImage(named:"UserPlaceholder")
        } else {
            UserImage.sd_setImage(with: URL(string: "\(theme.getuserDP())"), placeholderImage: UIImage(named: "UserPlaceholder"))
            User_Name.setTitleColor(PlumberThemeColor, for: .normal)
            User_Name.setTitle(self.themes.getUserName(), for: .normal)
            User_Name.titleLabel?.sizeToFit()
        }
    }
    
    
    func mainNavigationController() -> DLHamburguerNavigationController {
        return self.storyboard?.instantiateViewController(withIdentifier: "StarterNavVCSID") as! DLHamburguerNavigationController
    }
    func rootToChange()
    {
        let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootView: UINavigationController = sb.instantiateViewController(withIdentifier: "RootVCID") as! UINavigationController
        UIView.transition(with: appDel.window!, duration: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: {
            appDel.window?.rootViewController=rootView
        }, completion: nil)
    }
    func LogoutMethod()
    {
        self.theme.UpdateAvailability("0")
        let objUserRecs:UserInfoRecord=self.theme.GetUserDetails()
        let providerid = objUserRecs.providerId
        
        let Param: Dictionary = ["provider_id":"\(providerid as String)","device_type":"ios"]
        self.URL_handler.makeCall(Logout_url, param: Param as NSDictionary) { (responseObject, error) -> () in
            self.DismissProgress()
            
            if(error != nil)
            {
                self.view.makeToast(message:"Network Failure", duration: 4, position: HRToastPositionDefault as AnyObject, title: "")
            }
                
            else
            {
                print("the response is \(String(describing: responseObject))")
                if(responseObject != nil)
                {
                    let responseObject = responseObject!
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    
                    if(status == "0")
                    {
                    }
                    else
                    {
                    }
                    
                    SocketIOManager.sharedInstance.RemoveAllListener()
                    SocketIOManager.sharedInstance.LeaveRoom(providerid as String)
                    SocketIOManager.sharedInstance.LeaveChatRoom(providerid as String)
                    let dic: NSDictionary = NSDictionary()
                    self.theme .saveUserDetail(dic)
                    let loginController = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitialVCSID") as! InitialViewController
                    //or the homeController
                    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    let navController = UINavigationController(rootViewController: loginController)
                    appDel.window!.rootViewController! = navController
                    loginController.navigationController!.setNavigationBarHidden(true, animated: true)
                    
                }
                else
                {
                    self.view.makeToast(message: "Please try again", duration:3, position:HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                }
                
            }
            
        }
        
    }
    
    @IBAction func btnEditClickAction(_ sender: UIButton){
        let myViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "EditProfileVCSID") as? EditProfileViewController
        //        myViewController!.availabilityStorage = self.AvailableAllDaysArray
//        myViewController!.AvailablityArray = self.ObjAvailArray
//        myViewController?.delegate = self
        self.navigationController?.pushViewController(withFade: myViewController!, animated: false)
    }
    
    
    @IBAction func btnProfileClickAction(_sender : Any)
    {
//        ExpertProfileViewController
        Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "ExpertProfileID")
    }
    func showSendMailErrorAlert() {
        themes.AlertView(themes.setLang("not_send_email"), Message: themes.setLang("device_not_send_email"), ButtonTitle: kOk)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients([GetReceipientMail])
        mailComposerVC.setSubject("\(themes.setLang("report_on")) \(Appname) \(themes.setLang("ios_app"))")
        //mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
extension MenuVC : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var Count:Int=Int()
//        if themes.getEmailID() == "" {
//            Count = 0;
//        }  else{
            Count = segues.count
//        }
        return Count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCustomTableViewCell", for: indexPath) as! SlideCustomTableViewCell
//        if themes.getEmailID() == "" {
//            cell.Menulist.isHidden=true
//            cell.MenuIcon.isHidden=true
//        } else {
            cell.Menulist.isHidden=false
            cell.MenuIcon.isHidden=false
          
            cell.Menulist.text = segues[indexPath.row]
            cell.Menulist.textColor = .black
            cell.MenuIcon.image=UIImage(named:"\(Icons[indexPath.row])")
            cell.MenuIcon.image =  cell.MenuIcon.changeImageColor(color: PlumberThemeColor)
        
        if indexPath.row == 8
        {
            dropDownStart.anchorView = cell.Menulist
        }
            if(indexPath.row == 2){
                cell.Wallet_Amount.isHidden=false

                if theme.getCurrency() == "" {
//                    cell.Wallet_Amount.text="\(themes.getCurrencyCode())0"
                }else {
                    cell.Wallet_Amount.text="\(theme.getCurrencyCode())\(theme.getCurrency())"
                }
            } else {
                cell.Wallet_Amount.isHidden=true
//            }
        }
        return cell
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 0) {
            
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "StarterNavVCSID")
        }
        if(indexPath.row == 1) {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "MyJobsVCS")
        }
        if(indexPath.row == 2) {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "EarningNavVCID")
        }
        if(indexPath.row == 3) {
//            if ([objTheme.getDocumentStatus  isEqualToString:@"0"]) {
            let DocStatus = themes.getDocumentStatus()
            if DocStatus == "0"
            {
                let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "bankingVC") as! BankingInforViewControler
                self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
            } else {
                Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "MyDocumentsVC")
            }
        }
         if(indexPath.row == 4) {
             let mailComposeViewController = configuredMailComposeViewController()
             if MFMailComposeViewController.canSendMail() {
                 self.present(mailComposeViewController, animated: true, completion: nil)
             } else {
                 self.showSendMailErrorAlert()
             }
         }
        if(indexPath.row == 5) {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "bankingVC")
        }

        if (indexPath.row == 6){
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "AboutusVCSID")
        }
        if (indexPath.row == 7){
            dropDownStart.show()
                    dropDownStart.selectionAction = { [unowned self] (index: Int, item: String) in
                        print(item)
                        if item == "English"
                        {
                            themes.saveLanguage("en")
                            UIView.appearance().semanticContentAttribute = .forceLeftToRight
                            UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
                            themes.SetLanguageToApp()
                            SwapLanguage(language: themes.getAppLanguage())
                            rootToChange()
                        }
                        else if item == "Arabic"
                        {
                            themes.saveLanguage("ar")
                            UIView.appearance().semanticContentAttribute = .forceRightToLeft
                            UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
                            themes.SetLanguageToApp()
                            SwapLanguage(language: themes.getAppLanguage())
                            rootToChange()
                        }
                        else
                        {
                            themes.saveLanguage("he")
                            UIView.appearance().semanticContentAttribute = .forceRightToLeft
                            UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
                            themes.SetLanguageToApp()
                            SwapLanguage(language: themes.getAppLanguage())
                            rootToChange()
                        }
                    }
        }
         //objTheme setLang: @"Logout_hme"
         
    
        if (indexPath.row == 8){
            let myObject = themes.appName() as String
            let alert = UIAlertController(title: myObject, message: themes.setLang("Logout_hme"), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: themes.setLang("ok"), style: .default, handler: { action in
                self.LogoutMethod()
            }))
            alert.addAction(UIAlertAction.init(title: themes.setLang("cancel"), style: UIAlertAction.Style.destructive, handler: nil))
           DispatchQueue.main.async(execute: { self.present(alert, animated: true, completion: nil) })
//            self.LogoutoftheApp()
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
