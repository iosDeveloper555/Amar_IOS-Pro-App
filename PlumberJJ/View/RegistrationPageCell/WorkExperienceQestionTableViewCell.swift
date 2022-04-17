//
//  WorkExperienceQestionTableViewCell.swift
//  PlumberJJ
//
//  Created by Casperon iOS on 03/10/17.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class WorkExperienceQestionTableViewCell: UITableViewCell {
    @IBOutlet weak var qestion_lbl: UILabel!
    @IBOutlet weak var ans_textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
