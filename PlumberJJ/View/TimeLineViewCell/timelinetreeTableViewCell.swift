//
//  timelinetreeTableViewCell.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 7/16/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class timelinetreeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var bottomView: SetColorView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var topView: SetColorView!
    @IBOutlet weak var chainIcon_img: UIImageView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var time_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chainIcon_img.tintColor = PlumberThemeColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
