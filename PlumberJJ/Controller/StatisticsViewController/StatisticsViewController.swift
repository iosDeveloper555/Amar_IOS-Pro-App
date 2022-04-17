//
//  StatisticsViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/2/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class StatisticsViewController: RootBaseViewController {

    @IBOutlet weak var swiftPagesView: SwiftPages!
    @IBOutlet weak var titleHeader: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        titleHeader.text = Language_handler.VJLocalizedString("statistics", comment: nil)
        //Initiation
        let VCIDs : [String] = ["BarChartViewControllerVCSID", "PieChartViewControllerVCSID"]
        let titles : [String] = [Language_handler.VJLocalizedString("earning_stats", comment: nil), Language_handler.VJLocalizedString("jobs_stats", comment: nil)]
        
        //Sample customization
        swiftPagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: titles)
       

        swiftPagesView.setTopBarBackground(PlumberLightGrayColor)
        swiftPagesView.setAnimatedBarColor(PlumberThemeColor)
//        totalContainer.addSubview(swiftPagesView)
    }
    func  addTapped() {
        
    }
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewControllerWithFlip(animated: true)
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
