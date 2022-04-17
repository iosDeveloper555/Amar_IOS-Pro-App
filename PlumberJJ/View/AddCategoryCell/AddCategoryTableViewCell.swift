//
//  AddCategoryTableViewCell.swift
//  PlumberJJ
//
//  Created by Gurulakshmi's Mac Mini on 01/08/18.
//  Copyright © 2018 Casperon Technologies. All rights reserved.
//

import UIKit

class AddCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var categoryLbl: CustomLabel!
    @IBOutlet weak var borderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
