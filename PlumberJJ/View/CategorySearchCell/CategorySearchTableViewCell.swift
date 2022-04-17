//
//  CategorySearchTableViewCell.swift
//  PlumberJJ
//
//  Created by Gurulakshmi's Mac Mini on 31/07/18.
//  Copyright © 2018 Casperon Technologies. All rights reserved.
//

import UIKit

class CategorySearchTableViewCell: UITableViewCell {

    @IBOutlet weak var catlable: CustomLabel!
    @IBOutlet weak var catimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
