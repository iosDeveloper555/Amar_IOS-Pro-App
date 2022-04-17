//
//  WeeklyReportTableViewCell.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 8/12/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class WeeklyReportTableViewCell: UITableViewCell {

    @IBOutlet weak var ShadowView: UIView!
    @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var AmmountLbl: UILabel!
    @IBOutlet weak var NetfareLbl: UILabel!
    @IBOutlet weak var NoOfTasksLbl: UILabel!
    @IBOutlet weak var TasksLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ShadowView.dropShadow(shadowRadius: 6)
        self.ShadowView.layer.cornerRadius = 6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
