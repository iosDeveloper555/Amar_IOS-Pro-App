//
//  OpenimageVC.swift
//  Plumbal
//
//  Created by Casperon on 03/05/17.
//  Copyright © 2017 Casperon Tech. All rights reserved.
//

import UIKit
import SDWebImage
protocol OpenimageVCDelegate {
    
    func pressedCancel(sender: OpenimageVC)
}

class OpenimageVC: UIViewController {
    
    var delegate:OpenimageVCDelegate?
    var getimage : NSString!
    

    @IBOutlet var openimg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        openimg.sd_setImage(with: NSURL(string: getimage as String) as! URL)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didclickcolse(sender: AnyObject) {
        self.delegate?.pressedCancel(sender: self)
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
