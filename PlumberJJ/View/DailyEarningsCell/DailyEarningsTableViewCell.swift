//
//  DailyEarningsTableViewCell.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 8/13/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class DailyEarningsTableViewCell: UITableViewCell {
    @IBOutlet weak var ShadowView: UIView!
    @IBOutlet weak var BookingIdLbl: UILabel!
    @IBOutlet weak var CategoryTypeLbl: UILabel!
    @IBOutlet weak var AmmountLbl: UILabel!
    @IBOutlet weak var TasksEarningsIndicatoLbl: UILabel!
    @IBOutlet weak var AddressLbl: UILabel!
    
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var DateAndTimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ShadowView.dropShadow(shadowRadius: 3)
        self.ShadowView.layer.cornerRadius = 6
        self.locationImg.tintColor = .gray
        self.timeImage.tintColor = .gray
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
