//
//  AboutUSViewController.swift
//  PlumberJJ
//
//  Created by Casperon on 03/10/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

import UIKit
import WebKit
class AboutUSViewController: RootBaseViewController {
   @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet var abtwebview: WKWebView!
    @IBOutlet var titlelabl: UILabel!
    @IBOutlet var menubtn: UIButton!
    @IBOutlet weak var HeaderViewheight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.theme.yesTheDeviceisHavingNotch(){
            HeaderViewheight.constant = 100
        }
   menubtn.addTarget(self, action: #selector(AboutUSViewController.openmenu), for: .touchUpInside)
        // Do any additional setup after loading the view.
        let version = ( Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
        titleHeader.text = Language_handler.VJLocalizedString("about_us", comment: nil)
        titlelabl.text = "\(Language_handler.VJLocalizedString("powered_by", comment: nil)) : \(ProductAppName) (\(version))"
    titleHeader.adjustsFontSizeToFitWidth = true
        titlelabl.adjustsFontSizeToFitWidth = true
        
        //versionlabl.text = "\(Language_handler.VJLocalizedString("version", comment: nil)) : "
        
        let url = URL (string:about_usURL);
        let requestObj = URLRequest(url: url!);
        abtwebview.load(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func openmenu(){
//        self.view.endEditing(true)
//        self.frostedViewController.view.endEditing(true)
//        // Present the view controller
//        //
//        self.frostedViewController.presentMenuViewController()
        self.findHamburguerViewController()?.showMenuViewController()
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
