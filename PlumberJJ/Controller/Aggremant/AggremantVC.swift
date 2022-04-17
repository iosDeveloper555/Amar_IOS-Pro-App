//
//  AggremantVC.swift
//  PlumberJJ
//
//  Created by romil Sheth on 18/11/21.
//  Copyright © 2021 Casperon Technologies. All rights reserved.
//

import UIKit
import WebKit
class AggremantVC: UIViewController,WKNavigationDelegate {
    @IBOutlet weak var webview:WKWebView!
    var PhoneDict = NSDictionary()
    var emailVerify = String()
    var socialtype = String()
    var socialId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.navigationDelegate=self
        let url = URL(string:Aggremant_Domain )//RegUrl
        let request = URLRequest(url: url!)
        webview.load(request)
    }
    func MoveToRegister(){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFirstPageViewController") as? RegFirstPageViewController{
            if let navigator = self.navigationController
            {
               
                viewController.PhoneDict = PhoneDict
                viewController.emailVerify = emailVerify
                viewController.socialtype = self.socialtype
                viewController.socialId = self.socialId
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
    }
    @IBAction func btnbackAction(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNextAction(_ sender : UIButton)
    {
        self.MoveToRegister()
    }
    
}
