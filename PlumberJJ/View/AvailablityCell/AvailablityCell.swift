//
//  AvailablityCell.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 6/26/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class AvailablityCell: UITableViewCell {

    @IBOutlet weak var AddorEdit: UIButton!
    @IBOutlet weak var DaysLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.AddorEdit.setTitleColor(PlumberThemeColor, for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
