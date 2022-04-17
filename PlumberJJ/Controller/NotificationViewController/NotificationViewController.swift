//
//  NotificationViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 10/29/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var notificationTblView: UITableView!
    
    
    @IBOutlet weak var title_Lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.title_Lbl.text = theme.setLang("notifications")
        // Do any additional setup after loading the view.
    }

    @IBAction func didClickBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifTableCellIdentifier", for: indexPath) as! NotificationTableViewCell
        cell.loadNotificationTableCell("")
        cell.selectionStyle=UITableViewCell.SelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MyOrderDetailOpenVCSID
        let objMyOrderVc = self.storyboard!.instantiateViewController(withIdentifier: "MyOrderDetailOpenVCSID") as! MyOrderOpenDetailViewController
        self.navigationController!.pushViewController(withFade: objMyOrderVc, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
