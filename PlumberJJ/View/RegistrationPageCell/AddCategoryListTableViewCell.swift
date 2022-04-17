//
//  AddCategoryListTableViewCell.swift
//  PlumberJJ
//
//  Created by Casperon iOS on 04/10/17.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class AddCategoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var cat_lbl: UILabel!
    
    @IBOutlet weak var delete_btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
