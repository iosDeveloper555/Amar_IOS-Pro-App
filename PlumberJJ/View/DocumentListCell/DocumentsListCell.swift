//
//  DocumentsListCell.swift
//  PlumberJJ
//
//  Created by Gokul's Mac Mini on 28/11/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class DocumentsListCell: UITableViewCell {
    @IBOutlet weak var cardview : UIView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var editBtn : UIButton!
    @IBOutlet weak var documentImg : UIImageView!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var btnEditDate : UIButton!
    @IBOutlet weak var btnUpdate: HeaderbuttonStyle!
    
    @IBOutlet weak var constUpdateBtn: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardview.layer.borderWidth = 1
        cardview.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
