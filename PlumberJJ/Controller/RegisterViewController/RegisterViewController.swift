//
//  RegisterViewController.swift
//  PlumberJJ
//
//  Created by Aravind Natarajan on 30/12/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit
import WebKit
class RegisterViewController: RootBaseViewController,WKNavigationDelegate {
    var theBool: Bool=Bool()
    var myTimer: Timer=Timer()
     var urlstring:String = ""
    @IBOutlet weak var titleHeader: UILabel!
    
    @IBOutlet var Webload_progress: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string:RegUrl )//RegUrl
        
        Webload_progress.tintColor=theme.ThemeColour()
        
        let request = URLRequest(url: url!)
        self.Webload_progress.progress = 0.0
  
        webView.navigationDelegate=self
        titleHeader.text = Language_handler.VJLocalizedString("register", comment: nil)

        let transform:CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 2.0);
        Webload_progress.transform = transform;
        
 
        webView.load(request)
        //Swift 2.2 selector syntax
        //Swift <2.2 selector syntax
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func applicationLanguageChangeNotification(_ notification: Notification) {
        
        titleHeader.text = Language_handler.VJLocalizedString("register", comment: nil)
    }
    
    // must be internal or public.
    @objc func update() {
        // Something cool
        let appDelegate = (UIApplication.shared.delegate! as! AppDelegate)
        let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialVCSID")
        //or the homeController
        let navController = UINavigationController(rootViewController: loginController)
        appDelegate.window!.rootViewController! = navController
        loginController.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
  
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        funcToCallWhenStartLoadingYourWebview()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        funcToCallCalledWhenUIWebViewFinishesLoading()
    }
    
    func funcToCallWhenStartLoadingYourWebview() {
        self.theBool = false
        self.myTimer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    func funcToCallCalledWhenUIWebViewFinishesLoading() {
        self.theBool = true
    }
    
    @objc func timerCallback() {
        if self.theBool {
            if self.Webload_progress.progress >= 1 {
                self.Webload_progress.isHidden = true
                //ew3 self.myTimer.invalidate()
            } else {
                self.Webload_progress.progress += 0.1
            }
        } else {
            self.Webload_progress.progress += 0.05
            if self.Webload_progress.progress >= 0.95 {
                self.Webload_progress.progress = 0.95
            }
        }
    }
    
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewControllerWithFlip(animated: true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let URL:NSString=(navigationAction.request.url?.absoluteString)! as NSString
        NSLog("get url string =%@", URL)
        
        if(URL.contains("/provider/register/success"))
            
        {
            self.theme.AlertView("", Message: "\(Language_handler.VJLocalizedString("signup_thanku", comment: nil)) \(appNameJJ) \(Language_handler.VJLocalizedString("signup_thanku1", comment: nil))", ButtonTitle:kOk)
        
            _ = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(RegisterViewController.update), userInfo: nil, repeats: false)
          
            
        }
        else if(URL.contains("/provider/register/cancel"))
        {
            self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
        }
        else if (URL.contains("/provider/register/failed"))
        {
            self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
        }
        
        decisionHandler(.allow)
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
