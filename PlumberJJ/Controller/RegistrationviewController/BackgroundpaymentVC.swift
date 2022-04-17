//
//  BackgroundpaymentVC.swift
//  PlumberJJ
//
//  Created by Amarendra on 16/04/22.
//  Copyright © 2022 Casperon Technologies. All rights reserved.
//

import UIKit
import WebKit

//MARK: paymentFuctDelegate
protocol paymentFuctDelegate
{
func paymentFuctionDelegate(_ url: String)
}



class BackgroundpaymentVC: UIViewController, WKUIDelegate {

    @IBOutlet weak var openUrlView: WKWebView!
    var link = ""
    var delegate:paymentFuctDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openUrlView.uiDelegate=self
        if let url = URL (string: link)
        {
            let requestObj = URLRequest(url: url)
            openUrlView.load(requestObj)
        }
        openUrlView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)


        // Do any additional setup after loading the view.
    }
    @IBAction func gobAck(_ sender: UIButton)
    {
        self.delegate?.paymentFuctionDelegate("")

        self.navigationController?.popViewControllerwithFade(animated: false)
    }
  
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {
            print("observeValue \(key)") // url value
            if let url = key as? URL
            {
                let str = url.absoluteString
                if str.contains("https://dev.via-hive.com/")
                {
                  
                    self.delegate?.paymentFuctionDelegate(str)
                    self.navigationController?.popViewControllerwithFade(animated: false)

                }

            }

        }
    }
    

}
