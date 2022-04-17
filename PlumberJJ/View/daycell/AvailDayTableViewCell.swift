//
//  AvailDayTableViewCell.swift
//  PlumberJJ
//
//  Created by Gurulakshmi's Mac Mini on 26/07/18.
//  Copyright © 2018 Casperon Technologies. All rights reserved.
//

import UIKit

class AvailDayTableViewCell: UITableViewCell {
 @IBOutlet weak var DayLbl: CustomLabel!
 @IBOutlet weak var dayswitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
