//
//  JJSlideMenuTableViewCell.swift
//  PlumberJJ
//
//  Created by Aravind Natarajan on 28/12/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class JJSlideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
