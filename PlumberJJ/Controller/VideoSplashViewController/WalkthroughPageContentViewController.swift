//
//  WalkthroughPageContentViewController.swift
//  Doc2YourDoorHkCustomer
//
//  Created by Eddie Lau on 22/11/14.
//  Copyright (c) 2014 42 Labs. All rights reserved.
//

import UIKit

class WalkthroughPageContentViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var descLbl: UILabel!
    var pageIndex: NSInteger = 0
    var titleText: NSString?
     var imgText: NSString?
     var descText: NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        messageLabel.text = titleText! as String;
        descLbl.text=descText! as String;
        descLbl.sizeToFit()
        imgView.image=UIImage(named: imgText as! String)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
