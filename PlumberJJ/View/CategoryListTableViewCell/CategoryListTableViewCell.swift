//
//  CategoryListTableViewCell.swift
//  PlumberJJ
//
//  Created by casperon_macmini on 30/05/17.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {

    @IBOutlet var delete_Btn: UIButton!
    @IBOutlet var edit_Btn: UIButton!
    @IBOutlet var categotyName_Lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
